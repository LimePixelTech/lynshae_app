/**
 * JWT 认证中间件
 */
const jwt = require('jsonwebtoken');
const { getPool } = require('../config/database');
const { cache } = require('../config/redis');
const config = require('../config');
const logger = require('../utils/logger');
const { AppError } = require('./errorHandler');

/**
 * 验证 JWT Token
 */
async function authMiddleware(req, res, next) {
  try {
    // 获取 Token
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new AppError('未提供认证令牌', 401, 'MISSING_TOKEN');
    }

    const token = authHeader.substring(7);

    // 检查 Token 是否在黑名单中
    const isBlacklisted = await cache.get(`token:blacklist:${token}`);
    if (isBlacklisted) {
      throw new AppError('令牌已失效', 401, 'TOKEN_BLACKLISTED');
    }

    // 验证 Token
    let decoded;
    try {
      decoded = jwt.verify(token, config.jwt.secret);
    } catch (error) {
      if (error.name === 'TokenExpiredError') {
        throw new AppError('认证令牌已过期', 401, 'TOKEN_EXPIRED');
      }
      throw new AppError('无效的认证令牌', 401, 'INVALID_TOKEN');
    }

    // 获取管理员信息
    const pool = getPool();
    const [rows] = await pool.execute(
      'SELECT id, username, email, role, status FROM admins WHERE id = ? AND status = 1',
      [decoded.id]
    );

    if (rows.length === 0) {
      throw new AppError('管理员不存在或已禁用', 401, 'ADMIN_NOT_FOUND');
    }

    // 附加管理员信息到请求对象
    req.admin = {
      id: rows[0].id,
      username: rows[0].username,
      email: rows[0].email,
      role: rows[0].role,
    };

    // 附加 Token 信息
    req.token = token;

    next();
  } catch (error) {
    if (error instanceof AppError) {
      next(error);
    } else {
      logger.error('Auth middleware error:', error);
      next(new AppError('认证失败', 500, 'AUTH_ERROR'));
    }
  }
}

/**
 * 可选认证中间件 (Token 存在则验证，不存在则跳过)
 */
async function optionalAuth(req, res, next) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return next();
    }

    const token = authHeader.substring(7);
    const decoded = jwt.verify(token, config.jwt.secret);

    const pool = getPool();
    const [rows] = await pool.execute(
      'SELECT id, username, email, role, status FROM admins WHERE id = ? AND status = 1',
      [decoded.id]
    );

    if (rows.length > 0) {
      req.admin = {
        id: rows[0].id,
        username: rows[0].username,
        email: rows[0].email,
        role: rows[0].role,
      };
    }

    next();
  } catch (error) {
    // Token 无效时跳过认证
    next();
  }
}

/**
 * 权限检查中间件
 */
function requireRole(...roles) {
  return (req, res, next) => {
    if (!req.admin) {
      return next(new AppError('未认证', 401, 'UNAUTHORIZED'));
    }

    if (!roles.includes(req.admin.role)) {
      return next(new AppError('权限不足', 403, 'FORBIDDEN'));
    }

    next();
  };
}

/**
 * 超级管理员权限
 */
const requireAdmin = requireRole(1);

module.exports = authMiddleware;
module.exports.optionalAuth = optionalAuth;
module.exports.requireRole = requireRole;
module.exports.requireAdmin = requireAdmin;
