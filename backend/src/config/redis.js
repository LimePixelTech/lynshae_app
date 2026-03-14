/**
 * Redis 缓存客户端配置
 */
const Redis = require('ioredis');
const config = require('./index');
const logger = require('../utils/logger');

let redisClient = null;

/**
 * 创建 Redis 客户端
 */
function createClient() {
  redisClient = new Redis({
    host: config.redis.host,
    port: config.redis.port,
    password: config.redis.password || undefined,
    db: config.redis.db,
    keyPrefix: config.redis.keyPrefix,
    retryStrategy: (times) => {
      if (times > 10) {
        logger.error('Redis connection failed after multiple retries');
        return null;
      }
      const delay = Math.min(times * 200, 3000);
      logger.warn(`Redis reconnect attempt ${times}, delay: ${delay}ms`);
      return delay;
    },
  });

  redisClient.on('connect', () => {
    logger.info('✅ Redis connected');
  });

  redisClient.on('error', (error) => {
    logger.error('❌ Redis error:', error.message);
  });

  redisClient.on('close', () => {
    logger.warn('Redis connection closed');
  });

  return redisClient;
}

/**
 * 获取 Redis 客户端
 */
function getClient() {
  if (!redisClient) {
    return createClient();
  }
  return redisClient;
}

/**
 * 测试 Redis 连接
 */
async function testConnection() {
  try {
    const client = getClient();
    await client.ping();
    logger.info('Redis connection test successful');
    return true;
  } catch (error) {
    logger.error('Redis connection test failed:', error.message);
    return false;
  }
}

/**
 * 关闭 Redis 连接
 */
async function closeClient() {
  if (redisClient) {
    await redisClient.quit();
    redisClient = null;
    logger.info('Redis connection closed');
  }
}

/**
 * 缓存辅助函数
 */
const cache = {
  /**
   * 设置缓存
   */
  async set(key, value, ttl = null) {
    try {
      const client = getClient();
      const serialized = JSON.stringify(value);
      if (ttl) {
        await client.setex(key, ttl, serialized);
      } else {
        await client.set(key, serialized);
      }
      return true;
    } catch (error) {
      logger.error('Redis set error:', error.message);
      return false;
    }
  },

  /**
   * 获取缓存
   */
  async get(key) {
    try {
      const client = getClient();
      const data = await client.get(key);
      return data ? JSON.parse(data) : null;
    } catch (error) {
      logger.error('Redis get error:', error.message);
      return null;
    }
  },

  /**
   * 删除缓存
   */
  async del(key) {
    try {
      const client = getClient();
      await client.del(key);
      return true;
    } catch (error) {
      logger.error('Redis del error:', error.message);
      return false;
    }
  },

  /**
   * 删除匹配模式的缓存
   */
  async delPattern(pattern) {
    try {
      const client = getClient();
      const keys = await client.keys(pattern);
      if (keys.length > 0) {
        await client.del(...keys);
      }
      return true;
    } catch (error) {
      logger.error('Redis delPattern error:', error.message);
      return false;
    }
  },
};

module.exports = {
  getClient,
  testConnection,
  closeClient,
  cache,
};
