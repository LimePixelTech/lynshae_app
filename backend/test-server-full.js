/**
 * LynShae Backend - 完整测试服务器（含模拟数据库）
 * 用于前后端通信测试，无需真实数据库
 */

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = 3005;

// JWT 配置
const JWT_SECRET = process.env.JWT_SECRET || 'lynshae-test-secret-2026';

// ============================================
// 模拟数据库数据
// ============================================
const mockDB = {
  users: [
    {
      id: 1,
      uuid: 'admin-uuid-001',
      username: 'admin',
      email: 'admin@lynshae.com',
      password_hash: bcrypt.hashSync('admin123', 10),
      nickname: '管理员',
      avatar: '/avatars/admin.png',
      role_id: 1,
      status: 1,
      email_verified: true,
      created_at: new Date().toISOString()
    },
    {
      id: 2,
      uuid: 'user-uuid-001',
      username: 'testuser',
      email: 'test@lynshae.com',
      password_hash: bcrypt.hashSync('123456', 10),
      nickname: '测试用户',
      avatar: '/avatars/default.png',
      role_id: 3,
      status: 1,
      email_verified: true,
      created_at: new Date().toISOString()
    },
    {
      id: 3,
      uuid: 'user-uuid-002',
      username: 'demo',
      email: 'demo@lynshae.com',
      password_hash: bcrypt.hashSync('123456', 10),
      nickname: '演示用户',
      avatar: '/avatars/demo.png',
      role_id: 3,
      status: 1,
      email_verified: true,
      created_at: new Date().toISOString()
    }
  ],
  roles: [
    { id: 1, name: '超级管理员', code: 'super_admin', level: 100, permissions: ['*'] },
    { id: 2, name: '管理员', code: 'admin', level: 90, permissions: ['product:*', 'order:*', 'user:view', 'device:*'] },
    { id: 3, name: '普通用户', code: 'user', level: 10, permissions: ['product:view', 'order:create', 'device:bind'] }
  ],
  categories: [
    { id: 1, parent_id: null, name: '机器狗', code: 'robot_dog', icon: '🤖', description: '智能机器狗系列产品', level: 1, sort_order: 1, is_active: true },
    { id: 2, parent_id: null, name: '配件', code: 'accessories', icon: '🔧', description: '机器狗配件和周边', level: 1, sort_order: 2, is_active: true },
    { id: 3, parent_id: null, name: '传感器', code: 'sensors', icon: '📡', description: '各类传感器模块', level: 1, sort_order: 3, is_active: true },
    { id: 4, parent_id: null, name: '摄像头', code: 'cameras', icon: '📷', description: '智能摄像头设备', level: 1, sort_order: 4, is_active: true }
  ],
  products: [
    {
      id: 1,
      spu: 'SPU-RD-001',
      name: '灵羲机器狗 Pro',
      category_id: 1,
      category_name: '机器狗',
      brand: 'LynShae',
      model: 'LS-Pro-X1',
      short_description: '高性能四足智能机器狗，专业级运动控制',
      description: '灵羲机器狗 Pro 采用先进的运动控制算法，支持多种运动模式，具备优秀的地形适应能力。配备高清摄像头和多种传感器，可用于教育、科研、安防等多种场景。',
      price: 9999.00,
      original_price: 12999.00,
      stock: 100,
      images: ['/products/robot-dog-pro-1.jpg', '/products/robot-dog-pro-2.jpg', '/products/robot-dog-pro-3.jpg'],
      specs: { '尺寸': '450x280x320mm', '重量': '3.5kg', '续航': '2 小时', '最大速度': '3m/s', '自由度': '12DOF' },
      is_new: true,
      is_hot: true,
      is_recommend: true,
      is_on_sale: true,
      sort_order: 1,
      view_count: 1250,
      sales_count: 89,
      created_at: new Date().toISOString()
    },
    {
      id: 2,
      spu: 'SPU-RD-002',
      name: '灵羲机器狗 Lite',
      category_id: 1,
      category_name: '机器狗',
      brand: 'LynShae',
      model: 'LS-Lite-S1',
      short_description: '入门级智能机器狗，适合教育和娱乐',
      description: '灵羲机器狗 Lite 是专为教育和娱乐设计的入门级产品。具备基础的运动能力和交互功能，价格亲民，适合学生和爱好者。',
      price: 4999.00,
      original_price: 5999.00,
      stock: 200,
      images: ['/products/robot-dog-lite-1.jpg', '/products/robot-dog-lite-2.jpg'],
      specs: { '尺寸': '350x220x250mm', '重量': '2.0kg', '续航': '1.5 小时', '最大速度': '2m/s', '自由度': '8DOF' },
      is_new: true,
      is_hot: false,
      is_recommend: true,
      is_on_sale: true,
      sort_order: 2,
      view_count: 890,
      sales_count: 156,
      created_at: new Date().toISOString()
    },
    {
      id: 3,
      spu: 'SPU-RD-003',
      name: '灵羲机器狗 Mini',
      category_id: 1,
      category_name: '机器狗',
      brand: 'LynShae',
      model: 'LS-Mini-C1',
      short_description: '迷你版机器狗，便携易携带',
      description: '灵羲机器狗 Mini 是最小巧的机器狗产品，可以轻松放入口袋。虽然体积小，但功能齐全，适合随身携带。',
      price: 2999.00,
      original_price: 3499.00,
      stock: 300,
      images: ['/products/robot-dog-mini-1.jpg'],
      specs: { '尺寸': '200x120x150mm', '重量': '0.8kg', '续航': '1 小时', '最大速度': '1.5m/s', '自由度': '6DOF' },
      is_new: false,
      is_hot: false,
      is_recommend: false,
      is_on_sale: true,
      sort_order: 3,
      view_count: 560,
      sales_count: 234,
      created_at: new Date().toISOString()
    },
    {
      id: 4,
      spu: 'SPU-AC-001',
      name: '机器狗专用电池',
      category_id: 2,
      category_name: '配件',
      brand: 'LynShae',
      model: 'LS-BAT-5000',
      short_description: '5000mAh 大容量锂电池',
      description: '专为灵羲机器狗设计的高容量锂电池，支持快速充电，续航时间更长。',
      price: 299.00,
      original_price: 399.00,
      stock: 500,
      images: ['/products/battery-1.jpg'],
      specs: { '容量': '5000mAh', '电压': '14.8V', '充电时间': '2 小时' },
      is_new: false,
      is_hot: false,
      is_recommend: false,
      is_on_sale: true,
      sort_order: 4,
      view_count: 320,
      sales_count: 445,
      created_at: new Date().toISOString()
    },
    {
      id: 5,
      spu: 'SPU-SN-001',
      name: '激光雷达传感器',
      category_id: 3,
      category_name: '传感器',
      brand: 'LynShae',
      model: 'LS-LiDAR-360',
      short_description: '360 度激光雷达',
      description: '高精度 360 度激光雷达，适用于 SLAM 建图和避障。',
      price: 1999.00,
      original_price: 2499.00,
      stock: 100,
      images: ['/products/lidar-1.jpg'],
      specs: { '扫描范围': '360°', '测距精度': '±2cm', '最大距离': '25m' },
      is_new: true,
      is_hot: false,
      is_recommend: true,
      is_on_sale: true,
      sort_order: 5,
      view_count: 180,
      sales_count: 67,
      created_at: new Date().toISOString()
    },
    {
      id: 6,
      spu: 'SPU-CM-001',
      name: '4K 运动相机',
      category_id: 4,
      category_name: '摄像头',
      brand: 'LynShae',
      model: 'LS-CAM-4K',
      short_description: '4K 超高清运动相机',
      description: '支持 4K 60fps 视频录制，配备防抖功能，适合机器狗第一视角拍摄。',
      price: 899.00,
      original_price: 1199.00,
      stock: 200,
      images: ['/products/camera-4k-1.jpg', '/products/camera-4k-2.jpg'],
      specs: { '分辨率': '4K 60fps', '防抖': '电子防抖', '存储': '支持 TF 卡' },
      is_new: true,
      is_hot: true,
      is_recommend: true,
      is_on_sale: true,
      sort_order: 6,
      view_count: 420,
      sales_count: 123,
      created_at: new Date().toISOString()
    }
  ],
  product_skus: [
    { id: 1, product_id: 1, sku_code: 'SKU-RD-PRO-BLK', specs: { color: '黑色', battery: '标准版' }, price: 9999.00, stock: 50, image: '/products/robot-dog-pro-black.jpg', is_active: true },
    { id: 2, product_id: 1, sku_code: 'SKU-RD-PRO-WHT', specs: { color: '白色', battery: '标准版' }, price: 9999.00, stock: 30, image: '/products/robot-dog-pro-white.jpg', is_active: true },
    { id: 3, product_id: 1, sku_code: 'SKU-RD-PRO-BLK-PLUS', specs: { color: '黑色', battery: '长续航版' }, price: 10999.00, stock: 20, image: '/products/robot-dog-pro-black-plus.jpg', is_active: true },
    { id: 4, product_id: 2, sku_code: 'SKU-RD-LITE-BLU', specs: { color: '蓝色', battery: '标准版' }, price: 4999.00, stock: 100, image: '/products/robot-dog-lite-blue.jpg', is_active: true },
    { id: 5, product_id: 2, sku_code: 'SKU-RD-LITE-PNK', specs: { color: '粉色', battery: '标准版' }, price: 4999.00, stock: 100, image: '/products/robot-dog-lite-pink.jpg', is_active: true },
    { id: 6, product_id: 3, sku_code: 'SKU-RD-MINI-GRN', specs: { color: '绿色' }, price: 2999.00, stock: 150, image: '/products/robot-dog-mini-green.jpg', is_active: true },
    { id: 7, product_id: 4, sku_code: 'SKU-BAT-STD', specs: { type: '标准版' }, price: 299.00, stock: 300, image: '/products/battery-std.jpg', is_active: true },
    { id: 8, product_id: 5, sku_code: 'SKU-LIDAR-STD', specs: { version: '标准版' }, price: 1999.00, stock: 50, image: '/products/lidar-std.jpg', is_active: true },
    { id: 9, product_id: 6, sku_code: 'SKU-CAM-4K-STD', specs: { storage: '无卡' }, price: 899.00, stock: 100, image: '/products/camera-4k-std.jpg', is_active: true }
  ],
  devices: [
    {
      id: 1,
      sn: 'LS-DOG-2026-001',
      device_type: 'robot_dog',
      model: 'LS-Pro-X1',
      name: '小黑',
      firmware_version: 'v1.2.0',
      hardware_version: 'v1.0',
      mac_address: 'AA:BB:CC:DD:EE:01',
      battery_level: 85,
      status: 1,
      online_at: new Date().toISOString(),
      owner_id: 2,
      activated_at: new Date().toISOString(),
      warranty_expires: '2027-03-14',
      created_at: new Date().toISOString()
    },
    {
      id: 2,
      sn: 'LS-DOG-2026-002',
      device_type: 'robot_dog',
      model: 'LS-Lite-S1',
      name: '小白',
      firmware_version: 'v1.1.5',
      hardware_version: 'v1.0',
      mac_address: 'AA:BB:CC:DD:EE:02',
      battery_level: 92,
      status: 1,
      online_at: new Date().toISOString(),
      owner_id: 3,
      activated_at: new Date().toISOString(),
      warranty_expires: '2027-03-14',
      created_at: new Date().toISOString()
    },
    {
      id: 3,
      sn: 'LS-CAM-2026-001',
      device_type: 'camera',
      model: 'LS-CAM-4K',
      name: '摄像头 01',
      firmware_version: 'v2.0.1',
      hardware_version: 'v1.0',
      mac_address: 'AA:BB:CC:DD:EE:03',
      battery_level: 100,
      status: 1,
      online_at: new Date().toISOString(),
      owner_id: 2,
      activated_at: new Date().toISOString(),
      warranty_expires: '2027-03-14',
      created_at: new Date().toISOString()
    },
    {
      id: 4,
      sn: 'LS-DOG-2026-003',
      device_type: 'robot_dog',
      model: 'LS-Mini-C1',
      name: '迷你狗',
      firmware_version: 'v1.0.8',
      hardware_version: 'v1.0',
      mac_address: 'AA:BB:CC:DD:EE:04',
      battery_level: 45,
      status: 0,
      online_at: null,
      owner_id: null,
      activated_at: null,
      warranty_expires: '2027-03-14',
      created_at: new Date().toISOString()
    }
  ],
  coupons: [
    { id: 1, code: 'NEWUSER2026', name: '新用户优惠券', type: 1, value: 100.00, min_amount: 500.00, total_count: 1000, used_count: 0, per_user_limit: 1, valid_from: new Date().toISOString(), valid_to: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(), status: 1 },
    { id: 2, code: 'SPRING2026', name: '春季促销', type: 2, value: 0.15, min_amount: 1000.00, total_count: 500, used_count: 0, per_user_limit: 1, valid_from: new Date().toISOString(), valid_to: new Date(Date.now() + 60 * 24 * 60 * 60 * 1000).toISOString(), status: 1 },
    { id: 3, code: 'VIP500', name: 'VIP 专享券', type: 1, value: 500.00, min_amount: 2000.00, total_count: 100, used_count: 0, per_user_limit: 1, valid_from: new Date().toISOString(), valid_to: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000).toISOString(), status: 1 }
  ]
};

