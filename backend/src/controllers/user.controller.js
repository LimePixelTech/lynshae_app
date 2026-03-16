/**
 * 用户控制器 - LynShae 用户管理系统
 */
const bcrypt = require('bcryptjs');
const { getPool } = require('../config/database');
const { cache } = require('../config/redis');
const config = require('../config');
const { logger } = require('../utils/logger');
const { AppError } = require('../middleware/errorHandler');

class UserController {
  /**
   * 获取当前用户信息
   */
  static async getMe(req, res, next) {
    try {
      const pool = getPool();
      const userId = req.user?.id || req.admin?.id;
      const isAdmin = !!req.admin;

      if (!userId) {
        throw new AppError('未登录', 401, 'UNAUTHORIZED');
      }

      const table = isAdmin ? 'admins' : 'users';
      const [rows] = await pool.query(
        `SELECT 
          id, uuid, username, email, 
          ${isAdmin ? 'avatar, role' : 'phone, nickname, gender, birthday, avatar'} ,
          status, 
          ${isAdmin ? 'last_login_at, created_at' : 'last_login_at, email_verified, phone_verified, created_at'}
        FROM ${table} 
        WHERE id = ?`,
        [userId]
      );

      if (rows.length === 0) {
        throw new AppError('用户不存在', 404, 'USER_NOT_FOUND');
      }

      const userData = rows[0];

      res.json({
        success: true,
        data: {
          ...userData,
          is_admin: isAdmin,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 更新当前用户信息
   */
  static async updateMe(req, res, next) {
    const transaction = await (await getPool()).getConnection();

    try {
      await transaction.beginTransaction();

      const userId = req.user?.id || req.admin?.id;
      const isAdmin = !!req.admin;

      if (!userId) {
        throw new AppError('未登录', 401, 'UNAUTHORIZED');
      }

      const {
        username,
        email,
        phone,
        nickname,
        gender,
        birthday,
        avatar,
      } = req.body;

      const table = isAdmin ? 'admins' : 'users';

      // 检查用户名是否已存在（如果更新用户名）
      if (username) {
        const [existing] = await transaction.query(
          `SELECT id FROM ${table} WHERE username = ? AND id != ?`,
          [username, userId]
        );

        if (existing.length > 0) {
          throw new AppError('用户名已存在', 409, 'DUPLICATE_USERNAME');
        }
      }

      // 检查邮箱是否已存在（如果更新邮箱）
      if (email) {
        const [existing] = await transaction.query(
          `SELECT id FROM ${table} WHERE email = ? AND id != ?`,
          [email, userId]
        );

        if (existing.length > 0) {
          throw new AppError('邮箱已被使用', 409, 'DUPLICATE_EMAIL');
        }
      }

      // 检查手机号是否已存在（仅普通用户，如果更新手机号）
      if (phone && !isAdmin) {
        const [existing] = await transaction.query(
          'SELECT id FROM users WHERE phone = ? AND id != ?',
          [phone, userId]
        );

        if (existing.length > 0) {
          throw new AppError('手机号已被使用', 409, 'DUPLICATE_PHONE');
        }
      }

      // 构建更新字段
      const fields = [];
      const values = [];

      if (username !== undefined) {
        fields.push('username = ?');
        values.push(username);
      }

      if (email !== undefined) {
        fields.push('email = ?');
        values.push(email);
      }

      if (!isAdmin) {
        if (phone !== undefined) {
          fields.push('phone = ?');
          values.push(phone);
        }

        if (nickname !== undefined) {
          fields.push('nickname = ?');
          values.push(nickname);
        }

        if (gender !== undefined) {
          fields.push('gender = ?');
          values.push(parseInt(gender));
        }

        if (birthday !== undefined) {
          fields.push('birthday = ?');
          values.push(birthday || null);
        }
      }

      if (avatar !== undefined) {
        fields.push('avatar = ?');
        values.push(avatar || null);
      }

      if (fields.length > 0) {
        values.push(userId);
        await transaction.query(
          `UPDATE ${table} SET ${fields.join(', ')} WHERE id = ?`,
          values
        );
      }

      await transaction.commit();

      // 清除缓存
      await cache.del(`user:${userId}`);

      logger.info(`${isAdmin ? 'Admin' : 'User'} ${userId} updated profile`);

      res.json({
        success: true,
        message: '用户信息更新成功',
      });
    } catch (error) {
      await transaction.rollback();
      next(error);
    } finally {
      transaction.release();
    }
  }

  /**
   * 修改密码
   */
  static async changePassword(req, res, next) {
    const { oldPassword, newPassword } = req.body;

    try {
      const pool = getPool();
      const userId = req.user?.id || req.admin?.id;
      const isAdmin = !!req.admin;

      if (!userId) {
        throw new AppError('未登录', 401, 'UNAUTHORIZED');
      }

      if (!oldPassword || !newPassword) {
        throw new AppError('请提供原密码和新密码', 400, 'INVALID_PASSWORD');
      }

      if (newPassword.length < 6) {
        throw new AppError('密码长度至少为 6 位', 400, 'PASSWORD_TOO_SHORT');
      }

      const table = isAdmin ? 'admins' : 'users';
      const passwordField = isAdmin ? 'password' : 'password_hash';

      // 获取当前用户密码
      const [rows] = await pool.query(
        `SELECT ${passwordField} FROM ${table} WHERE id = ?`,
        [userId]
      );

      if (rows.length === 0) {
        throw new AppError('用户不存在', 404, 'USER_NOT_FOUND');
      }

      // 验证原密码
      const isValidPassword = await bcrypt.compare(oldPassword, rows[0][passwordField]);
      if (!isValidPassword) {
        throw new AppError('原密码错误', 400, 'INVALID_PASSWORD');
      }

      // 加密新密码
      const hashedPassword = await bcrypt.hash(newPassword, config.security.bcryptRounds);

      // 更新密码
      await pool.query(
        `UPDATE ${table} SET ${passwordField} = ? WHERE id = ?`,
        [hashedPassword, userId]
      );

      logger.info(`${isAdmin ? 'Admin' : 'User'} ${userId} changed password`);

      res.json({
        success: true,
        message: '密码修改成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 上传头像
   */
  static async uploadAvatar(req, res, next) {
    try {
      if (!req.file) {
        throw new AppError('请上传头像文件', 400, 'NO_FILE_UPLOADED');
      }

      const userId = req.user?.id || req.admin?.id;
      const isAdmin = !!req.admin;

      if (!userId) {
        throw new AppError('未登录', 401, 'UNAUTHORIZED');
      }

      const pool = getPool();
      const avatarUrl = `/uploads/${req.file.path.replace(/\\/g, '/').split('uploads/')[1]}`;
      const table = isAdmin ? 'admins' : 'users';

      await pool.query(
        `UPDATE ${table} SET avatar = ? WHERE id = ?`,
        [avatarUrl, userId]
      );

      // 清除缓存
      await cache.del(`user:${userId}`);

      res.json({
        success: true,
        message: '头像上传成功',
        data: {
          avatar: avatarUrl,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取用户列表（管理员）
   */
  static async list(req, res, next) {
    const {
      page = 1,
      limit = 20,
      keyword,
      status,
      role_id,
      sort = 'created_at',
      order = 'DESC',
    } = req.query;

    try {
      const pool = getPool();
      const offset = (page - 1) * limit;

      // 构建查询条件
      const conditions = ['deleted_at IS NULL'];
      const params = [];

      if (keyword) {
        conditions.push('(username LIKE ? OR email LIKE ? OR phone LIKE ?)');
        const keywordPattern = `%${keyword}%`;
        params.push(keywordPattern, keywordPattern, keywordPattern);
      }

      if (status !== undefined) {
        conditions.push('status = ?');
        params.push(parseInt(status));
      }

      if (role_id) {
        conditions.push('role_id = ?');
        params.push(parseInt(role_id));
      }

      // 排序字段白名单
      const allowedSorts = ['created_at', 'updated_at', 'last_login_at', 'username', 'email'];
      const orderBy = allowedSorts.includes(sort) ? sort : 'created_at';
      const sortOrder = order.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';

      // 查询总数
      const [countRows] = await pool.query(
        `SELECT COUNT(*) as total FROM users WHERE ${conditions.join(' AND ')}`,
        params
      );
      const total = countRows[0].total;

      // 查询数据
      const [rows] = await pool.query(
        `SELECT 
          id, uuid, username, email, phone, nickname, gender, avatar,
          status, role_id, last_login_at, email_verified, phone_verified,
          created_at, updated_at
        FROM users
        WHERE ${conditions.join(' AND ')}
        ORDER BY ${orderBy} ${sortOrder}
        LIMIT ? OFFSET ?`,
        [...params, parseInt(limit), offset]
      );

      res.json({
        success: true,
        data: {
          users: rows,
          pagination: {
            total,
            page: parseInt(page),
            limit: parseInt(limit),
            totalPages: Math.ceil(total / limit),
          },
        },
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 获取用户详情（管理员）
   */
  static async getById(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();

      const [rows] = await pool.query(
        `SELECT 
          id, uuid, username, email, phone, nickname, gender, birthday, avatar,
          status, role_id, last_login_at, last_login_ip, email_verified, phone_verified,
          created_at, updated_at
        FROM users
        WHERE id = ? AND deleted_at IS NULL`,
        [id]
      );

      if (rows.length === 0) {
        throw new AppError('用户不存在', 404, 'USER_NOT_FOUND');
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
   * 更新用户状态（管理员）
   */
  static async updateStatus(req, res, next) {
    const { id } = req.params;
    const { status } = req.body;

    try {
      const pool = getPool();

      if (status === undefined) {
        throw new AppError('请提供状态值', 400, 'INVALID_STATUS');
      }

      const [result] = await pool.query(
        'UPDATE users SET status = ? WHERE id = ? AND deleted_at IS NULL',
        [parseInt(status), id]
      );

      if (result.affectedRows === 0) {
        throw new AppError('用户不存在', 404, 'USER_NOT_FOUND');
      }

      // 清除缓存
      await cache.del(`user:${id}`);

      res.json({
        success: true,
        message: '用户状态更新成功',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * 删除用户（软删除，管理员）
   */
  static async delete(req, res, next) {
    const { id } = req.params;

    try {
      const pool = getPool();

      // 检查用户是否存在
      const [existing] = await pool.query(
        'SELECT id FROM users WHERE id = ? AND deleted_at IS NULL',
        [id]
      );

      if (existing.length === 0) {
        throw new AppError('用户不存在', 404, 'USER_NOT_FOUND');
      }

      // 软删除
      await pool.query(
        'UPDATE users SET deleted_at = NOW(), status = 0 WHERE id = ?',
        [id]
      );

      // 清除缓存
      await cache.del(`user:${id}`);

      logger.info(`User deleted: ID ${id}`);

      res.json({
        success: true,
        message: '用户删除成功',
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = UserController;
