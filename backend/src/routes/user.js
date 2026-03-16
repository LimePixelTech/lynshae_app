/**
 * 用户路由
 */

const express = require('express');
const router = express.Router();
const { authenticate, optionalAuth } = require('../middleware/auth');
const { upload } = require('../middleware/upload');
const UserController = require('../controllers/user.controller');
const validate = require('../middleware/validate');
const { body, param, query } = require('express-validator');

// 验证规则
const updateProfileValidation = [
  body('username').optional().trim().isLength({ min: 3, max: 50 }),
  body('email').optional().trim().isEmail(),
  body('phone').optional().trim().isMobilePhone('zh-CN'),
  body('nickname').optional().trim().isLength({ max: 50 }),
  body('gender').optional().isIn([0, 1, 2]),
  body('birthday').optional().isDate(),
  body('avatar').optional().trim().isURL(),
];

const changePasswordValidation = [
  body('oldPassword').notEmpty().withMessage('原密码不能为空'),
  body('newPassword').notEmpty().withMessage('新密码不能为空').isLength({ min: 6 }),
];

// ==================== 个人用户路由 ====================

// 获取当前用户信息（需要登录）
router.get('/me', authenticate, UserController.getMe);

// 更新当前用户信息（需要登录）
router.put('/me', authenticate, updateProfileValidation, validate, UserController.updateMe);

// 修改密码（需要登录）
router.post('/me/change-password', authenticate, changePasswordValidation, validate, UserController.changePassword);

// 上传头像（需要登录）
router.post('/me/avatar', authenticate, upload.single('avatar'), UserController.uploadAvatar);

// ==================== 管理员路由 ====================

// 获取用户列表（管理员）
router.get('/', authenticate, UserController.list);

// 获取用户详情（管理员）
router.get('/:id', authenticate, UserController.getById);

// 更新用户状态（管理员）
router.patch('/:id/status', authenticate, UserController.updateStatus);

// 删除用户（管理员）
router.delete('/:id', authenticate, UserController.delete);

module.exports = router;
