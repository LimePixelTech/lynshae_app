/**
 * 商品控制器
 */

const { query, transaction } = require('../config/database');
const { cache, keys } = require('../config/redis');
const { validationResult } = require('express-validator');
const { logger } = require('../utils/logger');
const { getFileUrl } = require('../middleware/upload');

// 获取商品列表
exports.getProducts = async (req, res, next) => {
  try {
    const {
      page = 1,
      limit = 20,
      categoryId,
      keyword,
      isOnSale,
      isNew,
      isHot,
      sortBy = 'created_at',
      order = 'DESC'
    } = req.query;

    const offset = (page - 1) * limit;
    let whereClause = 'WHERE p.deleted_at IS NULL';
    const params = [];

    if (categoryId) {
      whereClause += ' AND p.category_id = ?';
      params.push(categoryId);
    }

    if (keyword) {
      whereClause += ' AND (p.name LIKE ? OR p.short_description LIKE ?)';
      params.push(`%${keyword}%`, `%${keyword}%`);
    }

    if (isOnSale !== undefined) {
      whereClause += ' AND p.is_on_sale = ?';
      params.push(isOnSale === 'true' ? 1 : 0);
    }

    if (isNew === 'true') {
      whereClause += ' AND p.is_new = 1';
    }

    if (isHot === 'true') {
      whereClause += ' AND p.is_hot = 1';
    }

    // 排序验证
    const allowedSorts = ['created_at', 'updated_at', 'price', 'sales_count', 'view_count'];
    if (!allowedSorts.includes(sortBy)) {
      return res.status(400).json({
        code: 'INVALID_SORT',
        message: '无效的排序字段'
      });
    }

    // 查询商品
    const products = await query(
      `SELECT p.*, pc.name as category_name 
       FROM products p 
       LEFT JOIN product_categories pc ON p.category_id = pc.id 
       ${whereClause}
       ORDER BY p.${sortBy} ${order}
       LIMIT ? OFFSET ?`,
      [...params, parseInt(limit), offset]
    );

    // 获取总数
    const totalResult = await query(
      `SELECT COUNT(*) as total FROM products p ${whereClause}`,
      params
    );

    const total = totalResult[0]?.total || 0;

    res.json({
      code: 'SUCCESS',
      data: {
        products,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          totalPages: Math.ceil(total / limit)
        }
      }
    });
  } catch (error) {
    next(error);
  }
};

// 获取商品详情
exports.getProductById = async (req, res, next) => {
  try {
    const { id } = req.params;

    // 尝试从缓存获取
    let product = await cache.get(keys.product(id));

    if (!product) {
      const products = await query(
        `SELECT p.*, pc.name as category_name 
         FROM products p 
         LEFT JOIN product_categories pc ON p.category_id = pc.id 
         WHERE p.id = ? AND p.deleted_at IS NULL`,
        [id]
      );

      if (!products || products.length === 0) {
        return res.status(404).json({
          code: 'NOT_FOUND',
          message: '商品不存在'
        });
      }

      product = products[0];

      // 增加浏览次数
      await query('UPDATE products SET view_count = view_count + 1 WHERE id = ?', [id]);

      // 缓存商品
      await cache.set(keys.product(id), product, 3600);
    }

    // 获取 SKU 列表
    const skus = await query(
      `SELECT * FROM product_skus WHERE product_id = ? AND is_active = 1`,
      [id]
    );

    product.skus = skus;

    res.json({
      code: 'SUCCESS',
      data: product
    });
  } catch (error) {
    next(error);
  }
};

// 获取分类商品
exports.getProductsByCategory = async (req, res, next) => {
  try {
    const { categoryId } = req.params;
    const { page = 1, limit = 20 } = req.query;

    const offset = (page - 1) * limit;

    const products = await query(
      `SELECT p.* FROM products p 
       WHERE p.category_id = ? AND p.deleted_at IS NULL AND p.is_on_sale = 1
       ORDER BY p.sort_order ASC, p.created_at DESC
       LIMIT ? OFFSET ?`,
      [categoryId, parseInt(limit), offset]
    );

    res.json({
      code: 'SUCCESS',
      data: products
    });
  } catch (error) {
    next(error);
  }
};

