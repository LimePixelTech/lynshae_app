/**
 * LynShae Backend Test Server
 * 简化版测试服务器（不依赖 MySQL）
 */

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { logger } = require('../src/utils/logger');

const app = express();
const PORT = process.env.PORT || 3000;

// 中间件
app.use(cors());
app.use(express.json());

// 健康检查
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV,
    services: {
      redis: 'connected',
      mysql: 'mock-mode'
    }
  });
});

// API 文档
app.get('/api/v1/docs', (req, res) => {
  res.json({
    name: 'LynShae API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      auth: '/api/v1/auth',
      products: '/api/v1/products',
      devices: '/api/v1/devices',
      orders: '/api/v1/orders'
    }
  });
});

// 模拟认证接口
app.post('/api/v1/auth/register', (req, res) => {
  const { username, email, password } = req.body;
  
  if (!username || !email || !password) {
    return res.status(400).json({
      code: 'VALIDATION_ERROR',
      message: '缺少必填参数'
    });
  }
  
  res.status(201).json({
    code: 'SUCCESS',
    message: '注册成功（模拟）',
    data: { username, email }
  });
});

app.post('/api/v1/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  if (!email || !password) {
    return res.status(400).json({
      code: 'VALIDATION_ERROR',
      message: '缺少必填参数'
    });
  }
  
  // 模拟登录成功
  res.json({
    code: 'SUCCESS',
    message: '登录成功（模拟）',
    data: {
      user: {
        id: 1,
        uuid: 'test-uuid-001',
        username: 'testuser',
        email: email,
        roleId: 3
      },
      tokens: {
        accessToken: 'mock-access-token-xyz123',
        refreshToken: 'mock-refresh-token-abc456',
        expiresIn: '7d'
      }
    }
  });
});

// 模拟商品接口
app.get('/api/v1/products', (req, res) => {
  const { page = 1, limit = 20 } = req.query;
  
  // 模拟商品数据
  const mockProducts = [
    {
      id: 1,
      spu: 'SPU202603140001',
      name: '机器狗 Pro',
      price: 9999.00,
      original_price: 12999.00,
      stock: 100,
      images: ['/uploads/dog-pro-1.jpg', '/uploads/dog-pro-2.jpg'],
      category_name: '机器狗',
      is_on_sale: true,
      is_new: true,
      sales_count: 520,
      short_description: '高性能智能机器狗'
    },
    {
      id: 2,
      spu: 'SPU202603140002',
      name: '机器狗 Lite',
      price: 4999.00,
      original_price: 5999.00,
      stock: 200,
      images: ['/uploads/dog-lite-1.jpg'],
      category_name: '机器狗',
      is_on_sale: true,
      is_new: false,
      sales_count: 1280,
      short_description: '入门级智能机器狗'
    },
    {
      id: 3,
      spu: 'SPU202603140003',
      name: '智能摄像头',
      price: 299.00,
      original_price: 399.00,
      stock: 500,
      images: ['/uploads/camera-1.jpg'],
      category_name: '配件',
      is_on_sale: true,
      is_new: true,
      sales_count: 3500,
      short_description: '高清智能监控摄像头'
    }
  ];
  
  res.json({
    code: 'SUCCESS',
    data: {
      products: mockProducts.slice(0, parseInt(limit)),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: mockProducts.length,
        totalPages: Math.ceil(mockProducts.length / parseInt(limit))
      }
    }
  });
});

app.get('/api/v1/products/:id', (req, res) => {
  const { id } = req.params;
  
  // 模拟商品详情
  const mockProduct = {
    id: parseInt(id),
    spu: `SPU20260314000${id}`,
    name: `机器狗 ${id === '1' ? 'Pro' : 'Lite'}`,
    description: '详细描述...',
    content: '<p>商品详情 HTML 内容</p>',
    price: id === '1' ? 9999.00 : 4999.00,
    stock: 100,
    images: ['/uploads/product-1.jpg', '/uploads/product-2.jpg'],
    specs: { color: 'black', size: 'standard', weight: '5kg' },
    is_on_sale: true,
    is_new: true,
    sales_count: 520,
    view_count: 1234,
    skus: [
      {
        id: 1,
        sku_code: 'SKU001',
        specs: { color: 'black' },
        price: 9999.00,
        stock: 50
      },
      {
        id: 2,
        sku_code: 'SKU002',
        specs: { color: 'white' },
        price: 9999.00,
        stock: 50
      }
    ]
  };
  
  res.json({
    code: 'SUCCESS',
    data: mockProduct
  });
});

// 404 处理
app.use((req, res) => {
  res.status(404).json({
    code: 'NOT_FOUND',
    message: '接口不存在'
  });
});

// 启动服务器
const server = app.listen(PORT, () => {
  logger.info(`测试服务器启动成功`, {
    port: PORT,
    environment: process.env.NODE_ENV,
    mode: 'mock'
  });
  
  console.log(`
✅ LynShae Backend 测试服务器已启动！

📍 服务地址：http://localhost:${PORT}
📖 API 文档：http://localhost:${PORT}/api/v1/docs
❤️ 健康检查：http://localhost:${PORT}/health

🧪 测试接口:
  - POST /api/v1/auth/register (用户注册)
  - POST /api/v1/auth/login (用户登录)
  - GET  /api/v1/products (商品列表)
  - GET  /api/v1/products/:id (商品详情)
  `);
});

process.on('SIGINT', () => {
  server.close(() => {
    logger.info('测试服务器已关闭');
    process.exit(0);
  });
});

module.exports = app;
