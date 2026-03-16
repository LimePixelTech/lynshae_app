/**
 * 商品路由
 */
const express = require('express');
const router = express.Router();
const { body, query, param } = require('express-validator');
const ProductController = require('../controllers/product.controller');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validate');
const { upload } = require('../middleware/upload');

// 验证规则 - 创建商品
const createProductValidation = [
  body('spu').trim().notEmpty().withMessage('SPU 不能为空').isLength({ max: 50 }),
  body('name').trim().notEmpty().withMessage('商品名称不能为空').isLength({ max: 200 }),
  body('price').notEmpty().withMessage('价格不能为空').isFloat({ min: 0 }),
  body('category_id').optional().isInt({ min: 1 }),
  body('stock').optional().isInt({ min: 0 }),
];

// 验证规则 - 更新商品
const updateProductValidation = [
  param('id').isInt({ min: 1 }),
  body('spu').optional().trim().isLength({ max: 50 }),
  body('name').optional().trim().isLength({ max: 200 }),
  body('price').optional().isFloat({ min: 0 }),
  body('category_id').optional().isInt({ min: 1 }),
  body('stock').optional().isInt({ min: 0 }),
];

// 验证规则 - 列表查询
const listValidation = [
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 100 }),
  query('category_id').optional().isInt({ min: 1 }),
  query('status').optional().isInt({ min: 0, max: 1 }),
];

// ==================== 管理后台路由 ====================

router.get('/admin/list', authenticate, listValidation, validate, ProductController.list);
router.get('/admin/stats', authenticate, ProductController.getStats);
router.get('/admin/:id', authenticate, ProductController.getById);
router.post('/admin', authenticate, upload.array('images', 10), createProductValidation, validate, ProductController.create);
router.put('/admin/:id', authenticate, upload.array('images', 10), updateProductValidation, validate, ProductController.update);
router.delete('/admin/:id', authenticate, ProductController.delete);
router.post('/admin/batch-delete', authenticate, ProductController.batchDelete);
router.patch('/admin/:id/status', authenticate, ProductController.updateStatus);
router.post('/admin/:id/images', authenticate, upload.array('images', 10), ProductController.uploadImages);
router.delete('/admin/:id/images/:imageId', authenticate, ProductController.deleteImage);
router.post('/admin/:id/images/batch-delete', authenticate, ProductController.batchDeleteImages);
router.put('/admin/:id/images/sort', authenticate, ProductController.updateImageSort);
router.put('/admin/:id/skus', authenticate, ProductController.updateSkus);

// ==================== 前台展示路由 ====================

router.get('/', ProductController.list);
router.get('/detail/:id', ProductController.getDetail);

module.exports = router;
