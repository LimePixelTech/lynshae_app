/**
 * 商品控制器 - LynShae 商品管理系统
 */
const { getPool } = require('../config/database');
const { cache } = require('../config/redis');
const config = require('../config');
const { logger } = require('../utils/logger');
const { AppError } = require('../middleware/errorHandler');

class ProductController {
  /**
   * 获取商品列表（管理后台用）
   */
  static async list(req, res, next) {
    const {
      page = 1,
      limit = 20,
      category_id,
      status,
      keyword,
      sort = 'created_at',
      order = 'DESC',
      is_recommend,
      is_hot,
      is_new,
      is_on_sale,
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

      if (status !== undefined) {
        conditions.push('p.status = ?');
        params.push(parseInt(status));
      }

      if (keyword) {
        conditions.push('(p.name LIKE ? OR p.spu LIKE ? OR p.model LIKE ?)');
        const keywordPattern = `%${keyword}%`;
        params.push(keywordPattern, keywordPattern, keywordPattern);
      }

      if (is_recommend !== undefined) {
        conditions.push('p.is_recommend = ?');
        params.push(is_recommend === 'true' ? 1 : 0);
      }

      if (is_hot !== undefined) {
        conditions.push('p.is_hot = ?');
        params.push(is_hot === 'true' ? 1 : 0);
      }

      if (is_new !== undefined) {
        conditions.push('p.is_new = ?');
        params.push(is_new === 'true' ? 1 : 0);
      }

      if (is_on_sale !== undefined) {
        conditions.push('p.is_on_sale = ?');
        params.push(is_on_sale === 'true' ? 1 : 0);
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
      const allowedSorts = ['created_at', 'updated_at', 'price', 'sales_count', 'name', 'sort_order'];
      const orderBy = allowedSorts.includes(sort) ? sort : 'created_at';
      const sortOrder = order.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';

      // 查询总数
      const countQuery = `SELECT COUNT(*) as total FROM products p WHERE ${conditions.join(' AND ')}`;
      const [countRows] = await pool.query(countQuery, params);
      const total = countRows[0].total;

      // 查询数据
      const query = `SELECT 
        p.*,
        pc.name AS category_name
      FROM products p
      LEFT JOIN product_categories pc ON p.category_id = pc.id
      WHERE ${conditions.join(' AND ')}
      ORDER BY p.${orderBy} ${sortOrder}
      LIMIT ? OFFSET ?`;
      const [rows] = await pool.query(query, [...params, parseInt(limit), offset]);

      // 单独查询每个商品的图片
      for (const row of rows) {
        const [images] = await pool.query(
          'SELECT url FROM product_images WHERE product_id = ? ORDER BY sort_order LIMIT 5',
          [row.id]
        );
        row.images = images.map(img => img.url);
      }

      // 解析布尔字段
      const products = rows.map(row => ({
        ...row,
        is_recommend: row.is_recommend === 1,
        is_hot: row.is_hot === 1,
        is_new: row.is_new === 1,
        is_on_sale: row.is_on_sale === 1,
      }));

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
   * 获取商品详情（管理后台用）
   */
  static async getById(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();

      // 查询商品基本信息
      const [rows] = await pool.query(
        `SELECT 
          p.*,
          pc.name AS category_name,
          pc.icon AS category_icon
        FROM products p
        LEFT JOIN product_categories pc ON p.category_id = pc.id
        WHERE p.id = ? AND p.deleted_at IS NULL`,
        [id]
      );

      if (rows.length === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      const product = rows[0];

      // 查询商品图片
      const [images] = await pool.query(
        'SELECT id, url, sort_order, is_primary FROM product_images WHERE product_id = ? ORDER BY sort_order',
        [id]
      );

      // 查询商品 SKU
      const [skus] = await pool.query(
        'SELECT * FROM product_skus WHERE product_id = ? ORDER BY id',
        [id]
      );

      const productData = {
        ...product,
        images,
        skus,
        is_recommend: product.is_recommend === 1,
        is_hot: product.is_hot === 1,
        is_new: product.is_new === 1,
        is_on_sale: product.is_on_sale === 1,
      };

      res.json({
        success: true,
        data: productData,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取商品详情（前台展示用 - 含购买链接）
   */
  static async getDetail(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();

      // 查询商品基本信息
      const [rows] = await pool.query(
        `SELECT 
          p.id, p.spu, p.name, p.category_id, p.brand, p.model,
          p.short_description, p.content, p.price, p.original_price,
          p.stock, p.unit, p.images, p.video_url, p.specs, p.attributes,
          p.tags, p.is_new, p.is_hot, p.is_recommend, p.is_on_sale,
          p.sort_order, p.view_count, p.sales_count, p.rating,
          pc.name AS category_name,
          p.created_at, p.updated_at
        FROM products p
        LEFT JOIN product_categories pc ON p.category_id = pc.id
        WHERE p.id = ? AND p.deleted_at IS NULL AND p.is_on_sale = 1`,
        [id]
      );

      if (rows.length === 0) {
        throw new AppError('商品不存在或已下架', 404, 'PRODUCT_NOT_FOUND');
      }

      const product = rows[0];

      // 查询商品 SKU
      const [skus] = await pool.query(
        'SELECT id, sku_code, specs, price, original_price, stock, image, is_active FROM product_skus WHERE product_id = ? AND is_active = 1',
        [id]
      );

      // 更新浏览量
      await pool.query('UPDATE products SET view_count = view_count + 1 WHERE id = ?', [id]);

      // 解析 JSON 字段
      const productData = {
        ...product,
        images: product.images ? JSON.parse(product.images) : [],
        specs: product.specs ? JSON.parse(product.specs) : {},
        attributes: product.attributes ? JSON.parse(product.attributes) : [],
        tags: product.tags ? JSON.parse(product.tags) : [],
        skus: skus.map(sku => ({
          ...sku,
          specs: sku.specs ? JSON.parse(sku.specs) : {},
        })),
        is_new: product.is_new === 1,
        is_hot: product.is_hot === 1,
        is_recommend: product.is_recommend === 1,
      };

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
    const transaction = await (await getPool()).getConnection();

    try {
      await transaction.beginTransaction();

      const {
        spu,
        name,
        category_id,
        brand,
        model,
        short_description,
        content,
        price,
        original_price,
        cost_price,
        stock,
        warn_stock,
        unit,
        video_url,
        specs,
        attributes,
        tags,
        is_new,
        is_hot,
        is_recommend,
        is_on_sale,
        sort_order,
        skus,
      } = req.body;

      // 检查 SPU 是否已存在
      const [existing] = await transaction.query(
        'SELECT id FROM products WHERE spu = ? AND deleted_at IS NULL',
        [spu]
      );

      if (existing.length > 0) {
        throw new AppError('SPU 已存在', 409, 'DUPLICATE_SPU');
      }

      // 插入商品
      const [result] = await transaction.query(
        `INSERT INTO products (
          spu, name, category_id, brand, model, short_description, content,
          price, original_price, cost_price, stock, warn_stock, unit,
          video_url, specs, attributes, tags,
          is_new, is_hot, is_recommend, is_on_sale, sort_order,
          status, created_by
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?)`,
        [
          spu, name, category_id || null, brand || null, model || null,
          short_description || null, content || null,
          price, original_price || null, cost_price || null,
          stock || 0, warn_stock || 10, unit || '件',
          video_url || null,
          specs ? JSON.stringify(specs) : null,
          attributes ? JSON.stringify(attributes) : null,
          tags ? JSON.stringify(tags) : null,
          is_new ? 1 : 0, is_hot ? 1 : 0, is_recommend ? 1 : 0, is_on_sale !== false ? 1 : 0,
          sort_order || 0,
          req.user?.id || null,
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

        await transaction.query(
          'INSERT INTO product_images (product_id, url, sort_order, is_primary) VALUES ?',
          [imageValues]
        );
      }

      // 处理 SKU
      if (skus && Array.isArray(skus) && skus.length > 0) {
        const skuValues = skus.map(sku => [
          productId,
          sku.sku_code,
          JSON.stringify(sku.specs || {}),
          sku.price,
          sku.original_price || null,
          sku.stock || 0,
          sku.image || null,
          sku.is_active !== false ? 1 : 0,
        ]);

        await transaction.query(
          'INSERT INTO product_skus (product_id, sku_code, specs, price, original_price, stock, image, is_active) VALUES ?',
          [skuValues]
        );
      }

      await transaction.commit();

      // 清除缓存
      await cache.delPattern('product:list:*');

      logger.info(`Product created: ${name} (ID: ${productId})`);

      res.status(201).json({
        success: true,
        message: '商品创建成功',
        data: { id: productId, spu },
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
    const transaction = await (await getPool()).getConnection();

    try {
      await transaction.beginTransaction();

      // 检查商品是否存在
      const [existing] = await transaction.query(
        'SELECT id FROM products WHERE id = ? AND deleted_at IS NULL',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      const {
        spu,
        name,
        category_id,
        brand,
        model,
        short_description,
        content,
        price,
        original_price,
        cost_price,
        stock,
        warn_stock,
        unit,
        video_url,
        specs,
        attributes,
        tags,
        is_new,
        is_hot,
        is_recommend,
        is_on_sale,
        sort_order,
      } = req.body;

      // 如果更新 SPU，检查是否重复
      if (spu) {
        const [duplicate] = await transaction.query(
          'SELECT id FROM products WHERE spu = ? AND id != ? AND deleted_at IS NULL',
          [spu, id]
        );

        if (duplicate.length > 0) {
          throw new AppError('SPU 已存在', 409, 'DUPLICATE_SPU');
        }
      }

      // 更新商品
      const fields = [];
      const values = [];

      const updateFields = {
        spu, name, category_id, brand, model, short_description, content,
        price, original_price, cost_price, stock, warn_stock, unit,
        video_url, sort_order,
      };

      Object.keys(updateFields).forEach(key => {
        if (updateFields[key] !== undefined) {
          fields.push(`${key} = ?`);
          values.push(updateFields[key]);
        }
      });

      // JSON 字段
      if (specs !== undefined) {
        fields.push('specs = ?');
        values.push(specs ? JSON.stringify(specs) : null);
      }
      if (attributes !== undefined) {
        fields.push('attributes = ?');
        values.push(attributes ? JSON.stringify(attributes) : null);
      }
      if (tags !== undefined) {
        fields.push('tags = ?');
        values.push(tags ? JSON.stringify(tags) : null);
      }

      // 布尔字段
      if (is_new !== undefined) {
        fields.push('is_new = ?');
        values.push(is_new ? 1 : 0);
      }
      if (is_hot !== undefined) {
        fields.push('is_hot = ?');
        values.push(is_hot ? 1 : 0);
      }
      if (is_recommend !== undefined) {
        fields.push('is_recommend = ?');
        values.push(is_recommend ? 1 : 0);
      }
      if (is_on_sale !== undefined) {
        fields.push('is_on_sale = ?');
        values.push(is_on_sale ? 1 : 0);
      }

      if (fields.length > 0) {
        values.push(id);
        await transaction.query(
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

        await transaction.query(
          'INSERT INTO product_images (product_id, url, sort_order, is_primary) VALUES ?',
          [imageValues]
        );
      }

      await transaction.commit();

      // 清除缓存
      await cache.delPattern('product:list:*');
      await cache.del(`product:${id}`);

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
   * 删除商品（软删除）
   */
  static async delete(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();

      // 检查商品是否存在
      const [existing] = await pool.query(
        'SELECT id FROM products WHERE id = ? AND deleted_at IS NULL',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      // 软删除
      await pool.query(
        'UPDATE products SET deleted_at = NOW(), status = 0, is_on_sale = 0 WHERE id = ?',
        [id]
      );

      // 清除缓存
      await cache.delPattern('product:list:*');
      await cache.del(`product:${id}`);

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
   * 批量删除商品
   */
  static async batchDelete(req, res, next) {
    const { ids } = req.body;

    try {
      if (!Array.isArray(ids) || ids.length === 0) {
        throw new AppError('请选择要删除的商品', 400, 'INVALID_IDS');
      }

      const pool = getPool();
      const placeholders = ids.map(() => '?').join(',');

      await pool.query(
        `UPDATE products SET deleted_at = NOW(), status = 0, is_on_sale = 0 WHERE id IN (${placeholders})`,
        ids
      );

      // 清除缓存
      await cache.delPattern('product:list:*');

      res.json({
        success: true,
        message: `成功删除 ${ids.length} 个商品`,
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
    const { status, is_on_sale } = req.body;

    try {
      const pool = getPool();
      const fields = [];
      const values = [];

      if (status !== undefined) {
        fields.push('status = ?');
        values.push(parseInt(status));
      }

      if (is_on_sale !== undefined) {
        fields.push('is_on_sale = ?');
        values.push(is_on_sale ? 1 : 0);
      }

      if (fields.length === 0) {
        throw new AppError('没有提供要更新的字段', 400, 'NO_FIELDS_TO_UPDATE');
      }

      values.push(id);
      const [result] = await pool.query(
        `UPDATE products SET ${fields.join(', ')} WHERE id = ?`,
        values
      );

      if (result.affectedRows === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      // 清除缓存
      await cache.delPattern('product:list:*');
      await cache.del(`product:${id}`);

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
      const [existing] = await pool.query(
        'SELECT id FROM products WHERE id = ? AND deleted_at IS NULL',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      // 获取当前最大排序
      const [maxSort] = await pool.query(
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

      await pool.query(
        'INSERT INTO product_images (product_id, url, sort_order, is_primary) VALUES ?',
        [imageValues]
      );

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

      const [result] = await pool.query(
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
   * 批量删除商品图片
   */
  static async batchDeleteImages(req, res, next) {
    const { id } = req.params;
    const { imageIds } = req.body;

    try {
      if (!Array.isArray(imageIds) || imageIds.length === 0) {
        throw new AppError('请选择要删除的图片', 400, 'INVALID_IDS');
      }

      const pool = getPool();
      const placeholders = imageIds.map(() => '?').join(',');

      const [result] = await pool.query(
        `DELETE FROM product_images WHERE id IN (${placeholders}) AND product_id = ?`,
        [...imageIds, id]
      );

      // 清除缓存
      await cache.del(`product:${id}`);

      res.json({
        success: true,
        message: `成功删除 ${result.affectedRows} 张图片`,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 更新商品图片排序
   */
  static async updateImageSort(req, res, next) {
    const { id } = req.params;
    const { images } = req.body; // [{id: 1, sort_order: 0}, {id: 2, sort_order: 1}]

    try {
      if (!Array.isArray(images) || images.length === 0) {
        throw new AppError('请提供图片排序数据', 400, 'INVALID_DATA');
      }

      const pool = getPool();
      const transaction = await pool.getConnection();

      try {
        await transaction.beginTransaction();

        for (const img of images) {
          await transaction.query(
            'UPDATE product_images SET sort_order = ? WHERE id = ? AND product_id = ?',
            [img.sort_order, img.id, id]
          );
        }

        await transaction.commit();

        // 清除缓存
        await cache.del(`product:${id}`);

        res.json({
          success: true,
          message: '图片排序更新成功',
        });
      } catch (error) {
        await transaction.rollback();
        throw error;
      } finally {
        transaction.release();
      }
    } catch (error) {
      next(error);
    }
  }

  /**
   * 管理商品 SKU
   */
  static async updateSkus(req, res, next) {
    const { id } = req.params;
    const { skus } = req.body;

    const transaction = await (await getPool()).getConnection();

    try {
      await transaction.beginTransaction();

      // 检查商品是否存在
      const [existing] = await transaction.query(
        'SELECT id FROM products WHERE id = ? AND deleted_at IS NULL',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('商品不存在', 404, 'PRODUCT_NOT_FOUND');
      }

      // 删除现有 SKU
      await transaction.query('DELETE FROM product_skus WHERE product_id = ?', [id]);

      // 插入新 SKU
      if (skus && Array.isArray(skus) && skus.length > 0) {
        const skuValues = skus.map(sku => [
          id,
          sku.sku_code,
          JSON.stringify(sku.specs || {}),
          sku.price,
          sku.original_price || null,
          sku.stock || 0,
          sku.image || null,
          sku.is_active !== false ? 1 : 0,
        ]);

        await transaction.query(
          'INSERT INTO product_skus (product_id, sku_code, specs, price, original_price, stock, image, is_active) VALUES ?',
          [skuValues]
        );
      }

      await transaction.commit();

      res.json({
        success: true,
        message: 'SKU 更新成功',
      });
    } catch (error) {
      await transaction.rollback();
      next(error);
    } finally {
      transaction.release();
    }
  }

  /**
   * 获取统计信息
   */
  static async getStats(req, res, next) {
    try {
      const pool = getPool();

      const [stats] = await pool.query(`
        SELECT 
          (SELECT COUNT(*) FROM products WHERE deleted_at IS NULL) as total_products,
          (SELECT COUNT(*) FROM products WHERE deleted_at IS NULL AND is_on_sale = 1) as on_sale_products,
          (SELECT COUNT(*) FROM products WHERE deleted_at IS NULL AND is_new = 1) as new_products,
          (SELECT COUNT(*) FROM products WHERE deleted_at IS NULL AND is_hot = 1) as hot_products,
          (SELECT COUNT(*) FROM products WHERE deleted_at IS NULL AND is_recommend = 1) as recommend_products,
          (SELECT SUM(stock) FROM products WHERE deleted_at IS NULL) as total_stock,
          (SELECT COUNT(*) FROM product_categories WHERE is_active = 1) as total_categories
      `);

      res.json({
        success: true,
        data: stats[0],
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = ProductController;
