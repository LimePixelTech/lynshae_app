/**
 * MySQL 数据库连接池配置
 */
const mysql = require('mysql2/promise');
const config = require('./index');
const logger = require('../utils/logger');

let pool = null;

/**
 * 创建数据库连接池
 */
function createPool() {
  pool = mysql.createPool({
    host: config.database.host,
    port: config.database.port,
    database: config.database.database,
    user: config.database.user,
    password: config.database.password,
    connectionLimit: config.database.connectionLimit,
    queueLimit: config.database.queueLimit,
    waitForConnections: config.database.waitForConnections,
    timezone: config.database.timezone,
    charset: 'utf8mb4',
    enableKeepAlive: true,
    keepAliveInitialDelay: 0,
  });

  // 监听连接池事件
  pool.on('connection', (connection) => {
    logger.debug('New database connection established');
  });

  pool.on('acquire', (connection) => {
    logger.debug('Connection acquired from pool');
  });

  pool.on('release', (connection) => {
    logger.debug('Connection released back to pool');
  });

  return pool;
}

/**
 * 获取数据库连接池
 */
function getPool() {
  if (!pool) {
    return createPool();
  }
  return pool;
}

/**
 * 测试数据库连接
 */
async function testConnection() {
  try {
    const connection = await getPool().getConnection();
    await connection.ping();
    connection.release();
    logger.info('✅ Database connection successful');
    return true;
  } catch (error) {
    logger.error('❌ Database connection failed:', error.message);
    return false;
  }
}

/**
 * 关闭数据库连接池
 */
async function closePool() {
  if (pool) {
    await pool.end();
    pool = null;
    logger.info('Database connection pool closed');
  }
}

module.exports = {
  getPool,
  testConnection,
  closePool,
};
