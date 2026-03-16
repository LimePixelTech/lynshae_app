/**
 * JWT 认证中间件
 */

const jwt = require('jsonwebtoken');
const { query } = require('../config/database');
const { cache, keys } = require('../config/redis');

const JWT_SECRET = process.env.JWT_SECRET || 'default-secret-change-in-production';

// 验证 Token
const authenticate = async (req, res, next) => {
  try {
    // 获取 Token
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        code: 'UNAUTHORIZED',
        message: '未提供认证令牌'
      });
    }

    const token = authHeader.split(' ')[1];

    // 检查 Token 是否在黑名单中
    const isBlacklisted = await cache.exists(`token:blacklist:${token}`);
    if (isBlacklisted) {
      return res.status(401).json({
        code: 'UNAUTHORIZED',
        message: '令牌已失效'
      });
    }

    // 验证 Token
    const decoded = jwt.verify(token, JWT_SECRET);

    // 获取管理员信息（根据 token 中的 id）
    const admin = await query(
      'SELECT id, uuid, username, email, role, status FROM admins WHERE id = ? AND status = 1',
      [decoded.id]
    );

    if (!admin || admin.length === 0) {
      return res.status(401).json({
        code: 'UNAUTHORIZED',
        message: '管理员不存在'
      });
    }

    // 附加管理员信息到请求
    req.admin = {
      id: admin[0].id,
      uuid: admin[0].uuid,
      username: admin[0].username,
      email: admin[0].email,
      role: admin[0].role
    };

    next();
  } catch (error) {
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({
        code: 'UNAUTHORIZED',
        message: '无效的令牌'
      });
    }
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        code: 'UNAUTHORIZED',
        message: '令牌已过期'
      });
    }
    next(error);
  }
};

// 可选认证（有 token 则验证，没有也允许访问）
const optionalAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.split(' ')[1];
      
      // 检查 Token 是否在黑名单中
      const isBlacklisted = await cache.exists(`token:blacklist:${token}`);
      if (!isBlacklisted) {
        const decoded = jwt.verify(token, JWT_SECRET);
        
        // 获取管理员信息
        const admin = await query(
          'SELECT id, uuid, username, email, role, status FROM admins WHERE id = ? AND status = 1',
          [decoded.id]
        );
        
        if (admin && admin.length > 0) {
          req.admin = {
            id: admin[0].id,
            uuid: admin[0].uuid,
            username: admin[0].username,
            email: admin[0].email,
            role: admin[0].role
          };
        }
      }
    }
    next();
  } catch (error) {
    // Token 无效时继续，不阻止请求
    next();
  }
};

// 角色权限检查
const requireRole = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        code: 'UNAUTHORIZED',
        message: '请先登录'
      });
    }

    // 超级管理员拥有所有权限
    if (req.user.roleId === 1) {
      return next();
    }

    // TODO: 从角色表获取用户角色代码
    // 这里简化处理
    next();
  };
};

// 生成 Token
const generateToken = (payload, expiresIn = '7d') => {
  return jwt.sign(payload, JWT_SECRET, { expiresIn });
};

// 验证 Token
const verifyToken = (token) => {
  return jwt.verify(token, JWT_SECRET);
};

// 注销 Token（加入黑名单）
const blacklistToken = async (token, expiresIn = '7d') => {
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    const ttl = Math.floor((decoded.exp - Date.now() / 1000));
    if (ttl > 0) {
      await cache.set(`token:blacklist:${token}`, '1', ttl);
    }
  } catch {
    // Token 已过期或无效，无需处理
  }
};

module.exports = {
  authenticate,
  optionalAuth,
  requireRole,
  generateToken,
  verifyToken,
  blacklistToken
};
