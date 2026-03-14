/**
 * LynShae API 服务器入口
 */
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const path = require('path');
const fs = require('fs');

const config = require('./config');
const logger = require('./utils/logger');
const db = require('./config/database');
const redis = require('./config/redis');
const errorHandler = require('./middleware/errorHandler');
const rateLimiter = require('./middleware/rateLimiter');

// 导入路由
const authRoutes = require('./routes/auth.routes');
const productRoutes = require('./routes/product.routes');
const categoryRoutes = require('./routes/category.routes');
const brandRoutes = require('./routes/brand.routes');
const uploadRoutes = require('./routes/upload.routes');
const systemRoutes = require('./routes/system.routes');

// 创建 Express 应用
const app = express();

// 安全中间件
app.use(helmet({
  contentSecurityPolicy: false, // 开发环境禁用 CSP
}));

// CORS 配置
app.use(cors({
  origin: config.security.corsOrigins,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
}));

// 请求日志
app.use(morgan('combined', {
  stream: { write: (message) => logger.info(message.trim()) },
}));

// 请求体解析
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// 压缩响应
app.use(compression());

// 速率限制
app.use('/api', rateLimiter);

// 静态文件服务 (上传目录)
const uploadPath = path.join(__dirname, '../../uploads');
if (!fs.existsSync(uploadPath)) {
  fs.mkdirSync(uploadPath, { recursive: true });
}
app.use('/uploads', express.static(uploadPath));

// 健康检查端点
app.get('/health', async (req, res) => {
  try {
    const dbStatus = await db.testConnection();
    const redisStatus = await redis.testConnection();
    
    res.json({
      status: 'ok',
      timestamp: new Date().toISOString(),
      services: {
        database: dbStatus ? 'connected' : 'disconnected',
        redis: redisStatus ? 'connected' : 'disconnected',
      },
      version: config.app.version,
      environment: config.app.env,
    });
  } catch (error) {
    res.status(503).json({
      status: 'error',
      message: error.message,
    });
  }
});

// API 路由
app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/brands', brandRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/system', systemRoutes);

// 404 处理
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'API endpoint not found',
    path: req.path,
  });
});

// 全局错误处理
app.use(errorHandler);

// 启动服务器
async function startServer() {
  try {
    // 测试数据库连接
    await db.testConnection();
    
    // 测试 Redis 连接
    await redis.testConnection();
    
    // 启动 HTTP 服务器
    app.listen(config.app.port, () => {
      logger.info(`🚀 LynShae API Server running on port ${config.app.port}`);
      logger.info(`📝 Environment: ${config.app.env}`);
      logger.info(`🔗 Health check: http://localhost:${config.app.port}/health`);
    });
  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
}

// 优雅关闭
process.on('SIGTERM', async () => {
  logger.info('SIGTERM received, shutting down gracefully');
  await db.closePool();
  await redis.closeClient();
  process.exit(0);
});

process.on('SIGINT', async () => {
  logger.info('SIGINT received, shutting down gracefully');
  await db.closePool();
  await redis.closeClient();
  process.exit(0);
});

// 启动
startServer();

module.exports = app;
