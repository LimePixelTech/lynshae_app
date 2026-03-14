/**
 * 分类路由
 */
const express = require('express');
const router = express.Router();
const { body, param, query } = require('express-validator');
const CategoryController = require('../controllers/category.controller');
const authMiddleware = require('../middleware/auth');
const validate = require('../middleware/validate');

// 验证规则
const createCategoryValidation = [
  body('name')
    .trim()
    .notEmpty().withMessage('分类名称不能为空')
    .isLength({ max: 100 }).withMessage('分类名称不能超过 100 个字符'),
  body('parent_id')
    .optional()
    .isInt({ min: 1 }).withMessage('父分类 ID 必须为正整数'),
  body('sort_order')
    .optional()
    .isInt().withMessage('排序必须为整数'),
  validate,
];

const updateCategoryValidation = [
  param('id')
    .isInt({ min: 1 }).withMessage('分类 ID 必须为正整数'),
  body('name')
    .optional()
    .trim()
    .isLength({ max: 100 }).withMessage('分类名称不能超过 100 个字符'),
  body('parent_id')
    .optional()
    .isInt({ min: 1 }).withMessage('父分类 ID 必须为正整数'),
  body('sort_order')
    .optional()
    .isInt().withMessage('排序必须为整数'),
  validate,
];

// 路由
/**
 * @route GET /api/categories
 * @desc 获取分类列表 (树形结构)
 * @access Private
 */
router.get('/', authMiddleware, CategoryController.list);

/**
 * @route GET /api/categories/tree
 * @desc 获取分类树形结构
 * @access Private
 */
router.get('/tree', authMiddleware, CategoryController.getTree);

/**
 * @route GET /api/categories/:id
 * @desc 获取分类详情
 * @access Private
 */
router.get('/:id', authMiddleware, CategoryController.getById);

/**
 * @route POST /api/categories
 * @desc 创建分类
 * @access Private
 */
router.post('/', authMiddleware, createCategoryValidation, CategoryController.create);

/**
 * @route PUT /api/categories/:id
 * @desc 更新分类
 * @access Private
 */
router.put('/:id', authMiddleware, updateCategoryValidation, CategoryController.update);

/**
 * @route DELETE /api/categories/:id
 * @desc 删除分类
 * @access Private
 */
router.delete('/:id', authMiddleware, CategoryController.delete);

/**
 * @route PATCH /api/categories/:id/status
 * @desc 更新分类状态
 * @access Private
 */
router.patch('/:id/status', authMiddleware, CategoryController.updateStatus);

module.exports = router;
