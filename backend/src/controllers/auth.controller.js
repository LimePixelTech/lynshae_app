/**
 * 认证控制器
 */
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const { getPool } = require('../config/database');
const { cache } = require('../config/redis');
const config = require('../config');
const logger = require('../utils/logger');
const { AppError } = require('../middleware/errorHandler');

class AuthController {
  /**
   * 管理员登录
   */
  static async login(req, res, next) {
    const { username, password } = req.body;

    try {
      const pool = getPool();

      // 查询管理员
      const [rows] = await pool.execute(
        'SELECT * FROM admins WHERE (username = ? OR email = ?) AND status = 1',
        [username, username]
      );

      if (rows.length === 0) {
        throw new AppError('用户名或密码错误', 401, 'INVALID_CREDENTIALS');
      }

      const admin = rows[0];

      // 验证密码
      const isValidPassword = await bcrypt.compare(password, admin.password);
      if (!isValidPassword) {
        throw new AppError('用户名或密码错误', 401, 'INVALID_CREDENTIALS');
      }

      // 更新登录信息
      await pool.execute(
        'UPDATE admins SET last_login_at = NOW(), last_login_ip = ? WHERE id = ?',
        [req.ip, admin.id]
      );

      // 生成 Token
      const tokenPayload = {
        id: admin.id,
        username: admin.username,
        role: admin.role,
      };

      const accessToken = jwt.sign(tokenPayload, config.jwt.secret, {
        expiresIn: config.jwt.expiresIn,
      });

      const refreshToken = jwt.sign(
        { ...tokenPayload, type: 'refresh' },
        config.jwt.secret,
        { expiresIn: config.jwt.refreshExpiresIn }
      );

      // 记录日志
      logger.info(`Admin ${admin.username} logged in from ${req.ip}`);

      res.json({
        success: true,
        message: '登录成功',
        data: {
          admin: {
            id: admin.id,
            username: admin.username,
            email: admin.email,
            avatar: admin.avatar,
            role: admin.role,
          },
          accessToken,
          refreshToken,
          expiresIn: config.jwt.expiresIn,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 注册管理员
   */
  static async register(req, res, next) {
    const { username, password, email } = req.body;

    try {
      const pool = getPool();

      // 检查用户名是否已存在
      const [existing] = await pool.execute(
        'SELECT id FROM admins WHERE username = ? OR email = ?',
        [username, email]
      );

      if (existing.length > 0) {
        throw new AppError('用户名或邮箱已存在', 409, 'DUPLICATE_ENTRY');
      }

      // 加密密码
      const hashedPassword = await bcrypt.hash(password, config.security.bcryptRounds);

      // 插入新管理员
      const [result] = await pool.execute(
        'INSERT INTO admins (username, password, email, role, status) VALUES (?, ?, ?, 2, 1)',
        [username, hashedPassword, email]
      );

      logger.info(`New admin registered: ${username}`);

      res.status(201).json({
        success: true,
        message: '注册成功',
        data: {
          id: result.insertId,
          username,
          email,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 刷新 Token
   */
  static async refreshToken(req, res, next) {
    const { refreshToken } = req.body;

    try {
      // 验证 Refresh Token
      let decoded;
      try {
        decoded = jwt.verify(refreshToken, config.jwt.secret);
      } catch (error) {
        throw new AppError('无效的刷新令牌', 401, 'INVALID_REFRESH_TOKEN');
      }

      if (decoded.type !== 'refresh') {
        throw new AppError('令牌类型不正确', 401, 'INVALID_TOKEN_TYPE');
      }

      // 检查管理员状态
      const pool = getPool();
      const [rows] = await pool.execute(
        'SELECT id, username, role, status FROM admins WHERE id = ? AND status = 1',
        [decoded.id]
      );

      if (rows.length === 0) {
        throw new AppError('管理员不存在或已禁用', 401, 'ADMIN_NOT_FOUND');
      }

      // 生成新的 Access Token
      const tokenPayload = {
        id: decoded.id,
        username: decoded.username,
        role: decoded.role,
      };

      const accessToken = jwt.sign(tokenPayload, config.jwt.secret, {
        expiresIn: config.jwt.expiresIn,
      });

      res.json({
        success: true,
        data: {
          accessToken,
          expiresIn: config.jwt.expiresIn,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 登出
   */
  static async logout(req, res, next) {
    try {
      const { token } = req;

      // 将 Token 加入黑名单
      const decoded = jwt.decode(token);
      const ttl = decoded.exp * 1000 - Date.now();

      if (ttl > 0) {
        await cache.set(`token:blacklist:${token}`, true, Math.ceil(ttl / 1000));
      }

      logger.info(`Admin ${req.admin.username} logged out`);

      res.json({
        success: true,
        message: '登出成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取当前管理员信息
   */
  static async getMe(req, res, next) {
    try {
      const pool = getPool();
      const [rows] = await pool.execute(
        'SELECT id, username, email, avatar, role, status, last_login_at, created_at FROM admins WHERE id = ?',
        [req.admin.id]
      );

      if (rows.length === 0) {
        throw new AppError('管理员不存在', 404, 'ADMIN_NOT_FOUND');
      }

      res.json({
        success: true,
        data: rows[0],
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 修改密码
   */
  static async changePassword(req, res, next) {
    const { oldPassword, newPassword } = req.body;

    try {
      const pool = getPool();

      // 获取当前管理员
      const [rows] = await pool.execute(
        'SELECT password FROM admins WHERE id = ?',
        [req.admin.id]
      );

      if (rows.length === 0) {
        throw new AppError('管理员不存在', 404, 'ADMIN_NOT_FOUND');
      }

      // 验证原密码
      const isValidPassword = await bcrypt.compare(oldPassword, rows[0].password);
      if (!isValidPassword) {
        throw new AppError('原密码错误', 400, 'INVALID_PASSWORD');
      }

      // 加密新密码
      const hashedPassword = await bcrypt.hash(newPassword, config.security.bcryptRounds);

      // 更新密码
      await pool.execute(
        'UPDATE admins SET password = ? WHERE id = ?',
        [hashedPassword, req.admin.id]
      );

      logger.info(`Admin ${req.admin.username} changed password`);

      res.json({
        success: true,
        message: '密码修改成功',
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = AuthController;
