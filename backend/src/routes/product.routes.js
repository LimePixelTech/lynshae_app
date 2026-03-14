/**
 * 商品路由
 */
const express = require('express');
const router = express.Router();
const { body, query, param } = require('express-validator');
const ProductController = require('../controllers/product.controller');
const authMiddleware = require('../middleware/auth');
const validate = require('../middleware/validate');
const upload = require('../middleware/upload');

// 验证规则
const createProductValidation = [
  body('name')
    .trim()
    .notEmpty().withMessage('商品名称不能为空')
    .isLength({ max: 200 }).withMessage('商品名称不能超过 200 个字符'),
  body('category_id')
    .notEmpty().withMessage('分类不能为空')
    .isInt({ min: 1 }).withMessage('分类 ID 必须为正整数'),
  body('price')
    .notEmpty().withMessage('价格不能为空')
    .isFloat({ min: 0 }).withMessage('价格必须为非负数'),
  body('sku')
    .trim()
    .notEmpty().withMessage('SKU 不能为空')
    .isLength({ max: 50 }).withMessage('SKU 不能超过 50 个字符'),
  body('stock')
    .optional()
    .isInt({ min: 0 }).withMessage('库存必须为非负整数'),
  body('description')
    .optional()
    .isLength({ max: 500 }).withMessage('简介不能超过 500 个字符'),
  validate,
];

const updateProductValidation = [
  param('id')
    .isInt({ min: 1 }).withMessage('商品 ID 必须为正整数'),
  body('name')
    .optional()
    .trim()
    .isLength({ max: 200 }).withMessage('商品名称不能超过 200 个字符'),
  body('category_id')
    .optional()
    .isInt({ min: 1 }).withMessage('分类 ID 必须为正整数'),
  body('price')
    .optional()
    .isFloat({ min: 0 }).withMessage('价格必须为非负数'),
  body('stock')
    .optional()
    .isInt({ min: 0 }).withMessage('库存必须为非负整数'),
  body('description')
    .optional()
    .isLength({ max: 500 }).withMessage('简介不能超过 500 个字符'),
  validate,
];

const listValidation = [
  query('page')
    .optional()
    .isInt({ min: 1 }).withMessage('页码必须为正整数'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 }).withMessage('每页数量必须在 1-100 之间'),
  query('category_id')
    .optional()
    .isInt({ min: 1 }).withMessage('分类 ID 必须为正整数'),
  query('status')
    .optional()
    .isInt({ min: 0, max: 1 }).withMessage('状态必须为 0 或 1'),
  validate,
];

// 路由
/**
 * @route GET /api/products
 * @desc 获取商品列表 (支持分页、筛选、搜索)
 * @access Private
 */
router.get('/', authMiddleware, listValidation, ProductController.list);

/**
 * @route GET /api/products/:id
 * @desc 获取商品详情
 * @access Private
 */
router.get('/:id', authMiddleware, ProductController.getById);

/**
 * @route POST /api/products
 * @desc 创建商品
 * @access Private
 */
router.post('/', authMiddleware, upload.array('images', 10), createProductValidation, ProductController.create);

/**
 * @route PUT /api/products/:id
 * @desc 更新商品
 * @access Private
 */
router.put('/:id', authMiddleware, upload.array('images', 10), updateProductValidation, ProductController.update);

/**
 * @route DELETE /api/products/:id
 * @desc 删除商品 (软删除)
 * @access Private
 */
router.delete('/:id', authMiddleware, ProductController.delete);

/**
 * @route PATCH /api/products/:id/status
 * @desc 更新商品状态
 * @access Private
 */
router.patch('/:id/status', authMiddleware, ProductController.updateStatus);

/**
 * @route POST /api/products/:id/images
 * @desc 上传商品图片
 * @access Private
 */
router.post('/:id/images', authMiddleware, upload.array('images', 10), ProductController.uploadImages);

/**
 * @route DELETE /api/products/:id/images/:imageId
 * @desc 删除商品图片
 * @access Private
 */
router.delete('/:id/images/:imageId', authMiddleware, ProductController.deleteImage);

/**
 * @route GET /api/products/recommend/hot
 * @desc 获取热销商品
 * @access Public (可选认证)
 */
router.get('/recommend/hot', ProductController.getHotProducts);

/**
 * @route GET /api/products/recommend/new
 * @desc 获取新品推荐
 * @access Public (可选认证)
 */
router.get('/recommend/new', ProductController.getNewProducts);

module.exports = router;
