/**
 * 配置索引
 */

const database = require('./database');
const redis = require('./redis');

module.exports = {
  database,
  redis,
  jwt: {
    secret: process.env.JWT_SECRET || 'default-secret-key',
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '30d',
  },
  security: {
    rateLimit: {
      windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 900000,
      maxRequests: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
    },
    bcryptRounds: parseInt(process.env.BCRYPT_ROUNDS) || 12,
  }
};
