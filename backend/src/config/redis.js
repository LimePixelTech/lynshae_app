/**
 * Redis 配置
 */

const Redis = require('ioredis');
const { logger } = require('../utils/logger');

const redis = new Redis({
  host: process.env.REDIS_HOST || 'localhost',
  port: process.env.REDIS_PORT || 6379,
  password: process.env.REDIS_PASSWORD || undefined,
  db: parseInt(process.env.REDIS_DB) || 0,
  retryStrategy: (times) => {
    const delay = Math.min(times * 50, 2000);
    return delay;
  }
});

// 连接事件
redis.on('connect', () => {
  logger.info('Redis 连接成功');
});

redis.on('error', (error) => {
  logger.error('Redis 错误', { error: error.message });
});

// 缓存操作封装
const cache = {
  // 设置缓存
  set: async (key, value, ttl = 3600) => {
    if (typeof value === 'object') {
      value = JSON.stringify(value);
    }
    await redis.setex(key, ttl, value);
  },

  // 获取缓存
  get: async (key, parse = true) => {
    const value = await redis.get(key);
    if (!value) return null;
    if (parse) {
      try {
        return JSON.parse(value);
      } catch {
        return value;
      }
    }
    return value;
  },

  // 删除缓存
  del: async (key) => {
    await redis.del(key);
  },

  // 删除匹配模式的缓存
  delPattern: async (pattern) => {
    const keys = await redis.keys(pattern);
    if (keys.length > 0) {
      await redis.del(...keys);
    }
  },

  // 自增
  incr: async (key) => {
    return await redis.incr(key);
  },

  // 检查键是否存在
  exists: async (key) => {
    return await redis.exists(key) === 1;
  }
};

// 缓存键前缀
const keys = {
  user: (id) => `user:${id}`,
  token: (token) => `user:token:${token}`,
  device: (sn) => `device:${sn}`,
  deviceOnline: (id) => `device:online:${id}`,
  product: (id) => `product:${id}`,
  productCategory: (id) => `product:category:${id}`,
  order: (no) => `order:${no}`,
  cart: (userId) => `cart:${userId}`,
  coupon: (code) => `coupon:${code}`,
  session: (userId) => `session:${userId}`
};

module.exports = {
  redis,
  cache,
  keys
};
