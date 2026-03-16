/**
 * 数据验证中间件
 */
const { validationResult } = require('express-validator');
const { AppError } = require('./errorHandler');

function validate(req, res, next) {
  const errors = validationResult(req);
  
  if (!errors.isEmpty()) {
    const errorMessages = errors.array().map(err => ({
      field: err.path,
      message: err.msg,
    }));
    
    return next(new AppError(
      '数据验证失败',
      400,
      'VALIDATION_ERROR'
    ));
  }
  
  next();
}

module.exports = validate;
