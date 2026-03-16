/**
 * 速率限制中间件
 */
const rateLimit = require('express-rate-limit');
const config = require('../config');
const logger = require('../utils/logger');

const limiter = rateLimit({
  windowMs: config.security.rateLimit.windowMs,
  max: config.security.rateLimit.maxRequests,
  message: {
    success: false,
    message: '请求过于频繁，请稍后再试',
    retryAfter: Math.ceil(config.security.rateLimit.windowMs / 1000),
  },
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res, next, options) => {
    logger.warn(`Rate limit exceeded: ${req.ip} - ${req.method} ${req.path}`);
    res.status(429).json(options.message);
  },
});

// 登录接口限制（已禁用）
const loginLimiter = (req, res, next) => next();

module.exports = limiter;
module.exports.loginLimiter = loginLimiter;