// 创建商品
exports.createProduct = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        code: 'VALIDATION_ERROR',
        message: '参数验证失败',
        errors: errors.array()
      });
    }

    const {
      name, category_id, brand, model, short_description, description, content,
      price, original_price, cost_price, stock, unit, specs, attributes, tags
    } = req.body;

    // 处理上传的图片
    const images = req.files?.map(file => `/uploads/${new Date().toISOString().split('T')[0]}/${file.filename}`) || [];

    // 生成 SPU
    const spu = `SPU${Date.now()}${Math.random().toString(36).substr(2, 6).toUpperCase()}`;

    const result = await query(
      `INSERT INTO products 
       (spu, name, category_id, brand, model, short_description, description, content,
        price, original_price, cost_price, stock, unit, images, specs, attributes, tags, created_by)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [spu, name, category_id, brand, model, short_description, description, content,
       price, original_price, cost_price, stock, unit, JSON.stringify(images), 
       specs ? JSON.stringify(specs) : null, 
       attributes ? JSON.stringify(attributes) : null,
       tags ? JSON.stringify(tags) : null,
       req.user.id]
    );

    // 清除分类缓存
    if (category_id) {
      await cache.delPattern(`product:category:${category_id}*`);
    }

    logger.info('商品创建成功', { productId: result.insertId, userId: req.user.id });

    res.status(201).json({
      code: 'SUCCESS',
      message: '商品创建成功',
      data: { id: result.insertId, spu }
    });
  } catch (error) {
    next(error);
  }
};

// 更新商品
exports.updateProduct = async (req, res, next) => {
  try {
    const { id } = req.params;
    const updates = req.body;

    // 检查商品是否存在
    const products = await query('SELECT id FROM products WHERE id = ?', [id]);
    if (!products || products.length === 0) {
      return res.status(404).json({
        code: 'NOT_FOUND',
        message: '商品不存在'
      });
    }

    // 构建更新语句
    const allowedFields = ['name', 'category_id', 'brand', 'model', 'short_description', 
                          'description', 'content', 'price', 'original_price', 'stock', 
                          'unit', 'specs', 'attributes', 'tags', 'is_new', 'is_hot', 
                          'is_recommend', 'sort_order'];
    
    const updateFields = [];
    const values = [];

    // 处理图片
    if (req.files && req.files.length > 0) {
      const images = req.files.map(file => `/uploads/${new Date().toISOString().split('T')[0]}/${file.filename}`);
      updateFields.push('images = ?');
      values.push(JSON.stringify(images));
    }

    allowedFields.forEach(field => {
      if (updates[field] !== undefined) {
        updateFields.push(`${field} = ?`);
        values.push(typeof updates[field] === 'object' ? JSON.stringify(updates[field]) : updates[field]);
      }
    });

    updateFields.push('updated_at = NOW()');
    values.push(id);

    await query(
      `UPDATE products SET ${updateFields.join(', ')} WHERE id = ?`,
      values
    );

    // 清除缓存
    await cache.del(keys.product(id));

    logger.info('商品更新成功', { productId: id, userId: req.user.id });

    res.json({
      code: 'SUCCESS',
      message: '商品更新成功'
    });
  } catch (error) {
    next(error);
  }
};

// 删除商品
exports.deleteProduct = async (req, res, next) => {
  try {
    const { id } = req.params;

    // 软删除
    await query('UPDATE products SET deleted_at = NOW() WHERE id = ?', [id]);

    // 清除缓存
    await cache.del(keys.product(id));

    logger.info('商品删除成功', { productId: id, userId: req.user.id });

    res.json({
      code: 'SUCCESS',
      message: '商品删除成功'
    });
  } catch (error) {
    next(error);
  }
};

// 上架/下架商品
exports.toggleSale = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { isOnSale } = req.body;

    await query('UPDATE products SET is_on_sale = ?, updated_at = NOW() WHERE id = ?', [isOnSale ? 1 : 0, id]);

    // 清除缓存
    await cache.del(keys.product(id));

    res.json({
      code: 'SUCCESS',
      message: `商品已${isOnSale ? '上架' : '下架'}`
    });
  } catch (error) {
    next(error);
  }
};

// 创建 SKU
exports.createSku = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { specs, price, original_price, stock, image } = req.body;

    // 生成 SKU 编码
    const skuCode = `SKU${Date.now()}${Math.random().toString(36).substr(2, 6).toUpperCase()}`;

    const result = await query(
      `INSERT INTO product_skus (product_id, sku_code, specs, price, original_price, stock, image)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [id, skuCode, JSON.stringify(specs), price, original_price, stock, image]
    );

    // 清除商品缓存
    await cache.del(keys.product(id));

    res.status(201).json({
      code: 'SUCCESS',
      message: 'SKU 创建成功',
      data: { id: result.insertId, skuCode }
    });
  } catch (error) {
    next(error);
  }
};

// 更新 SKU
exports.updateSku = async (req, res, next) => {
  try {
    const { id, skuId } = req.params;
    const updates = req.body;

    const allowedFields = ['specs', 'price', 'original_price', 'stock', 'image', 'is_active'];
    const updateFields = [];
    const values = [];

    allowedFields.forEach(field => {
      if (updates[field] !== undefined) {
        updateFields.push(`${field} = ?`);
        values.push(typeof updates[field] === 'object' ? JSON.stringify(updates[field]) : updates[field]);
      }
    });

    updateFields.push('updated_at = NOW()');
    values.push(skuId);

    await query(`UPDATE product_skus SET ${updateFields.join(', ')} WHERE id = ?`, values);

    // 清除商品缓存
    await cache.del(keys.product(id));

    res.json({
      code: 'SUCCESS',
      message: 'SKU 更新成功'
    });
  } catch (error) {
    next(error);
  }
};

// 删除 SKU
exports.deleteSku = async (req, res, next) => {
  try {
    const { id, skuId } = req.params;

    await query('DELETE FROM product_skus WHERE id = ?', [skuId]);

    // 清除商品缓存
    await cache.del(keys.product(id));

    res.json({
      code: 'SUCCESS',
      message: 'SKU 删除成功'
    });
  } catch (error) {
    next(error);
  }
};

// 获取分类
exports.getCategories = async (req, res, next) => {
  try {
    const categories = await query(
      `SELECT * FROM product_categories WHERE is_active = 1 ORDER BY sort_order ASC, level ASC`
    );

    // 构建树形结构
    const buildTree = (items, parentId = null) => {
      return items
        .filter(item => item.parent_id === parentId)
        .map(item => ({
          ...item,
          children: buildTree(items, item.id)
        }));
    };

    const tree = buildTree(categories);

    res.json({
      code: 'SUCCESS',
      data: tree
    });
  } catch (error) {
    next(error);
  }
};

// 创建分类
exports.createCategory = async (req, res, next) => {
  try {
    const { name, parent_id, icon, image, description, sort_order } = req.body;

    const result = await query(
      `INSERT INTO product_categories (name, parent_id, icon, image, description, sort_order)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [name, parent_id, icon, image, description, sort_order || 0]
    );

    res.status(201).json({
      code: 'SUCCESS',
      message: '分类创建成功',
      data: { id: result.insertId }
    });
  } catch (error) {
    next(error);
  }
};