// ============================================
// 中间件
// ============================================
app.use(cors());
app.use(express.json());

// 请求日志
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// JWT 验证中间件
const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ code: 'UNAUTHORIZED', message: '未提供认证令牌' });
  }
  
  const token = authHeader.split(' ')[1];
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ code: 'UNAUTHORIZED', message: '令牌无效或已过期' });
  }
};

// ============================================
// 健康检查
// ============================================
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0'
  });
});

// ============================================
// API 文档
// ============================================
app.get('/api/v1/docs', (req, res) => {
  res.json({
    name: 'LynShae API',
    version: '1.0.0',
    description: '灵羲智能设备控制后端系统',
    endpoints: {
      auth: {
        register: 'POST /api/v1/auth/register',
        login: 'POST /api/v1/auth/login',
        profile: 'GET /api/v1/auth/profile'
      },
      products: {
        list: 'GET /api/v1/products',
        detail: 'GET /api/v1/products/:id',
        categories: 'GET /api/v1/products/categories'
      },
      devices: {
        list: 'GET /api/v1/devices',
        detail: 'GET /api/v1/devices/:id',
        control: 'POST /api/v1/devices/:id/control'
      },
      orders: {
        list: 'GET /api/v1/orders',
        create: 'POST /api/v1/orders',
        detail: 'GET /api/v1/orders/:id'
      },
      coupons: {
        list: 'GET /api/v1/coupons'
      }
    },
    testAccounts: [
      { username: 'admin', email: 'admin@lynshae.com', password: 'admin123', role: '超级管理员' },
      { username: 'testuser', email: 'test@lynshae.com', password: '123456', role: '普通用户' }
    ]
  });
});

