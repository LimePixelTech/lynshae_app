# LynShae 商品管理系统后端

生产级商品管理 API 服务，基于 Node.js + Express + MySQL + Redis

## 📋 目录

- [架构设计](#架构设计)
- [快速开始](#快速开始)
- [数据库设计](#数据库设计)
- [API 文档](#api-文档)
- [安全配置](#安全配置)
- [部署指南](#部署指南)

## 🏗️ 架构设计

```
┌─────────────────────────────────────────────────────────────┐
│                      Docker Compose                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Node.js    │  │    MySQL     │  │    Redis     │       │
│  │   Express    │  │   8.0+       │  │   7.x        │       │
│  │   API Server │  │   Database   │  │   Cache      │       │
│  │   :3000      │  │   :3306      │  │   :6379      │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│                                                              │
│  ┌──────────────┐                                           │
│  │   Admin      │                                           │
│  │   Web UI     │                                           │
│  │   :8080      │                                           │
│  └──────────────┘                                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 快速开始

### 前置要求

- Docker & Docker Compose
- Node.js 18+ (本地开发)

### 一键启动

```bash
# 克隆项目
cd /Users/freakk/Project/lynshae_app/backend

# 复制环境变量
cp .env.example .env

# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 访问地址

| 服务 | 地址 | 说明 |
|------|------|------|
| API Server | http://localhost:3000 | 后端 API |
| Admin Web | http://localhost:8080 | 管理后台 |
| MySQL | localhost:3306 | 数据库 |
| Redis | localhost:6379 | 缓存 |
| phpMyAdmin | http://localhost:8081 | 数据库管理 |

## 📊 数据库设计

### ER 图

```
┌─────────────────┐       ┌─────────────────┐
│    categories   │       │     brands      │
├─────────────────┤       ├─────────────────┤
│ id (PK)         │       │ id (PK)         │
│ name            │       │ name            │
│ parent_id (FK)  │       │ logo            │
│ icon            │       │ description     │
│ sort_order      │       │ sort_order      │
│ status          │       │ status          │
└────────┬────────┘       └─────────────────┘
         │
         │ 1:N
         ▼
┌─────────────────┐       ┌─────────────────┐
│     products    │       │   product_imgs  │
├─────────────────┤       ├─────────────────┤
│ id (PK)         │◄──────│ id (PK)         │
│ name            │       │ product_id (FK) │
│ category_id (FK)│       │ url             │
│ brand_id (FK)   │       │ sort_order      │
│ sku             │       │ is_primary      │
│ price           │       └─────────────────┘
│ stock           │
│ description     │       ┌─────────────────┐
│ details         │       │  product_specs  │
│ status          │       ├─────────────────┤
│ created_at      │◄──────│ id (PK)         │
│ updated_at      │       │ product_id (FK) │
└─────────────────┘       │ spec_name       │
                          │ spec_value      │
                          └─────────────────┘
```

### 数据表详情

#### 1. 商品分类表 (categories)

```sql
CREATE TABLE categories (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '分类名称',
    parent_id INT UNSIGNED DEFAULT NULL COMMENT '父分类 ID',
    icon VARCHAR(255) DEFAULT NULL COMMENT '分类图标',
    level TINYINT UNSIGNED DEFAULT 1 COMMENT '分类层级',
    sort_order INT UNSIGNED DEFAULT 0 COMMENT '排序',
    status TINYINT UNSIGNED DEFAULT 1 COMMENT '状态：1=启用，0=禁用',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_parent_id (parent_id),
    INDEX idx_status (status),
    INDEX idx_sort (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类表';
```

#### 2. 商品表 (products)

```sql
CREATE TABLE products (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL COMMENT '商品名称',
    category_id INT UNSIGNED NOT NULL COMMENT '分类 ID',
    brand_id INT UNSIGNED DEFAULT NULL COMMENT '品牌 ID',
    sku VARCHAR(50) UNIQUE NOT NULL COMMENT '商品编码',
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '价格',
    original_price DECIMAL(10,2) DEFAULT NULL COMMENT '原价',
    stock INT UNSIGNED DEFAULT 0 COMMENT '库存',
    sales INT UNSIGNED DEFAULT 0 COMMENT '销量',
    description VARCHAR(500) DEFAULT NULL COMMENT '商品简介',
    details TEXT COMMENT '详细介绍',
    main_image VARCHAR(500) DEFAULT NULL COMMENT '主图',
    status TINYINT UNSIGNED DEFAULT 1 COMMENT '状态：1=上架，0=下架',
    is_recommend TINYINT UNSIGNED DEFAULT 0 COMMENT '是否推荐',
    is_hot TINYINT UNSIGNED DEFAULT 0 COMMENT '是否热销',
    is_new TINYINT UNSIGNED DEFAULT 0 COMMENT '是否新品',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '软删除时间',
    INDEX idx_category_id (category_id),
    INDEX idx_brand_id (brand_id),
    INDEX idx_status (status),
    INDEX idx_sku (sku),
    INDEX idx_price (price),
    INDEX idx_created (created_at),
    FULLTEXT INDEX ft_name_description (name, description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品表';
```

#### 3. 商品图片表 (product_images)

```sql
CREATE TABLE product_images (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id INT UNSIGNED NOT NULL COMMENT '商品 ID',
    url VARCHAR(500) NOT NULL COMMENT '图片 URL',
    sort_order INT UNSIGNED DEFAULT 0 COMMENT '排序',
    is_primary TINYINT UNSIGNED DEFAULT 0 COMMENT '是否主图',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_product_id (product_id),
    INDEX idx_primary (is_primary),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品图片表';
```

#### 4. 商品规格表 (product_specs)

```sql
CREATE TABLE product_specs (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id INT UNSIGNED NOT NULL COMMENT '商品 ID',
    spec_name VARCHAR(50) NOT NULL COMMENT '规格名称',
    spec_value VARCHAR(200) NOT NULL COMMENT '规格值',
    sort_order INT UNSIGNED DEFAULT 0 COMMENT '排序',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_product_id (product_id),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品规格表';
```

#### 5. 管理员表 (admins)

```sql
CREATE TABLE admins (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码 (bcrypt)',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT '邮箱',
    avatar VARCHAR(255) DEFAULT NULL COMMENT '头像',
    role TINYINT UNSIGNED DEFAULT 1 COMMENT '角色：1=超级管理员，2=普通管理员',
    status TINYINT UNSIGNED DEFAULT 1 COMMENT '状态：1=启用，0=禁用',
    last_login_at TIMESTAMP NULL DEFAULT NULL COMMENT '最后登录时间',
    last_login_ip VARCHAR(45) DEFAULT NULL COMMENT '最后登录 IP',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员表';
```

#### 6. 操作日志表 (operation_logs)

```sql
CREATE TABLE operation_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    admin_id INT UNSIGNED DEFAULT NULL COMMENT '管理员 ID',
    action VARCHAR(100) NOT NULL COMMENT '操作类型',
    module VARCHAR(50) DEFAULT NULL COMMENT '模块',
    request_method VARCHAR(10) DEFAULT NULL COMMENT '请求方法',
    request_url VARCHAR(500) DEFAULT NULL COMMENT '请求 URL',
    request_params TEXT COMMENT '请求参数',
    response_code INT UNSIGNED DEFAULT NULL COMMENT '响应码',
    ip_address VARCHAR(45) DEFAULT NULL COMMENT 'IP 地址',
    user_agent VARCHAR(500) DEFAULT NULL COMMENT 'User-Agent',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_admin_id (admin_id),
    INDEX idx_action (action),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';
```

## 🔐 安全配置

### 环境变量

```bash
# 复制并配置
cp .env.example .env
```

### JWT 认证

- Access Token: 2 小时有效期
- Refresh Token: 7 天有效期
- 支持 Token 黑名单 (Redis)

### 密码安全

- bcrypt 加密 (cost=12)
- 最小长度 8 位
- 必须包含字母和数字

### API 安全

- 速率限制：100 请求/分钟/IP
- CORS 白名单
- SQL 注入防护
- XSS 防护

## 📈 性能优化

### Redis 缓存策略

| 缓存键 | 过期时间 | 说明 |
|--------|----------|------|
| product:{id} | 1 小时 | 商品详情 |
| category:list | 24 小时 | 分类列表 |
| product:hot | 1 小时 | 热销商品 |
| product:new | 1 小时 | 新品推荐 |
| token:blacklist:{jti} | 2 小时 | Token 黑名单 |

### 数据库优化

- 所有查询字段建立索引
- 使用连接池 (max: 20)
- 慢查询日志 (>1s)
- 定期分析表

## 📚 API 文档

详细 API 文档请访问：[API Documentation](./docs/API.md)

### 主要接口

| 方法 | 路径 | 说明 | 认证 |
|------|------|------|------|
| POST | /api/auth/login | 管理员登录 | ❌ |
| POST | /api/auth/refresh | 刷新 Token | ✅ |
| GET | /api/products | 获取商品列表 | ✅ |
| POST | /api/products | 创建商品 | ✅ |
| GET | /api/products/:id | 获取商品详情 | ✅ |
| PUT | /api/products/:id | 更新商品 | ✅ |
| DELETE | /api/products/:id | 删除商品 | ✅ |
| GET | /api/categories | 获取分类列表 | ✅ |
| POST | /api/categories | 创建分类 | ✅ |

## 🛠️ 开发指南

### 项目结构

```
backend/
├── src/
│   ├── config/          # 配置文件
│   ├── controllers/     # 控制器
│   ├── middleware/      # 中间件
│   ├── models/          # 数据模型
│   ├── routes/          # 路由
│   ├── services/        # 业务逻辑
│   ├── utils/           # 工具函数
│   └── validators/      # 数据验证
├── tests/               # 测试文件
├── docs/                # 文档
├── scripts/             # 脚本
├── docker/              # Docker 配置
├── .env.example         # 环境变量示例
├── docker-compose.yml   # Docker Compose
└── package.json
```

### 本地开发

```bash
# 安装依赖
npm install

# 启动开发服务
npm run dev

# 运行测试
npm test

# 代码检查
npm run lint
```

## 📦 部署

### 生产环境

```bash
# 构建并启动
docker-compose -f docker-compose.prod.yml up -d --build

# 查看日志
docker-compose logs -f app

# 健康检查
curl http://localhost:3000/health
```

### 备份策略

```bash
# 数据库备份
./scripts/backup-db.sh

# Redis 备份
./scripts/backup-redis.sh
```

## 📞 技术支持

如有问题，请提交 Issue 或联系开发团队。
