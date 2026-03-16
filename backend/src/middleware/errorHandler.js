/**
 * 错误处理中间件
 */

const { logger } = require('../utils/logger');

// 自定义应用错误
class AppError extends Error {
  constructor(message, statusCode, code) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

// 错误处理中间件
const errorHandler = (err, req, res, next) => {
  let statusCode = err.statusCode || 500;
  let message = err.message || '服务器内部错误';
  let code = err.code || 'INTERNAL_ERROR';

  // 记录错误日志
  logger.error('请求处理错误', {
    path: req.path,
    method: req.method,
    error: err.message,
    stack: err.stack
  });

  // MySQL 错误处理
  if (err.code === 'ER_DUP_ENTRY') {
    statusCode = 400;
    message = '数据已存在';
    code = 'DUPLICATE_ENTRY';
  }

  if (err.code === 'ER_NO_REFERENCED_ROW_2' || err.code === 'ER_ROW_IS_REFERENCED_2') {
    statusCode = 400;
    message = '数据存在关联，无法删除';
    code = 'FOREIGN_KEY_CONSTRAINT';
  }

  // JWT 错误
  if (err.name === 'JsonWebTokenError') {
    statusCode = 401;
    message = '无效的认证令牌';
    code = 'INVALID_TOKEN';
  }

  if (err.name === 'TokenExpiredError') {
    statusCode = 401;
    message = '认证令牌已过期';
    code = 'TOKEN_EXPIRED';
  }

  // Multer 错误
  if (err.name === 'MulterError') {
    statusCode = 400;
    if (err.code === 'LIMIT_FILE_SIZE') {
      message = '文件大小超出限制';
      code = 'FILE_TOO_LARGE';
    } else if (err.code === 'LIMIT_FILE_COUNT') {
      message = '文件数量超出限制';
      code = 'TOO_MANY_FILES';
    }
  }

  // 验证错误
  if (err.name === 'ValidationError') {
    statusCode = 400;
    code = 'VALIDATION_ERROR';
  }

  // 返回错误响应
  res.status(statusCode).json({
    code,
    message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
};

// 404 处理
const notFoundHandler = (req, res) => {
  res.status(404).json({
    code: 'NOT_FOUND',
    message: '请求的资源不存在'
  });
};

module.exports = {
  AppError,
  errorHandler,
  notFoundHandler
};
