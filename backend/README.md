# LynShae Backend

灵羲智能 - 商品管理与设备控制后端 API 服务

## 端口

- **API 服务**: 3005

## 快速启动

### Docker 方式（推荐）

```bash
# 在项目根目录
docker-compose up -d backend
```

### 本地开发

```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 启动生产服务器
npm start
```

## 主要功能

- 🔐 用户认证（JWT）
- 🛍️ 商品管理（SPU/SKU）
- 📁 分类管理（多级）
- 🏷️ 品牌管理
- 🤖 设备管理
- 📸 图片上传
- 📊 数据统计

## API 端点

| 端点 | 说明 |
|------|------|
| `/api/v1/auth` | 认证相关 |
| `/api/v1/products` | 商品管理 |
| `/api/v1/categories` | 分类管理 |
| `/api/v1/brands` | 品牌管理 |
| `/api/v1/devices` | 设备管理 |
| `/api/v1/users` | 用户管理 |
| `/api/v1/upload` | 文件上传 |

## 环境变量

详见 [`.env.example`](../.env.example)

## 文档

- [API 接口文档](docs/API 接口文档.md)
- [快速开始](docs/快速开始.md)
- [开发指南](docs/开发指南.md)
- [MySQL 配置](docs/MySQL 配置指南.md)
- [部署指南](docs/部署指南.md)
- [数据库初始化](docs/数据库初始化.md)
- [项目结构](docs/项目结构.md)

## 测试

```bash
# 运行测试
npm test

# 测试覆盖率
npm run test:coverage
```

## Docker

```bash
# 构建镜像
docker build -t lynshae-backend .

# 运行容器
docker run -p 3005:3005 lynshae-backend
```
