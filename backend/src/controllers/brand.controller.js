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
        conditions.push('(name LIKE ? OR description LIKE ?)');
        const keywordPattern = `%${keyword}%`;
        params.push(keywordPattern, keywordPattern);
      }

      const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

      const [rows] = await pool.execute(
        `SELECT *, 
         (SELECT COUNT(*) FROM products WHERE brand_id = b.id AND deleted_at IS NULL) as product_count
         FROM brands b ${whereClause} ORDER BY sort_order, id`,
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
        `SELECT b.*,
         (SELECT COUNT(*) FROM products WHERE brand_id = b.id AND deleted_at IS NULL) as product_count
         FROM brands b WHERE b.id = ?`,
        [id]
      );

      if (rows.length === 0) {
        throw new AppError('品牌不存在', 404, 'BRAND_NOT_FOUND');
      }

      res.json({
        success: true,
        data: rows[0],
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 创建品牌
   */
  static async create(req, res, next) {
    const { name, logo, description, website, sort_order = 0 } = req.body;

    try {
      const pool = getPool();

      const [result] = await pool.execute(
        'INSERT INTO brands (name, logo, description, website, sort_order, status) VALUES (?, ?, ?, ?, ?, 1)',
        [name, logo || null, description || null, website || null, sort_order]
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
    const { name, logo, description, website, sort_order } = req.body;

    try {
      const pool = getPool();

      const [existing] = await pool.execute(
        'SELECT id FROM brands WHERE id = ?',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('品牌不存在', 404, 'BRAND_NOT_FOUND');
      }

      const fields = [];
      const values = [];

      if (name !== undefined) {
        fields.push('name = ?');
        values.push(name);
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

      const [existing] = await pool.execute(
        'SELECT id FROM brands WHERE id = ?',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('品牌不存在', 404, 'BRAND_NOT_FOUND');
      }

      const [products] = await pool.execute(
        'SELECT id FROM products WHERE brand_id = ? AND deleted_at IS NULL',
        [id]
      );

      if (products.length > 0) {
        throw new AppError('品牌下存在商品，无法删除', 400, 'HAS_PRODUCTS');
      }

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
}

module.exports = BrandController;