// ============================================
// 认证接口
// ============================================
app.post('/api/v1/auth/register', (req, res) => {
  const { username, email, password, nickname } = req.body;
  
  if (!username || !email || !password) {
    return res.status(400).json({ code: 'VALIDATION_ERROR', message: '缺少必填参数' });
  }
  
  // 检查用户是否已存在
  const existingUser = mockDB.users.find(u => u.email === email || u.username === username);
  if (existingUser) {
    return res.status(409).json({ code: 'USER_EXISTS', message: '用户已存在' });
  }
  
  // 创建新用户
  const newUser = {
    id: mockDB.users.length + 1,
    uuid: `user-uuid-${Date.now()}`,
    username,
    email,
    password_hash: bcrypt.hashSync(password, 10),
    nickname: nickname || username,
    avatar: '/avatars/default.png',
    role_id: 3,
    status: 1,
    email_verified: false,
    created_at: new Date().toISOString()
  };
  
  mockDB.users.push(newUser);
  
  res.status(201).json({
    code: 'SUCCESS',
    message: '注册成功',
    data: {
      id: newUser.id,
      username: newUser.username,
      email: newUser.email
    }
  });
});

app.post('/api/v1/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  if (!email || !password) {
    return res.status(400).json({ code: 'VALIDATION_ERROR', message: '缺少必填参数' });
  }
  
  // 查找用户
  const user = mockDB.users.find(u => u.email === email || u.username === email);
  if (!user) {
    return res.status(401).json({ code: 'INVALID_CREDENTIALS', message: '用户名或密码错误' });
  }
  
  // 验证密码
  if (!bcrypt.compareSync(password, user.password_hash)) {
    return res.status(401).json({ code: 'INVALID_CREDENTIALS', message: '用户名或密码错误' });
  }
  
  // 检查用户状态
  if (user.status !== 1) {
    return res.status(403).json({ code: 'USER_DISABLED', message: '账号已被禁用' });
  }
  
  // 生成 Token
  const accessToken = jwt.sign(
    { id: user.id, username: user.username, email: user.email, roleId: user.role_id },
    JWT_SECRET,
    { expiresIn: '7d' }
  );
  
  const refreshToken = jwt.sign(
    { id: user.id, type: 'refresh' },
    JWT_SECRET,
    { expiresIn: '30d' }
  );
  
  // 获取角色信息
  const role = mockDB.roles.find(r => r.id === user.role_id);
  
  res.json({
    code: 'SUCCESS',
    message: '登录成功',
    data: {
      user: {
        id: user.id,
        uuid: user.uuid,
        username: user.username,
        email: user.email,
        nickname: user.nickname,
        avatar: user.avatar,
        roleId: user.role_id,
        roleName: role?.name
      },
      tokens: {
        accessToken,
        refreshToken,
        expiresIn: '7d'
      }
    }
  });
});

