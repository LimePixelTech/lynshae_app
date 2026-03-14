/**
 * 品牌路由
 */
const express = require('express');
const router = express.Router();
const { body, param } = require('express-validator');
const BrandController = require('../controllers/brand.controller');
const authMiddleware = require('../middleware/auth');
const validate = require('../middleware/validate');

// 验证规则
const createBrandValidation = [
  body('name')
    .trim()
    .notEmpty().withMessage('品牌名称不能为空')
    .isLength({ max: 100 }).withMessage('品牌名称不能超过 100 个字符'),
  body('description')
    .optional()
    .isLength({ max: 500 }).withMessage('描述不能超过 500 个字符'),
  validate,
];

const updateBrandValidation = [
  param('id')
    .isInt({ min: 1 }).withMessage('品牌 ID 必须为正整数'),
  body('name')
    .optional()
    .trim()
    .isLength({ max: 100 }).withMessage('品牌名称不能超过 100 个字符'),
  validate,
];

// 路由
router.get('/', authMiddleware, BrandController.list);
router.get('/:id', authMiddleware, BrandController.getById);
router.post('/', authMiddleware, createBrandValidation, BrandController.create);
router.put('/:id', authMiddleware, updateBrandValidation, BrandController.update);
router.delete('/:id', authMiddleware, BrandController.delete);

module.exports = router;
