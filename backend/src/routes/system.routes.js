/**
 * 系统路由
 */
const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');
const SystemController = require('../controllers/system.controller');

// 路由
/**
 * @route GET /api/system/configs
 * @desc 获取系统配置
 * @access Private
 */
router.get('/configs', authMiddleware, SystemController.getConfigs);

/**
 * @route PUT /api/system/configs
 * @desc 更新系统配置
 * @access Admin
 */
router.put('/configs', authMiddleware, SystemController.updateConfigs);

/**
 * @route GET /api/system/logs
 * @desc 获取操作日志
 * @access Admin
 */
router.get('/logs', authMiddleware, SystemController.getLogs);

/**
 * @route GET /api/system/stats
 * @desc 获取系统统计信息
 * @access Private
 */
router.get('/stats', authMiddleware, SystemController.getStats);

/**
 * @route POST /api/system/cache/clear
 * @desc 清除缓存
 * @access Admin
 */
router.post('/cache/clear', authMiddleware, SystemController.clearCache);

module.exports = router;