app.get('/api/v1/auth/profile', authMiddleware, (req, res) => {
  const user = mockDB.users.find(u => u.id === req.user.id);
  if (!user) {
    return res.status(404).json({ code: 'NOT_FOUND', message: '用户不存在' });
  }
  
  const role = mockDB.roles.find(r => r.id === user.role_id);
  
  res.json({
    code: 'SUCCESS',
    data: {
      id: user.id,
      uuid: user.uuid,
      username: user.username,
      email: user.email,
      nickname: user.nickname,
      avatar: user.avatar,
      roleId: user.role_id,
      roleName: role?.name,
      rolePermissions: role?.permissions,
      emailVerified: user.email_verified,
      createdAt: user.created_at
    }
  });
});

// ============================================
// 商品接口
// ============================================
app.get('/api/v1/products', (req, res) => {
  const {
    page = 1,
    limit = 20,
    categoryId,
    keyword,
    isOnSale,
    isNew,
    isHot,
    sortBy = 'sort_order',
    order = 'ASC'
  } = req.query;
  
  let products = [...mockDB.products];
  
  // 筛选
  if (categoryId) {
    products = products.filter(p => p.category_id === parseInt(categoryId));
  }
  
  if (keyword) {
    const k = keyword.toLowerCase();
    products = products.filter(p => 
      p.name.toLowerCase().includes(k) || 
      p.short_description.toLowerCase().includes(k)
    );
  }
  
  if (isOnSale !== undefined) {
    products = products.filter(p => p.is_on_sale === (isOnSale === 'true'));
  }
  
  if (isNew === 'true') {
    products = products.filter(p => p.is_new);
  }
  
  if (isHot === 'true') {
    products = products.filter(p => p.is_hot);
  }
  
  // 排序
  products.sort((a, b) => {
    let aVal = a[sortBy];
    let bVal = b[sortBy];
    if (order === 'DESC') [aVal, bVal] = [bVal, aVal];
    if (typeof aVal === 'string') return aVal.localeCompare(bVal);
    return aVal - bVal;
  });
  
  // 分页
  const total = products.length;
  const start = (page - 1) * limit;
  const paginatedProducts = products.slice(start, start + parseInt(limit));
  
  res.json({
    code: 'SUCCESS',
    data: {
      products: paginatedProducts,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        totalPages: Math.ceil(total / limit)
      }
    }
  });
});

