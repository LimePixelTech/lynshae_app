/**
 * 分类控制器
 */
const { getPool } = require('../config/database');
const { cache } = require('../config/redis');
const config = require('../config');
const logger = require('../utils/logger');
const { AppError } = require('../middleware/errorHandler');

class CategoryController {
  /**
   * 获取分类列表
   */
  static async list(req, res, next) {
    const { parent_id, status } = req.query;

    try {
      // 尝试从缓存获取
      const cacheKey = `category:list:${parent_id || 'all'}:${status || 'all'}`;
      const cached = await cache.get(cacheKey);
      if (cached) {
        return res.json({
          success: true,
          data: cached,
        });
      }

      const pool = getPool();
      const conditions = [];
      const params = [];

      if (parent_id !== undefined) {
        conditions.push('parent_id ' + (parent_id === 'null' ? 'IS NULL' : '= ?'));
        if (parent_id !== 'null') {
          params.push(parseInt(parent_id));
        }
      }

      if (status !== undefined) {
        conditions.push('status = ?');
        params.push(parseInt(status));
      }

      const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

      const [rows] = await pool.execute(
        `SELECT * FROM categories ${whereClause} ORDER BY sort_order, id`,
        params
      );

      // 缓存
      await cache.set(cacheKey, rows, config.cache.category.ttl);

      res.json({
        success: true,
        data: rows,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取分类树形结构
   */
  static async getTree(req, res, next) {
    try {
      // 尝试从缓存获取
      const cached = await cache.get('category:tree');
      if (cached) {
        return res.json({
          success: true,
          data: cached,
        });
      }

      const pool = getPool();
      const [rows] = await pool.execute(
        'SELECT * FROM categories WHERE status = 1 ORDER BY sort_order, id'
      );

      // 构建树形结构
      const tree = this.buildTree(rows);

      // 缓存
      await cache.set('category:tree', tree, config.cache.category.ttl);

      res.json({
        success: true,
        data: tree,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 构建树形结构辅助函数
   */
  static buildTree(categories, parentId = null) {
    return categories
      .filter(cat => cat.parent_id === parentId)
      .map(cat => ({
        ...cat,
        children: this.buildTree(categories, cat.id),
      }));
  }

  /**
   * 获取分类详情
   */
  static async getById(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();
      const [rows] = await pool.execute(
        'SELECT * FROM categories WHERE id = ?',
        [id]
      );

      if (rows.length === 0) {
        throw new AppError('分类不存在', 404, 'CATEGORY_NOT_FOUND');
      }

      // 查询子分类数量
      const [countRows] = await pool.execute(
        'SELECT COUNT(*) as count FROM categories WHERE parent_id = ?',
        [id]
      );

      // 查询商品数量
      const [productRows] = await pool.execute(
        'SELECT COUNT(*) as count FROM products WHERE category_id = ? AND deleted_at IS NULL',
        [id]
      );

      const category = {
        ...rows[0],
        children_count: countRows[0].count,
        product_count: productRows[0].count,
      };

      res.json({
        success: true,
        data: category,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 创建分类
   */
  static async create(req, res, next) {
    const { name, parent_id, icon, sort_order = 0 } = req.body;

    try {
      const pool = getPool();

      // 如果指定了父分类，检查是否存在
      if (parent_id) {
        const [parent] = await pool.execute(
          'SELECT id, level FROM categories WHERE id = ?',
          [parent_id]
        );

        if (parent.length === 0) {
          throw new AppError('父分类不存在', 404, 'PARENT_CATEGORY_NOT_FOUND');
        }

        // 检查层级深度 (最多 3 级)
        if (parent[0].level >= 3) {
          throw new AppError('分类层级不能超过 3 级', 400, 'MAX_LEVEL_EXCEEDED');
        }
      }

      // 插入分类
      const [result] = await pool.execute(
        'INSERT INTO categories (name, parent_id, icon, level, sort_order, status) VALUES (?, ?, ?, ?, ?, 1)',
        [name, parent_id || null, icon || null, parent_id ? (await pool.execute('SELECT level FROM categories WHERE id = ?', [parent_id]))[0][0].level + 1 : 1, sort_order]
      );

      // 重新计算 level
      const level = parent_id ? (await pool.execute('SELECT level FROM categories WHERE id = ?', [parent_id]))[0][0].level + 1 : 1;
      await pool.execute('UPDATE categories SET level = ? WHERE id = ?', [level, result.insertId]);

      // 清除缓存
      await cache.delPattern('category:*');

      logger.info(`Category created: ${name} (ID: ${result.insertId})`);

      res.status(201).json({
        success: true,
        message: '分类创建成功',
        data: { id: result.insertId },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 更新分类
   */
  static async update(req, res, next) {
    const { id } = req.params;
    const { name, parent_id, icon, sort_order } = req.body;

    try {
      const pool = getPool();

      // 检查分类是否存在
      const [existing] = await pool.execute(
        'SELECT id, level FROM categories WHERE id = ?',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('分类不存在', 404, 'CATEGORY_NOT_FOUND');
      }

      // 不能将自己设为父分类
      if (parent_id && parseInt(parent_id) === parseInt(id)) {
        throw new AppError('不能将自己设为父分类', 400, 'INVALID_PARENT');
      }

      // 检查父分类是否存在
      if (parent_id) {
        const [parent] = await pool.execute(
          'SELECT id, level FROM categories WHERE id = ?',
          [parent_id]
        );

        if (parent.length === 0) {
          throw new AppError('父分类不存在', 404, 'PARENT_CATEGORY_NOT_FOUND');
        }

        // 检查是否形成循环
        if (this.isDescendant(parent_id, id, pool)) {
          throw new AppError('不能将子分类设为父分类', 400, 'CIRCULAR_REFERENCE');
        }
      }

      // 更新分类
      const fields = [];
      const values = [];

      if (name !== undefined) {
        fields.push('name = ?');
        values.push(name);
      }
      if (parent_id !== undefined) {
        fields.push('parent_id = ?');
        values.push(parent_id || null);
      }
      if (icon !== undefined) {
        fields.push('icon = ?');
        values.push(icon);
      }
      if (sort_order !== undefined) {
        fields.push('sort_order = ?');
        values.push(sort_order);
      }

      if (fields.length > 0) {
        values.push(id);
        await pool.execute(
          `UPDATE categories SET ${fields.join(', ')} WHERE id = ?`,
          values
        );
      }

      // 清除缓存
      await cache.delPattern('category:*');

      logger.info(`Category updated: ID ${id}`);

      res.json({
        success: true,
        message: '分类更新成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 检查是否是后代分类
   */
  static async isDescendant(potentialDescendantId, ancestorId, pool) {
    if (potentialDescendantId === ancestorId) {
      return true;
    }

    const [rows] = await pool.execute(
      'SELECT parent_id FROM categories WHERE id = ?',
      [potentialDescendantId]
    );

    if (rows.length === 0 || rows[0].parent_id === null) {
      return false;
    }

    return this.isDescendant(rows[0].parent_id, ancestorId, pool);
  }

  /**
   * 删除分类
   */
  static async delete(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();

      // 检查分类是否存在
      const [existing] = await pool.execute(
        'SELECT id FROM categories WHERE id = ?',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('分类不存在', 404, 'CATEGORY_NOT_FOUND');
      }

      // 检查是否有子分类
      const [children] = await pool.execute(
        'SELECT id FROM categories WHERE parent_id = ?',
        [id]
      );

      if (children.length > 0) {
        throw new AppError('请先删除子分类', 400, 'HAS_CHILDREN');
      }

      // 检查是否有关联商品
      const [products] = await pool.execute(
        'SELECT id FROM products WHERE category_id = ? AND deleted_at IS NULL',
        [id]
      );

      if (products.length > 0) {
        throw new AppError('分类下存在商品，无法删除', 400, 'HAS_PRODUCTS');
      }

      // 删除分类
      await pool.execute('DELETE FROM categories WHERE id = ?', [id]);

      // 清除缓存
      await cache.delPattern('category:*');

      logger.info(`Category deleted: ID ${id}`);

      res.json({
        success: true,
        message: '分类删除成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 更新分类状态
   */
  static async updateStatus(req, res, next) {
    const { id } = req.params;
    const { status } = req.body;

    try {
      const pool = getPool();

      if (![0, 1].includes(parseInt(status))) {
        throw new AppError('状态必须为 0 或 1', 400, 'INVALID_STATUS');
      }

      const [result] = await pool.execute(
        'UPDATE categories SET status = ? WHERE id = ?',
        [status, id]
      );

      if (result.affectedRows === 0) {
        throw new AppError('分类不存在', 404, 'CATEGORY_NOT_FOUND');
      }

      // 清除缓存
      await cache.delPattern('category:*');

      res.json({
        success: true,
        message: '状态更新成功',
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = CategoryController;
