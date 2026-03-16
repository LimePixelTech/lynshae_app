/**
 * 分类路由
 */
const express = require('express');
const router = express.Router();
const { body, param } = require('express-validator');
const CategoryController = require('../controllers/category.controller');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validate');

const createCategoryValidation = [
  body('name').trim().notEmpty().withMessage('分类名称不能为空').isLength({ max: 100 }),
  body('code').optional().trim().isLength({ max: 50 }),
  body('parent_id').optional().isInt({ min: 1 }),
  body('sort_order').optional().isInt(),
];

const updateCategoryValidation = [
  param('id').isInt({ min: 1 }),
  body('name').optional().trim().isLength({ max: 100 }),
  body('code').optional().trim().isLength({ max: 50 }),
  body('parent_id').optional().isInt({ min: 1 }),
  body('sort_order').optional().isInt(),
];

// 管理后台路由
router.get('/admin/list', authenticate, CategoryController.list);
router.get('/admin/tree', authenticate, CategoryController.getTree);
router.get('/admin/:id', authenticate, CategoryController.getById);
router.post('/admin', authenticate, createCategoryValidation, validate, CategoryController.create);
router.put('/admin/:id', authenticate, updateCategoryValidation, validate, CategoryController.update);
router.delete('/admin/:id', authenticate, CategoryController.delete);
router.post('/admin/batch-delete', authenticate, CategoryController.batchDelete);
router.patch('/admin/:id/status', authenticate, CategoryController.updateStatus);

// 前台展示路由
router.get('/', CategoryController.list);
router.get('/tree', CategoryController.getTree);

module.exports = router;