app.get('/api/v1/products/categories', (req, res) => {
  const categories = mockDB.categories.filter(c => c.is_active);
  
  // 构建树形结构
  const buildTree = (items, parentId = null) => {
    return items
      .filter(item => item.parent_id === parentId)
      .map(item => ({
        ...item,
        children: buildTree(items, item.id)
      }));
  };
  
  const tree = buildTree(categories);
  
  res.json({
    code: 'SUCCESS',
    data: tree
  });
});

app.get('/api/v1/products/:id', (req, res) => {
  const product = mockDB.products.find(p => p.id === parseInt(req.params.id));
  
  if (!product) {
    return res.status(404).json({ code: 'NOT_FOUND', message: '商品不存在' });
  }
  
  // 增加浏览次数
  product.view_count++;
  
  // 获取 SKU
  const skus = mockDB.product_skus.filter(s => s.product_id === product.id && s.is_active);
  
  res.json({
    code: 'SUCCESS',
    data: {
      ...product,
      skus
    }
  });
});

// ============================================
// 设备接口
// ============================================
app.get('/api/v1/devices', authMiddleware, (req, res) => {
  // 只显示用户拥有的设备
  const devices = mockDB.devices.filter(d => d.owner_id === req.user.id);
  
  res.json({
    code: 'SUCCESS',
    data: {
      devices,
      total: devices.length
    }
  });
});

