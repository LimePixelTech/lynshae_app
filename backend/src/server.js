/**
 * LynShae Backend Server
 * 灵羲智能 - 商品管理与设备控制后端系统
 * 
 * @version 2.0.0
 */

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const path = require('path');

const { logger } = require('./utils/logger');
const { errorHandler } = require('./middleware/errorHandler');
const authRoutes = require('./routes/auth.routes');
const productRoutes = require('./routes/product.routes');
const categoryRoutes = require('./routes/category.routes');
const brandRoutes = require('./routes/brand.routes');
const deviceRoutes = require('./routes/device');
const userRoutes = require('./routes/user');
const uploadRoutes = require('./routes/upload.routes');

const app = express();
const PORT = process.env.PORT || 3005;

// ============================================
// 中间件配置
// ============================================

// 安全头
app.use(helmet());

// CORS 配置
const corsOptions = {
  origin: process.env.CORS_ORIGIN?.split(',') || '*',
  credentials: process.env.CORS_CREDENTIALS === 'true',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
};
app.use(cors(corsOptions));

// 请求日志
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.path}`, {
    ip: req.ip,
    userAgent: req.get('user-agent')
  });
  next();
});

// 解析 JSON
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// 静态文件
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// 速率限制
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000,
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  message: { code: 'TOO_MANY_REQUESTS', message: '请求过于频繁，请稍后再试' }
});
app.use('/api/', limiter);

// ============================================
// 健康检查
// ============================================
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV
  });
});

// ============================================
// API 路由
// ============================================
const API_PREFIX = process.env.API_PREFIX || '/api/v1';

app.use(`${API_PREFIX}/auth`, authRoutes);
app.use(`${API_PREFIX}/products`, productRoutes);
app.use(`${API_PREFIX}/categories`, categoryRoutes);
app.use(`${API_PREFIX}/brands`, brandRoutes);
app.use(`${API_PREFIX}/devices`, deviceRoutes);
app.use(`${API_PREFIX}/users`, userRoutes);
app.use(`${API_PREFIX}/upload`, uploadRoutes);

// API 文档路由
app.use(`${API_PREFIX}/docs`, (req, res) => {
  res.json({
    name: 'LynShae API',
    version: '2.0.0',
    description: '灵羲智能商品管理系统 API',
    endpoints: {
      auth: `${API_PREFIX}/auth`,
      products: `${API_PREFIX}/products`,
      categories: `${API_PREFIX}/categories`,
      brands: `${API_PREFIX}/brands`,
      devices: `${API_PREFIX}/devices`,
      users: `${API_PREFIX}/users`,
      upload: `${API_PREFIX}/upload`
    },
    adminEndpoints: {
      products: `${API_PREFIX}/products/admin`,
      categories: `${API_PREFIX}/categories/admin`,
      brands: `${API_PREFIX}/brands/admin`
    },
    publicEndpoints: {
      products: `${API_PREFIX}/products`,
      categories: `${API_PREFIX}/categories`,
      brands: `${API_PREFIX}/brands`
    }
  });
});

// 404 处理
app.use((req, res) => {
  res.status(404).json({
    code: 'NOT_FOUND',
    message: '接口不存在'
  });
});

// 错误处理
app.use(errorHandler);

// ============================================
// 启动服务器
// ============================================
const server = app.listen(PORT, () => {
  logger.info(`服务器启动成功`, {
    port: PORT,
    environment: process.env.NODE_ENV,
    prefix: API_PREFIX
  });
});

// 优雅关闭
process.on('SIGTERM', () => {
  logger.info('收到 SIGTERM 信号，正在关闭服务器...');
  server.close(() => {
    logger.info('服务器已关闭');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  logger.info('收到 SIGINT 信号，正在关闭服务器...');
  server.close(() => {
    logger.info('服务器已关闭');
    process.exit(0);
  });
});

module.exports = app;
