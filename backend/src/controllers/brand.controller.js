/**
 * 品牌控制器
 */
const { getPool } = require('../config/database');
const logger = require('../utils/logger');
const { AppError } = require('../middleware/errorHandler');

class BrandController {
  /**
   * 获取品牌列表
   */
  static async list(req, res, next) {
    const { status, keyword } = req.query;

    try {
      const pool = getPool();
      const conditions = [];
      const params = [];

      if (status !== undefined) {
        conditions.push('status = ?');
        params.push(parseInt(status));
      }

      if (keyword) {
        conditions.push('(name LIKE ? OR en_name LIKE ?)');
        const keywordPattern = `%${keyword}%`;
        params.push(keywordPattern, keywordPattern);
      }

      const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

      const [rows] = await pool.execute(
        `SELECT 
          id, name, en_name, logo, description, website, sort_order, status, created_at, updated_at
        FROM brands 
        ${whereClause} 
        ORDER BY sort_order, id`,
        params
      );

      res.json({
        success: true,
        data: rows,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取品牌详情
   */
  static async getById(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();
      const [rows] = await pool.execute(
        'SELECT * FROM brands WHERE id = ?',
        [id]
      );

      if (rows.length === 0) {
        throw new AppError('品牌不存在', 404, 'BRAND_NOT_FOUND');
      }

      // 查询商品数量
      const [productRows] = await pool.execute(
        'SELECT COUNT(*) as count FROM products WHERE brand = ? AND deleted_at IS NULL',
        [rows[0].name]
      );

      const brand = {
        ...rows[0],
        product_count: productRows[0].count,
      };

      res.json({
        success: true,
        data: brand,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 创建品牌
   */
  static async create(req, res, next) {
    const { name, en_name, logo, description, website, sort_order = 0 } = req.body;

    try {
      const pool = getPool();

      // 检查名称是否已存在
      const [existing] = await pool.execute(
        'SELECT id FROM brands WHERE name = ? OR en_name = ?',
        [name, en_name]
      );

      if (existing.length > 0) {
        throw new AppError('品牌名称已存在', 409, 'DUPLICATE_BRAND');
      }

      // 插入品牌
      const [result] = await pool.execute(
        `INSERT INTO brands (name, en_name, logo, description, website, sort_order, status) 
         VALUES (?, ?, ?, ?, ?, ?, 1)`,
        [name, en_name || null, logo || null, description || null, website || null, sort_order]
      );

      logger.info(`Brand created: ${name} (ID: ${result.insertId})`);

      res.status(201).json({
        success: true,
        message: '品牌创建成功',
        data: { id: result.insertId },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 更新品牌
   */
  static async update(req, res, next) {
    const { id } = req.params;
    const { name, en_name, logo, description, website, sort_order, status } = req.body;

    try {
      const pool = getPool();

      // 检查品牌是否存在
      const [existing] = await pool.execute(
        'SELECT id FROM brands WHERE id = ?',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('品牌不存在', 404, 'BRAND_NOT_FOUND');
      }

      // 检查名称是否重复
      if (name || en_name) {
        const [duplicate] = await pool.execute(
          'SELECT id FROM brands WHERE (name = ? OR en_name = ?) AND id != ?',
          [name, en_name, id]
        );
        if (duplicate.length > 0) {
          throw new AppError('品牌名称已存在', 409, 'DUPLICATE_BRAND');
        }
      }

      // 更新品牌
      const fields = [];
      const values = [];

      if (name !== undefined) {
        fields.push('name = ?');
        values.push(name);
      }
      if (en_name !== undefined) {
        fields.push('en_name = ?');
        values.push(en_name);
      }
      if (logo !== undefined) {
        fields.push('logo = ?');
        values.push(logo);
      }
      if (description !== undefined) {
        fields.push('description = ?');
        values.push(description);
      }
      if (website !== undefined) {
        fields.push('website = ?');
        values.push(website);
      }
      if (sort_order !== undefined) {
        fields.push('sort_order = ?');
        values.push(sort_order);
      }
      if (status !== undefined) {
        fields.push('status = ?');
        values.push(parseInt(status));
      }

      if (fields.length > 0) {
        values.push(id);
        await pool.execute(
          `UPDATE brands SET ${fields.join(', ')} WHERE id = ?`,
          values
        );
      }

      logger.info(`Brand updated: ID ${id}`);

      res.json({
        success: true,
        message: '品牌更新成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 删除品牌
   */
  static async delete(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();

      // 检查品牌是否存在
      const [existing] = await pool.execute(
        'SELECT id FROM brands WHERE id = ?',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('品牌不存在', 404, 'BRAND_NOT_FOUND');
      }

      // 检查是否有关联商品
      const [products] = await pool.execute(
        'SELECT id FROM products WHERE brand = (SELECT name FROM brands WHERE id = ?) AND deleted_at IS NULL',
        [id]
      );

      if (products.length > 0) {
        throw new AppError('品牌下存在商品，无法删除', 400, 'HAS_PRODUCTS');
      }

      // 删除品牌
      await pool.execute('DELETE FROM brands WHERE id = ?', [id]);

      logger.info(`Brand deleted: ID ${id}`);

      res.json({
        success: true,
        message: '品牌删除成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 批量删除品牌
   */
  static async batchDelete(req, res, next) {
    const { ids } = req.body;

    try {
      if (!Array.isArray(ids) || ids.length === 0) {
        throw new AppError('请选择要删除的品牌', 400, 'INVALID_IDS');
      }

      const pool = getPool();
      const placeholders = ids.map(() => '?').join(',');

      // 删除品牌
      await pool.execute(`DELETE FROM brands WHERE id IN (${placeholders})`, ids);

      res.json({
        success: true,
        message: `成功删除 ${ids.length} 个品牌`,
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = BrandController;
