/**
 * 系统控制器
 */
const { getPool } = require('../config/database');
const { cache } = require('../config/redis');
const logger = require('../utils/logger');
const { AppError } = require('../middleware/errorHandler');

class SystemController {
  /**
   * 获取系统配置
   */
  static async getConfigs(req, res, next) {
    try {
      const pool = getPool();
      const [rows] = await pool.execute('SELECT * FROM system_configs ORDER BY config_key');

      const configs = {};
      rows.forEach(row => {
        let value = row.config_value;
        if (row.config_type === 'number') {
          value = parseFloat(value);
        } else if (row.config_type === 'boolean') {
          value = value === 'true';
        } else if (row.config_type === 'json') {
          try {
            value = JSON.parse(value);
          } catch (e) {
            // 保持原值
          }
        }
        configs[row.config_key] = value;
      });

      res.json({
        success: true,
        data: configs,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 更新系统配置
   */
  static async updateConfigs(req, res, next) {
    const configs = req.body;

    try {
      const pool = getPool();
      const updatePromises = [];

      for (const [key, value] of Object.entries(configs)) {
        const stringValue = typeof value === 'object' ? JSON.stringify(value) : String(value);
        updatePromises.push(
          pool.execute(
            'INSERT INTO system_configs (config_key, config_value, updated_at) VALUES (?, ?, NOW()) ON DUPLICATE KEY UPDATE config_value = ?, updated_at = NOW()',
            [key, stringValue, stringValue]
          )
        );
      }

      await Promise.all(updatePromises);

      logger.info(`System configs updated by admin ${req.admin.username}`);

      res.json({
        success: true,
        message: '配置更新成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取操作日志
   */
  static async getLogs(req, res, next) {
    const {
      page = 1,
      limit = 50,
      admin_id,
      action,
      module,
      start_date,
      end_date,
    } = req.query;

    try {
      const pool = getPool();
      const offset = (page - 1) * limit;

      const conditions = [];
      const params = [];

      if (admin_id) {
        conditions.push('admin_id = ?');
        params.push(admin_id);
      }

      if (action) {
        conditions.push('action LIKE ?');
        params.push(`%${action}%`);
      }

      if (module) {
        conditions.push('module = ?');
        params.push(module);
      }

      if (start_date) {
        conditions.push('created_at >= ?');
        params.push(start_date);
      }

      if (end_date) {
        conditions.push('created_at <= ?');
        params.push(end_date);
      }

      const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

      // 查询总数
      const [countRows] = await pool.execute(
        `SELECT COUNT(*) as total FROM operation_logs ${whereClause}`,
        params
      );
      const total = countRows[0].total;

      // 查询数据
      const [rows] = await pool.execute(
        `SELECT * FROM operation_logs ${whereClause} ORDER BY created_at DESC LIMIT ? OFFSET ?`,
        [...params, parseInt(limit), offset]
      );

      res.json({
        success: true,
        data: {
          logs: rows,
          pagination: {
            total,
            page: parseInt(page),
            limit: parseInt(limit),
            totalPages: Math.ceil(total / limit),
          },
        },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取系统统计信息
   */
  static async getStats(req, res, next) {
    try {
      const pool = getPool();

      // 商品统计
      const [productStats] = await pool.execute(`
        SELECT 
          COUNT(*) as total,
          SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as on_sale,
          SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) as off_sale,
          SUM(CASE WHEN is_new = 1 THEN 1 ELSE 0 END) as new_products,
          SUM(CASE WHEN is_hot = 1 THEN 1 ELSE 0 END) as hot_products,
          SUM(CASE WHEN is_recommend = 1 THEN 1 ELSE 0 END) as recommended
        FROM products WHERE deleted_at IS NULL
      `);

      // 分类统计
      const [categoryStats] = await pool.execute(`
        SELECT COUNT(*) as total, SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as active
        FROM categories
      `);

      // 品牌统计
      const [brandStats] = await pool.execute(`
        SELECT COUNT(*) as total, SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as active
        FROM brands
      `);

      // 库存统计
      const [stockStats] = await pool.execute(`
        SELECT SUM(stock) as total_stock, SUM(sales) as total_sales
        FROM products WHERE deleted_at IS NULL
      `);

      // 销售统计 (最近 7 天)
      const [salesStats] = await pool.execute(`
        SELECT 
          DATE(created_at) as date,
          COUNT(*) as count,
          SUM(price) as amount
        FROM products 
        WHERE deleted_at IS NULL AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
        GROUP BY DATE(created_at)
        ORDER BY date DESC
      `);

      res.json({
        success: true,
        data: {
          products: productStats[0],
          categories: categoryStats[0],
          brands: brandStats[0],
          stock: stockStats[0],
          sales: salesStats,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 清除缓存
   */
  static async clearCache(req, res, next) {
    const { pattern } = req.body;

    try {
      if (pattern) {
        await cache.delPattern(pattern);
        logger.info(`Cache cleared with pattern: ${pattern}`);
      } else {
        // 清除所有 lynshae 前缀的缓存
        await cache.delPattern('lynshae:*');
        logger.info('All cache cleared');
      }

      res.json({
        success: true,
        message: '缓存清除成功',
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = SystemController;
