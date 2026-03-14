/**
 * 商品控制器
 */
const { getPool } = require('../config/database');
const { cache } = require('../config/redis');
const config = require('../config');
const logger = require('../utils/logger');
const { AppError } = require('../middleware/errorHandler');

class ProductController {
  /**
   * 获取商品列表
   */
  static async list(req, res, next) {
    const {
      page = 1,
      limit = 20,
      category_id,
      brand_id,
      status,
      keyword,
      sort = 'created_at',
      order = 'DESC',
      is_recommend,
      is_hot,
      is_new,
      min_price,
      max_price,
    } = req.query;

    try {
      const pool = getPool();
      const offset = (page - 1) * limit;

      // 构建查询条件
      const conditions = ['p.deleted_at IS NULL'];
      const params = [];

      if (category_id) {
        conditions.push('p.category_id = ?');
        params.push(category_id);
      }

      if (brand_id) {
        conditions.push('p.brand_id = ?');
        params.push(brand_id);
      }

      if (status !== undefined) {
        conditions.push('p.status = ?');
        params.push(parseInt(status));
      }

      if (keyword) {
        conditions.push('(p.name LIKE ? OR p.description LIKE ? OR p.sku LIKE ?)');
        const keywordPattern = `%${keyword}%`;
        params.push(keywordPattern, keywordPattern, keywordPattern);
      }

      if (is_recommend !== undefined) {
        conditions.push('p.is_recommend = ?');
        params.push(parseInt(is_recommend));
      }

      if (is_hot !== undefined) {
        conditions.push('p.is_hot = ?');
        params.push(parseInt(is_hot));
      }

      if (is_new !== undefined) {
        conditions.push('p.is_new = ?');
        params.push(parseInt(is_new));
      }

      if (min_price) {
        conditions.push('p.price >= ?');
        params.push(parseFloat(min_price));
      }

      if (max_price) {
        conditions.push('p.price <= ?');
        params.push(parseFloat(max_price));
      }

      // 排序字段白名单
      const allowedSorts = ['created_at', 'updated_at', 'price', 'sales', 'name'];
      const orderBy = allowedSorts.includes(sort) ? sort : 'created_at';
      const sortOrder = order.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';

      // 查询总数
      const [countRows] = await pool.execute(
        `SELECT COUNT(*) as total FROM products p WHERE ${conditions.join(' AND ')}`,
        params
      );
      const total = countRows[0].total;

      // 查询数据
      const [rows] = await pool.execute(
        `SELECT 
          p.*,
          c.name AS category_name,
          b.name AS brand_name,
          (SELECT GROUP_CONCAT(pi.url ORDER BY pi.sort_order LIMIT 5) 
           FROM product_images pi WHERE pi.product_id = p.id) AS images
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN brands b ON p.brand_id = b.id
        WHERE ${conditions.join(' AND ')}
        ORDER BY p.${orderBy} ${sortOrder}
        LIMIT ? OFFSET ?`,
        [...params, parseInt(limit), offset]
      );

      // 解析图片字段
      const products = rows.map(row => ({
        ...row,
        images: row.images ? row.images.split(',') : [],
      }));

      // 缓存列表 (带条件的缓存键)
      const cacheKey = `product:list:${JSON.stringify(req.query)}`;
      await cache.set(cacheKey, { products, total, page: parseInt(page), limit: parseInt(limit) }, config.cache.product.ttl);

      res.json({
        success: true,
        data: {
          products,
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
   * 获取商品详情
   */
  static async getById(req, res, next) {
    const { id } = req.params;

    try {
      // 尝试从缓存获取
      const cached = await cache.get(`product:${id}`);
      if (cached) {
        return res.json({
          success: true,
          data: cached,
        });
      }

      const pool = getPool();

      // 查询商品基本信息
      const [rows] = await pool.execute(
        `SELECT 
          p.*,
          c.name AS category_name,
          c.icon AS category_icon,
          b.name AS brand_name,
          b.logo AS brand_logo
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN brands b ON p.brand_id = b.id
        WHERE p.id = ? AND p.deleted_at IS NULL`,
        [id]
      );

      if (rows.length === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      const product = rows[0];

      // 查询商品图片
      const [images] = await pool.execute(
        'SELECT id, url, sort_order, is_primary FROM product_images WHERE product_id = ? ORDER BY sort_order',
        [id]
      );

      // 查询商品规格
      const [specs] = await pool.execute(
        'SELECT id, spec_name, spec_value FROM product_specs WHERE product_id = ? ORDER BY sort_order',
        [id]
      );

      // 查询商品 SKU
      const [skus] = await pool.execute(
        'SELECT * FROM product_skus WHERE product_id = ? AND status = 1',
        [id]
      );

      const productData = {
        ...product,
        images,
        specs,
        skus,
      };

      // 缓存商品详情
      await cache.set(`product:${id}`, productData, config.cache.product.ttl);

      res.json({
        success: true,
        data: productData,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 创建商品
   */
  static async create(req, res, next) {
    const {
      name,
      category_id,
      brand_id,
      sku,
      price,
      original_price,
      cost_price,
      stock,
      description,
      details,
      is_recommend,
      is_hot,
      is_new,
    } = req.body;

    const transaction = await (await getPool()).getConnection();

    try {
      await transaction.beginTransaction();

      // 检查 SKU 是否已存在
      const [existing] = await transaction.execute(
        'SELECT id FROM products WHERE sku = ? AND deleted_at IS NULL',
        [sku]
      );

      if (existing.length > 0) {
        throw new AppError('SKU 已存在', 409, 'DUPLICATE_SKU');
      }

      // 插入商品
      const [result] = await transaction.execute(
        `INSERT INTO products (
          name, category_id, brand_id, sku, price, original_price, cost_price,
          stock, description, details, is_recommend, is_hot, is_new, status
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)`,
        [
          name, category_id, brand_id || null, sku, price, original_price || null,
          cost_price || null, stock || 0, description || null, details || null,
          is_recommend ? 1 : 0, is_hot ? 1 : 0, is_new ? 1 : 0,
        ]
      );

      const productId = result.insertId;

      // 处理上传的图片
      if (req.files && req.files.length > 0) {
        const imageValues = req.files.map((file, index) => [
          productId,
          `/uploads/${file.path.replace(/\\/g, '/').split('uploads/')[1]}`,
          index,
          index === 0 ? 1 : 0,
        ]);

        await transaction.execute(
          'INSERT INTO product_images (product_id, url, sort_order, is_primary) VALUES ?',
          [imageValues]
        );

        // 更新主图
        const mainImage = `/uploads/${req.files[0].path.replace(/\\/g, '/').split('uploads/')[1]}`;
        await transaction.execute('UPDATE products SET main_image = ? WHERE id = ?', [mainImage, productId]);
      }

      await transaction.commit();

      // 清除缓存
      await cache.delPattern('product:list:*');

      logger.info(`Product created: ${name} (ID: ${productId})`);

      res.status(201).json({
        success: true,
        message: '商品创建成功',
        data: { id: productId },
      });
    } catch (error) {
      await transaction.rollback();
      next(error);
    } finally {
      transaction.release();
    }
  }

  /**
   * 更新商品
   */
  static async update(req, res, next) {
    const { id } = req.params;
    const updateData = { ...req.body };

    const transaction = await (await getPool()).getConnection();

    try {
      await transaction.beginTransaction();

      // 检查商品是否存在
      const [existing] = await transaction.execute(
        'SELECT id FROM products WHERE id = ? AND deleted_at IS NULL',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      // 如果更新 SKU，检查是否重复
      if (updateData.sku) {
        const [duplicate] = await transaction.execute(
          'SELECT id FROM products WHERE sku = ? AND id != ? AND deleted_at IS NULL',
          [updateData.sku, id]
        );

        if (duplicate.length > 0) {
          throw new AppError('SKU 已存在', 409, 'DUPLICATE_SKU');
        }
      }

      // 更新商品
      const fields = [];
      const values = [];

      Object.keys(updateData).forEach(key => {
        if (['name', 'category_id', 'brand_id', 'price', 'original_price', 'cost_price', 
             'stock', 'description', 'details', 'is_recommend', 'is_hot', 'is_new'].includes(key)) {
          fields.push(`${key} = ?`);
          values.push(updateData[key]);
        }
      });

      if (fields.length > 0) {
        values.push(id);
        await transaction.execute(
          `UPDATE products SET ${fields.join(', ')} WHERE id = ?`,
          values
        );
      }

      // 处理上传的图片
      if (req.files && req.files.length > 0) {
        const imageValues = req.files.map((file, index) => [
          id,
          `/uploads/${file.path.replace(/\\/g, '/').split('uploads/')[1]}`,
          index,
          index === 0 ? 1 : 0,
        ]);

        await transaction.execute(
          'INSERT INTO product_images (product_id, url, sort_order, is_primary) VALUES ?',
          [imageValues]
        );
      }

      await transaction.commit();

      // 清除缓存
      await cache.del(`product:${id}`);
      await cache.delPattern('product:list:*');

      logger.info(`Product updated: ID ${id}`);

      res.json({
        success: true,
        message: '商品更新成功',
      });
    } catch (error) {
      await transaction.rollback();
      next(error);
    } finally {
      transaction.release();
    }
  }

  /**
   * 删除商品 (软删除)
   */
  static async delete(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();

      // 检查商品是否存在
      const [existing] = await pool.execute(
        'SELECT id FROM products WHERE id = ? AND deleted_at IS NULL',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      // 软删除
      await pool.execute(
        'UPDATE products SET deleted_at = NOW(), status = 0 WHERE id = ?',
        [id]
      );

      // 清除缓存
      await cache.del(`product:${id}`);
      await cache.delPattern('product:list:*');

      logger.info(`Product deleted: ID ${id}`);

      res.json({
        success: true,
        message: '商品删除成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 更新商品状态
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
        'UPDATE products SET status = ? WHERE id = ?',
        [status, id]
      );

      if (result.affectedRows === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      // 清除缓存
      await cache.del(`product:${id}`);
      await cache.delPattern('product:list:*');

      res.json({
        success: true,
        message: '状态更新成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 上传商品图片
   */
  static async uploadImages(req, res, next) {
    const { id } = req.params;

    try {
      if (!req.files || req.files.length === 0) {
        throw new AppError('请上传至少一张图片', 400, 'NO_FILES_UPLOADED');
      }

      const pool = getPool();

      // 检查商品是否存在
      const [existing] = await pool.execute(
        'SELECT id FROM products WHERE id = ? AND deleted_at IS NULL',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      // 获取当前最大排序
      const [maxSort] = await pool.execute(
        'SELECT MAX(sort_order) as max_order FROM product_images WHERE product_id = ?',
        [id]
      );
      let sortOrder = maxSort[0].max_order || 0;

      // 插入图片记录
      const imageValues = req.files.map(file => {
        sortOrder++;
        return [
          id,
          `/uploads/${file.path.replace(/\\/g, '/').split('uploads/')[1]}`,
          sortOrder,
          0,
        ];
      });

      await pool.execute(
        'INSERT INTO product_images (product_id, url, sort_order, is_primary) VALUES ?',
        [imageValues]
      );

      // 清除缓存
      await cache.del(`product:${id}`);

      res.json({
        success: true,
        message: '图片上传成功',
        data: {
          count: req.files.length,
          images: req.files.map(file => ({
            url: `/uploads/${file.path.replace(/\\/g, '/').split('uploads/')[1]}`,
          })),
        },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 删除商品图片
   */
  static async deleteImage(req, res, next) {
    const { id, imageId } = req.params;

    try {
      const pool = getPool();

      const [result] = await pool.execute(
        'DELETE FROM product_images WHERE id = ? AND product_id = ?',
        [imageId, id]
      );

      if (result.affectedRows === 0) {
        throw new AppError('图片不存在', 404, 'IMAGE_NOT_FOUND');
      }

      // 清除缓存
      await cache.del(`product:${id}`);

      res.json({
        success: true,
        message: '图片删除成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取热销商品
   */
  static async getHotProducts(req, res, next) {
    const { limit = 10 } = req.query;

    try {
      // 尝试从缓存获取
      const cached = await cache.get('product:hot');
      if (cached) {
        return res.json({
          success: true,
          data: cached,
        });
      }

      const pool = getPool();
      const [rows] = await pool.execute(
        `SELECT id, name, price, main_image, sales 
         FROM products 
         WHERE status = 1 AND deleted_at IS NULL 
         ORDER BY sales DESC 
         LIMIT ?`,
        [parseInt(limit)]
      );

      // 缓存
      await cache.set('product:hot', rows, config.cache.hotProducts.ttl);

      res.json({
        success: true,
        data: rows,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取新品推荐
   */
  static async getNewProducts(req, res, next) {
    const { limit = 10 } = req.query;

    try {
      // 尝试从缓存获取
      const cached = await cache.get('product:new');
      if (cached) {
        return res.json({
          success: true,
          data: cached,
        });
      }

      const pool = getPool();
      const [rows] = await pool.execute(
        `SELECT id, name, price, main_image, created_at 
         FROM products 
         WHERE status = 1 AND deleted_at IS NULL 
         ORDER BY created_at DESC 
         LIMIT ?`,
        [parseInt(limit)]
      );

      // 缓存
      await cache.set('product:new', rows, config.cache.newProducts.ttl);

      res.json({
        success: true,
        data: rows,
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = ProductController;
