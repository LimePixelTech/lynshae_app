/**
 * 认证路由
 */
const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const AuthController = require('../controllers/auth.controller');
const authMiddleware = require('../middleware/auth');
const { loginLimiter } = require('../middleware/rateLimiter');
const validate = require('../middleware/validate');

// 验证规则
const loginValidation = [
  body('username')
    .trim()
    .notEmpty().withMessage('用户名不能为空')
    .isLength({ min: 3, max: 50 }).withMessage('用户名长度 3-50 个字符'),
  body('password')
    .notEmpty().withMessage('密码不能为空')
    .isLength({ min: 6 }).withMessage('密码至少 6 个字符'),
  validate,
];

const registerValidation = [
  body('username')
    .trim()
    .notEmpty().withMessage('用户名不能为空')
    .isLength({ min: 3, max: 50 }).withMessage('用户名长度 3-50 个字符')
    .matches(/^[a-zA-Z0-9_]+$/).withMessage('用户名只能包含字母、数字和下划线'),
  body('password')
    .notEmpty().withMessage('密码不能为空')
    .isLength({ min: 8 }).withMessage('密码至少 8 个字符')
    .matches(/^(?=.*[a-zA-Z])(?=.*\d)/).withMessage('密码必须包含字母和数字'),
  body('email')
    .trim()
    .notEmpty().withMessage('邮箱不能为空')
    .isEmail().withMessage('邮箱格式不正确')
    .normalizeEmail(),
  validate,
];

const refreshValidation = [
  body('refreshToken')
    .notEmpty().withMessage('刷新令牌不能为空'),
  validate,
];

const changePasswordValidation = [
  body('oldPassword')
    .notEmpty().withMessage('原密码不能为空'),
  body('newPassword')
    .notEmpty().withMessage('新密码不能为空')
    .isLength({ min: 8 }).withMessage('新密码至少 8 个字符')
    .matches(/^(?=.*[a-zA-Z])(?=.*\d)/).withMessage('新密码必须包含字母和数字'),
  validate,
];

// 路由
/**
 * @route POST /api/auth/login
 * @desc 管理员登录
 * @access Public
 */
router.post('/login', loginLimiter, loginValidation, AuthController.login);

/**
 * @route POST /api/auth/register
 * @desc 注册管理员 (仅超级管理员可操作)
 * @access Admin
 */
router.post('/register', authMiddleware, registerValidation, AuthController.register);

/**
 * @route POST /api/auth/refresh
 * @desc 刷新 Token
 * @access Public
 */
router.post('/refresh', refreshValidation, AuthController.refreshToken);

/**
 * @route POST /api/auth/logout
 * @desc 登出 (加入 Token 黑名单)
 * @access Private
 */
router.post('/logout', authMiddleware, AuthController.logout);

/**
 * @route GET /api/auth/me
 * @desc 获取当前管理员信息
 * @access Private
 */
router.get('/me', authMiddleware, AuthController.getMe);

/**
 * @route PUT /api/auth/password
 * @desc 修改密码
 * @access Private
 */
router.put('/password', authMiddleware, changePasswordValidation, AuthController.changePassword);

module.exports = router;
