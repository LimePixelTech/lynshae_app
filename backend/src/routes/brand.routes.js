/**
 * 品牌路由
 */
const express = require('express');
const router = express.Router();
const { body, param } = require('express-validator');
const BrandController = require('../controllers/brand.controller');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validate');

const createBrandValidation = [
  body('name').trim().notEmpty().withMessage('品牌名称不能为空').isLength({ max: 100 }),
  body('en_name').optional().trim().isLength({ max: 100 }),
  body('website').optional().isURL(),
];

const updateBrandValidation = [
  param('id').isInt({ min: 1 }),
  body('name').optional().trim().isLength({ max: 100 }),
  body('en_name').optional().trim().isLength({ max: 100 }),
  body('website').optional().isURL(),
];

// 管理后台路由
router.get('/admin/list', authenticate, BrandController.list);
router.get('/admin/:id', authenticate, BrandController.getById);
router.post('/admin', authenticate, createBrandValidation, validate, BrandController.create);
router.put('/admin/:id', authenticate, updateBrandValidation, validate, BrandController.update);
router.delete('/admin/:id', authenticate, BrandController.delete);
router.post('/admin/batch-delete', authenticate, BrandController.batchDelete);

// 前台展示路由
router.get('/', BrandController.list);

module.exports = router;
