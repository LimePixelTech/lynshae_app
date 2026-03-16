/**
 * 认证控制器
 */

const bcrypt = require('bcryptjs');
const { query } = require('../config/database');
const { cache, keys } = require('../config/redis');
const { generateToken, verifyToken, blacklistToken } = require('../middleware/auth');
const { validationResult } = require('express-validator');
const { v4: uuidv4 } = require('uuid');
const { logger } = require('../utils/logger');

const BCRYPT_ROUNDS = parseInt(process.env.BCRYPT_ROUNDS) || 12;

// 注册
exports.register = async (req, res, next) => {
  try {
    // 验证错误
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        code: 'VALIDATION_ERROR',
        message: '参数验证失败',
        errors: errors.array()
      });
    }

    const { username, email, password } = req.body;

    // 检查邮箱是否已存在
    const existingUser = await query('SELECT id FROM users WHERE email = ?', [email]);
    if (existingUser && existingUser.length > 0) {
      return res.status(400).json({
        code: 'EMAIL_EXISTS',
        message: '邮箱已被注册'
      });
    }

    // 加密密码
    const passwordHash = await bcrypt.hash(password, BCRYPT_ROUNDS);

    // 创建用户
    const uuid = uuidv4();
    await query(
      `INSERT INTO users (uuid, username, email, password_hash, role_id, status) 
       VALUES (?, ?, ?, ?, 3, 1)`,
      [uuid, username, email, passwordHash]
    );

    logger.info('用户注册成功', { email, username });

    res.status(201).json({
      code: 'SUCCESS',
      message: '注册成功',
      data: { uuid, username, email }
    });
  } catch (error) {
    next(error);
  }
};

// 登录
exports.login = async (req, res, next) => {
  try {
    // 验证错误
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        code: 'VALIDATION_ERROR',
        message: '参数验证失败',
        errors: errors.array()
      });
    }

    const { email, password } = req.body;

    // 获取用户
    const users = await query(
      `SELECT id, uuid, username, email, password_hash, role_id, status 
       FROM users WHERE email = ? AND deleted_at IS NULL`,
      [email]
    );

    if (!users || users.length === 0) {
      return res.status(401).json({
        code: 'INVALID_CREDENTIALS',
        message: '邮箱或密码错误'
      });
    }

    const user = users[0];

    // 检查用户状态
    if (user.status !== 1) {
      return res.status(403).json({
        code: 'ACCOUNT_DISABLED',
        message: '账号已被禁用'
      });
    }

    // 验证密码
    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(401).json({
        code: 'INVALID_CREDENTIALS',
        message: '邮箱或密码错误'
      });
    }

    // 生成 Token
    const accessToken = generateToken({ userId: user.id, type: 'access' });
    const refreshToken = generateToken({ userId: user.id, type: 'refresh' }, '30d');

    // 保存刷新令牌
    await query(
      `INSERT INTO refresh_tokens (user_id, token, expires_at, ip_address) 
       VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY), ?)`,
      [user.id, refreshToken, req.ip]
    );

    // 更新登录信息
    await query(
      `UPDATE users SET last_login_at = NOW(), last_login_ip = ? WHERE id = ?`,
      [req.ip, user.id]
    );

    // 缓存用户信息
    await cache.set(keys.user(user.id), {
      id: user.id,
      uuid: user.uuid,
      username: user.username,
      email: user.email,
      roleId: user.role_id
    }, 86400);

    logger.info('用户登录成功', { userId: user.id, email });

    res.json({
      code: 'SUCCESS',
      message: '登录成功',
      data: {
        user: {
          id: user.id,
          uuid: user.uuid,
          username: user.username,
          email: user.email,
          roleId: user.role_id
        },
        tokens: {
          accessToken,
          refreshToken,
          expiresIn: '7d'
        }
      }
    });
  } catch (error) {
    next(error);
  }
};

// 登出
exports.logout = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader?.split(' ')[1];

    if (token) {
      await blacklistToken(token);
    }

    logger.info('用户登出', { userId: req.user.id });

    res.json({
      code: 'SUCCESS',
      message: '登出成功'
    });
  } catch (error) {
    next(error);
  }
};

// 刷新令牌
exports.refreshToken = async (req, res, next) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(400).json({
        code: 'MISSING_TOKEN',
        message: '请提供刷新令牌'
      });
    }

    // 验证刷新令牌
    const decoded = verifyToken(refreshToken);
    
    // 检查令牌是否在数据库中
    const tokens = await query(
      `SELECT id FROM refresh_tokens WHERE token = ? AND is_revoked = FALSE AND expires_at > NOW()`,
      [refreshToken]
    );

    if (!tokens || tokens.length === 0) {
      return res.status(401).json({
        code: 'INVALID_TOKEN',
        message: '刷新令牌无效或已过期'
      });
    }

    // 生成新的访问令牌
    const newAccessToken = generateToken({ userId: decoded.userId, type: 'access' });

    res.json({
      code: 'SUCCESS',
      data: {
        accessToken: newAccessToken,
        expiresIn: '7d'
      }
    });
  } catch (error) {
    next(error);
  }
};

// 获取当前用户信息
exports.getCurrentUser = async (req, res, next) => {
  try {
    const user = await cache.get(keys.user(req.user.id));

    if (!user) {
      const users = await query(
        `SELECT id, uuid, username, email, avatar, nickname, role_id 
         FROM users WHERE id = ?`,
        [req.user.id]
      );
      
      if (users && users.length > 0) {
        await cache.set(keys.user(req.user.id), users[0], 86400);
        res.json({
          code: 'SUCCESS',
          data: users[0]
        });
      } else {
        return res.status(404).json({
          code: 'NOT_FOUND',
          message: '用户不存在'
        });
      }
    } else {
      res.json({
        code: 'SUCCESS',
        data: user
      });
    }
  } catch (error) {
    next(error);
  }
};

// 修改密码
exports.changePassword = async (req, res, next) => {
  try {
    const { currentPassword, newPassword } = req.body;

    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        code: 'MISSING_PARAMS',
        message: '请提供当前密码和新密码'
      });
    }

    // 获取当前用户
    const users = await query(
      `SELECT password_hash FROM users WHERE id = ?`,
      [req.user.id]
    );

    if (!users || users.length === 0) {
      return res.status(404).json({
        code: 'NOT_FOUND',
        message: '用户不存在'
      });
    }

    // 验证当前密码
    const isMatch = await bcrypt.compare(currentPassword, users[0].password_hash);
    if (!isMatch) {
      return res.status(400).json({
        code: 'INVALID_PASSWORD',
        message: '当前密码错误'
      });
    }

    // 更新密码
    const newPasswordHash = await bcrypt.hash(newPassword, BCRYPT_ROUNDS);
    await query(
      `UPDATE users SET password_hash = ?, updated_at = NOW() WHERE id = ?`,
      [newPasswordHash, req.user.id]
    );

    logger.info('密码修改成功', { userId: req.user.id });

    res.json({
      code: 'SUCCESS',
      message: '密码修改成功'
    });
  } catch (error) {
    next(error);
  }
};