app.get('/api/v1/devices/:id', authMiddleware, (req, res) => {
  const device = mockDB.devices.find(d => d.id === parseInt(req.params.id));
  
  if (!device) {
    return res.status(404).json({ code: 'NOT_FOUND', message: '设备不存在' });
  }
  
  // 检查权限
  if (device.owner_id !== req.user.id && req.user.roleId !== 1) {
    return res.status(403).json({ code: 'FORBIDDEN', message: '无权访问该设备' });
  }
  
  res.json({
    code: 'SUCCESS',
    data: device
  });
});

app.post('/api/v1/devices/:id/control', authMiddleware, (req, res) => {
  const device = mockDB.devices.find(d => d.id === parseInt(req.params.id));
  
  if (!device) {
    return res.status(404).json({ code: 'NOT_FOUND', message: '设备不存在' });
  }
  
  // 检查权限
  if (device.owner_id !== req.user.id && req.user.roleId !== 1) {
    return res.status(403).json({ code: 'FORBIDDEN', message: '无权控制该设备' });
  }
  
  const { action, params } = req.body;
  
  // 模拟设备控制
  console.log(`控制设备 ${device.name}: ${action}`, params);
  
  res.json({
    code: 'SUCCESS',
    message: '指令已发送',
    data: {
      deviceId: device.id,
      action,
      params,
      timestamp: new Date().toISOString()
    }
  });
});

// ============================================
// 优惠券接口
// ============================================
app.get('/api/v1/coupons', (req, res) => {
  const now = new Date();
  const coupons = mockDB.coupons.filter(c => 
    c.status === 1 &&
    new Date(c.valid_from) <= now &&
    new Date(c.valid_to) >= now
  );
  
  res.json({
    code: 'SUCCESS',
    data: {
      coupons,
      total: coupons.length
    }
  });
});

// ============================================
// 404 处理
// ============================================
app.use((req, res) => {
  res.status(404).json({
    code: 'NOT_FOUND',
    message: '接口不存在',
    path: req.path
  });
});

// ============================================
// 启动服务器
// ============================================
// 绑定到 0.0.0.0 以允许 Android 模拟器访问 (10.0.2.2)
app.listen(PORT, '0.0.0.0', () => {
  console.log('\n' + '='.repeat(60));
  console.log('🚀  LynShae Backend 测试服务器已启动!');
  console.log('='.repeat(60));
  console.log(`📍 地址：http://localhost:${PORT}`);
  console.log(`📖 文档：http://localhost:${PORT}/api/v1/docs`);
  console.log(`❤️  健康：http://localhost:${PORT}/health`);
  console.log('\n📦 测试数据:');
  console.log(`   👥 用户数：${mockDB.users.length}`);
  console.log(`   🛍️  商品数：${mockDB.products.length}`);
  console.log(`   🏷️  SKU 数：${mockDB.product_skus.length}`);
  console.log(`   🤖 设备数：${mockDB.devices.length}`);
  console.log(`   📁 分类数：${mockDB.categories.length}`);
  console.log(`   🎫 优惠券数：${mockDB.coupons.length}`);
  console.log('\n🔑 测试账号:');
  console.log('   管理员：admin@lynshae.com / admin123');
  console.log('   用户：test@lynshae.com / 123456');
  console.log('='.repeat(60) + '\n');
});
