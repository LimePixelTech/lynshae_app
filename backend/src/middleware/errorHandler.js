/**
 * 全局错误处理中间件
 */
const logger = require('../utils/logger');
const config = require('../config');

class AppError extends Error {
  constructor(message, statusCode = 500, code = 'INTERNAL_ERROR') {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

const errorHandler = (err, req, res, next) => {
  let statusCode = err.statusCode || 500;
  let message = err.message || 'Internal Server Error';
  let code = err.code || 'INTERNAL_ERROR';

  // 记录错误日志
  if (statusCode >= 500) {
    logger.error(`[${code}] ${message}`, {
      path: req.path,
      method: req.method,
      ip: req.ip,
      stack: err.stack,
    });
  } else {
    logger.warn(`[${code}] ${message}`, {
      path: req.path,
      method: req.method,
      ip: req.ip,
    });
  }

  // MySQL 错误处理
  if (err.code === 'ER_DUP_ENTRY') {
    statusCode = 409;
    message = '资源已存在';
    code = 'DUPLICATE_ENTRY';
  } else if (err.code === 'ER_NO_REFERENCED_ROW_2' || err.code === 'ER_ROW_IS_REFERENCED_2') {
    statusCode = 409;
    message = '资源存在关联，无法删除';
    code = 'FOREIGN_KEY_CONSTRAINT';
  } else if (err.code === 'ER_BAD_FIELD_ERROR' || err.code === 'ER_NO_SUCH_TABLE') {
    statusCode = 500;
    message = '数据库错误';
    code = 'DATABASE_ERROR';
  }

  // JWT 错误处理
  if (err.name === 'JsonWebTokenError') {
    statusCode = 401;
    message = '无效的认证令牌';
    code = 'INVALID_TOKEN';
  } else if (err.name === 'TokenExpiredError') {
    statusCode = 401;
    message = '认证令牌已过期';
    code = 'TOKEN_EXPIRED';
  }

  // Multer 错误处理
  if (err.code === 'LIMIT_FILE_SIZE') {
    statusCode = 400;
    message = '文件大小超过限制';
    code = 'FILE_TOO_LARGE';
  } else if (err.code === 'LIMIT_UNEXPECTED_FILE') {
    statusCode = 400;
    message = '意外的文件字段';
    code = 'UNEXPECTED_FILE';
  }

  // 响应
  res.status(statusCode).json({
    success: false,
    message,
    code,
    ...(config.app.env === 'development' && { stack: err.stack }),
  });
};

module.exports = errorHandler;
module.exports.AppError = AppError;
