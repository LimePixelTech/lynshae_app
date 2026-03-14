/**
 * LynShae 后端应用配置
 */
require('dotenv').config();

module.exports = {
  // 应用配置
  app: {
    name: 'LynShae API',
    version: '1.0.0',
    env: process.env.NODE_ENV || 'development',
    port: parseInt(process.env.PORT, 10) || 3000,
    tz: process.env.TZ || 'Asia/Shanghai',
  },

  // MySQL 数据库配置
  database: {
    host: process.env.MYSQL_HOST || 'localhost',
    port: parseInt(process.env.MYSQL_PORT, 10) || 3306,
    database: process.env.MYSQL_DATABASE || 'lynshae_db',
    user: process.env.MYSQL_USER || 'lynshae_user',
    password: process.env.MYSQL_PASSWORD || '',
    connectionLimit: 20,
    queueLimit: 0,
    waitForConnections: true,
    timezone: '+08:00',
  },

  // Redis 缓存配置
  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT, 10) || 6379,
    password: process.env.REDIS_PASSWORD || '',
    db: 0,
    keyPrefix: 'lynshae:',
  },

  // JWT 认证配置
  jwt: {
    secret: process.env.JWT_SECRET || 'change-this-secret-in-production',
    expiresIn: process.env.JWT_EXPIRES_IN || '2h',
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
  },

  // 文件上传配置
  upload: {
    path: process.env.UPLOAD_PATH || './uploads',
    maxSize: parseInt(process.env.MAX_FILE_SIZE, 10) || 10 * 1024 * 1024, // 10MB
    allowedTypes: (process.env.ALLOWED_FILE_TYPES || 'image/jpeg,image/png,image/gif,image/webp').split(','),
  },

  // 安全配置
  security: {
    rateLimit: {
      windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS, 10) || 60000,
      maxRequests: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS, 10) || 100,
    },
    corsOrigins: (process.env.CORS_ORIGINS || 'http://localhost:8080').split(','),
    bcryptRounds: 12,
  },

  // 日志配置
  logging: {
    level: process.env.LOG_LEVEL || 'info',
    file: process.env.LOG_FILE || './logs/app.log',
  },

  // 缓存配置
  cache: {
    product: {
      ttl: 3600, // 1 小时
    },
    category: {
      ttl: 86400, // 24 小时
    },
    hotProducts: {
      ttl: 3600, // 1 小时
    },
    newProducts: {
      ttl: 3600, // 1 小时
    },
  },
};
