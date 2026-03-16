/**
 * 商品分类控制器
 */
const { getPool } = require('../config/database');
const { cache } = require('../config/redis');
const logger = require('../utils/logger');
const { AppError } = require('../middleware/errorHandler');

class CategoryController {
  /**
   * 获取分类列表（管理后台用）
   */
  static async list(req, res, next) {
    const { parent_id, status, is_active } = req.query;

    try {
      const pool = getPool();
      const conditions = [];
      const params = [];

      if (parent_id !== undefined) {
        if (parent_id === 'null' || parent_id === '') {
          conditions.push('parent_id IS NULL');
        } else {
          conditions.push('parent_id = ?');
          params.push(parseInt(parent_id));
        }
      }

      if (status !== undefined) {
        conditions.push('status = ?');
        params.push(parseInt(status));
      }

      if (is_active !== undefined) {
        conditions.push('is_active = ?');
        params.push(is_active === 'true' ? 1 : 0);
      }

      const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

      const [rows] = await pool.execute(
        `SELECT 
          id, parent_id, name, code, icon, image, description,
          sort_order, level, is_active, status, created_at, updated_at
        FROM product_categories 
        ${whereClause} 
        ORDER BY sort_order, id`,
        params
      );

      // 查询每个分类的商品数量
      const categories = await Promise.all(
        rows.map(async (cat) => {
          const [countRows] = await pool.execute(
            'SELECT COUNT(*) as count FROM products WHERE category_id = ? AND deleted_at IS NULL',
            [cat.id]
          );
          return {
            ...cat,
            product_count: countRows[0].count,
          };
        })
      );

      res.json({
        success: true,
        data: categories,
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
      const pool = getPool();
      const [rows] = await pool.execute(
        'SELECT * FROM product_categories WHERE is_active = 1 ORDER BY sort_order, id'
      );

      // 构建树形结构
      const tree = this.buildTree(rows);

      res.json({
        success: true,
        data: tree,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取分类详情
   */
  static async getById(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();
      const [rows] = await pool.execute(
        'SELECT * FROM product_categories WHERE id = ?',
        [id]
      );

      if (rows.length === 0) {
        throw new AppError('分类不存在', 404, 'CATEGORY_NOT_FOUND');
      }

      // 查询子分类数量
      const [countRows] = await pool.execute(
        'SELECT COUNT(*) as count FROM product_categories WHERE parent_id = ?',
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
    const { name, code, parent_id, icon, image, description, sort_order = 0 } = req.body;

    try {
      const pool = getPool();

      // 检查 code 是否已存在
      if (code) {
        const [existing] = await pool.execute(
          'SELECT id FROM product_categories WHERE code = ?',
          [code]
        );
        if (existing.length > 0) {
          throw new AppError('分类代码已存在', 409, 'DUPLICATE_CODE');
        }
      }

      // 如果指定了父分类，检查是否存在
      let level = 1;
      if (parent_id) {
        const [parent] = await pool.execute(
          'SELECT id, level FROM product_categories WHERE id = ?',
          [parent_id]
        );

        if (parent.length === 0) {
          throw new AppError('父分类不存在', 404, 'PARENT_CATEGORY_NOT_FOUND');
        }

        // 检查层级深度（最多 3 级）
        if (parent[0].level >= 3) {
          throw new AppError('分类层级不能超过 3 级', 400, 'MAX_LEVEL_EXCEEDED');
        }

        level = parent[0].level + 1;
      }

      // 生成 code（如果没有提供）
      const finalCode = code || `cat_${Date.now()}`;

      // 插入分类
      const [result] = await pool.execute(
        `INSERT INTO product_categories 
          (name, code, parent_id, icon, image, description, level, sort_order, is_active, status) 
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, 1)`,
        [name, finalCode, parent_id || null, icon || null, image || null, description || null, level, sort_order]
      );

      logger.info(`Category created: ${name} (ID: ${result.insertId})`);

      res.status(201).json({
        success: true,
        message: '分类创建成功',
        data: { id: result.insertId, code: finalCode },
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
    const { name, code, parent_id, icon, image, description, sort_order, is_active } = req.body;

    try {
      const pool = getPool();

      // 检查分类是否存在
      const [existing] = await pool.execute(
        'SELECT id, level FROM product_categories WHERE id = ?',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('分类不存在', 404, 'CATEGORY_NOT_FOUND');
      }

      // 不能将自己设为父分类
      if (parent_id && parseInt(parent_id) === parseInt(id)) {
        throw new AppError('不能将自己设为父分类', 400, 'INVALID_PARENT');
      }

      // 检查 code 是否重复
      if (code) {
        const [duplicate] = await pool.execute(
          'SELECT id FROM product_categories WHERE code = ? AND id != ?',
          [code, id]
        );
        if (duplicate.length > 0) {
          throw new AppError('分类代码已存在', 409, 'DUPLICATE_CODE');
        }
      }

      // 检查父分类是否存在
      if (parent_id) {
        const [parent] = await pool.execute(
          'SELECT id, level FROM product_categories WHERE id = ?',
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
      if (code !== undefined) {
        fields.push('code = ?');
        values.push(code);
      }
      if (parent_id !== undefined) {
        fields.push('parent_id = ?');
        values.push(parent_id || null);
      }
      if (icon !== undefined) {
        fields.push('icon = ?');
        values.push(icon);
      }
      if (image !== undefined) {
        fields.push('image = ?');
        values.push(image);
      }
      if (description !== undefined) {
        fields.push('description = ?');
        values.push(description);
      }
      if (sort_order !== undefined) {
        fields.push('sort_order = ?');
        values.push(sort_order);
      }
      if (is_active !== undefined) {
        fields.push('is_active = ?');
        values.push(is_active ? 1 : 0);
      }

      if (fields.length > 0) {
        values.push(id);
        await pool.execute(
          `UPDATE product_categories SET ${fields.join(', ')} WHERE id = ?`,
          values
        );
      }

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
      'SELECT parent_id FROM product_categories WHERE id = ?',
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
        'SELECT id FROM product_categories WHERE id = ?',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('分类不存在', 404, 'CATEGORY_NOT_FOUND');
      }

      // 检查是否有子分类
      const [children] = await pool.execute(
        'SELECT id FROM product_categories WHERE parent_id = ?',
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
      await pool.execute('DELETE FROM product_categories WHERE id = ?', [id]);

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
   * 批量删除分类
   */
  static async batchDelete(req, res, next) {
    const { ids } = req.body;

    try {
      if (!Array.isArray(ids) || ids.length === 0) {
        throw new AppError('请选择要删除的分类', 400, 'INVALID_IDS');
      }

      const pool = getPool();
      const placeholders = ids.map(() => '?').join(',');

      // 检查是否有子分类或商品
      const [children] = await pool.execute(
        `SELECT COUNT(*) as count FROM product_categories WHERE parent_id IN (${placeholders})`,
        ids
      );

      if (children[0].count > 0) {
        throw new AppError('部分分类存在子分类，无法删除', 400, 'HAS_CHILDREN');
      }

      const [products] = await pool.execute(
        `SELECT COUNT(*) as count FROM products WHERE category_id IN (${placeholders}) AND deleted_at IS NULL`,
        ids
      );

      if (products[0].count > 0) {
        throw new AppError('部分分类下存在商品，无法删除', 400, 'HAS_PRODUCTS');
      }

      // 删除分类
      await pool.execute(`DELETE FROM product_categories WHERE id IN (${placeholders})`, ids);

      res.json({
        success: true,
        message: `成功删除 ${ids.length} 个分类`,
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
    const { is_active } = req.body;

    try {
      const pool = getPool();

      if (is_active === undefined) {
        throw new AppError('请提供 is_active 参数', 400, 'INVALID_PARAM');
      }

      const [result] = await pool.execute(
        'UPDATE product_categories SET is_active = ? WHERE id = ?',
        [is_active ? 1 : 0, id]
      );

      if (result.affectedRows === 0) {
        throw new AppError('分类不存在', 404, 'CATEGORY_NOT_FOUND');
      }

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
