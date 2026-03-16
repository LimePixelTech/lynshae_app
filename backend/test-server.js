/**
 * LynShae Backend - 简化测试服务器
 */

require('dotenv').config();
const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 8888;

app.use(cors());
app.use(express.json());

// 健康检查
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV
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
      products: '/api/v1/products'
    }
  });
});

// 用户注册
app.post('/api/v1/auth/register', (req, res) => {
  const { username, email, password } = req.body;
  if (!username || !email || !password) {
    return res.status(400).json({ code: 'VALIDATION_ERROR', message: '缺少必填参数' });
  }
  res.status(201).json({ code: 'SUCCESS', message: '注册成功', data: { username, email } });
});

// 用户登录
app.post('/api/v1/auth/login', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ code: 'VALIDATION_ERROR', message: '缺少必填参数' });
  }
  res.json({
    code: 'SUCCESS',
    message: '登录成功',
    data: {
      user: { id: 1, uuid: 'test-uuid-001', username: 'testuser', email, roleId: 3 },
      tokens: { accessToken: 'mock-token-xyz', refreshToken: 'mock-refresh-abc', expiresIn: '7d' }
    }
  });
});

// 商品列表
app.get('/api/v1/products', (req, res) => {
  const products = [
    { id: 1, spu: 'SPU001', name: '机器狗 Pro', price: 9999, stock: 100, is_on_sale: true },
    { id: 2, spu: 'SPU002', name: '机器狗 Lite', price: 4999, stock: 200, is_on_sale: true },
    { id: 3, spu: 'SPU003', name: '智能摄像头', price: 299, stock: 500, is_on_sale: true }
  ];
  res.json({ code: 'SUCCESS', data: { products, pagination: { total: 3, page: 1, limit: 20 } } });
});

// 商品详情
app.get('/api/v1/products/:id', (req, res) => {
  res.json({
    code: 'SUCCESS',
    data: {
      id: parseInt(req.params.id),
      name: '机器狗 Pro',
      price: 9999,
      description: '高性能智能机器狗',
      skus: [
        { id: 1, sku_code: 'SKU001', specs: { color: 'black' }, price: 9999, stock: 50 }
      ]
    }
  });
});

app.use((req, res) => {
  res.status(404).json({ code: 'NOT_FOUND', message: '接口不存在' });
});

app.listen(PORT, () => {
  console.log(`\n✅ LynShae Backend 测试服务器已启动!`);
  console.log(`📍 地址：http://localhost:${PORT}`);
  console.log(`📖 文档：http://localhost:${PORT}/api/v1/docs`);
  console.log(`❤️  健康：http://localhost:${PORT}/health\n`);
});
