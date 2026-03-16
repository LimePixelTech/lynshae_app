# LynShae 灵羲智能

灵羲智能设备控制应用

## 快速开始

### 1. 环境要求

- Docker & Docker Compose
- Node.js 18+ (本地开发)
- Flutter 3.0+ (移动应用开发)

### 2. 使用 Docker 启动（推荐）

```bash
# 复制环境变量配置
cp .env.example .env

# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 3. 服务访问

| 服务 | 端口 | 说明 |
|------|------|------|
| Backend API | 3005 | 后端 API 服务 |
| Web 管理后台 | 3006 | React 管理界面 |
| MySQL | 3306 | 数据库 |
| Redis | 6379 | 缓存服务 |

### 4. 默认账号

- **管理员**: admin@lynshae.com / admin123
- **测试用户**: test@lynshae.com / 123456

## 开发模式

### 后端开发

```bash
cd backend
npm install
npm run dev
```

### 移动应用开发

```bash
cd app
flutter pub get
flutter run
```

## 文档

- [后端 API 文档](backend/docs/API接口文档.md)
- [后端快速开始](backend/docs/快速开始.md)
- [MySQL 配置指南](backend/docs/MySQL配置指南.md)
- [部署指南](backend/docs/部署指南.md)
- [App 说明](app/docs/App说明.md)

## 技术栈

### 后端
- Node.js + Express
- MySQL 8.0
- Redis 7.0
- JWT 认证

### 移动应用
- Flutter 3.0
- Dart
- 蓝牙通信
- WiFi 配网
