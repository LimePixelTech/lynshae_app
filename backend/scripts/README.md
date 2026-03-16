# Scripts 脚本说明

本目录包含 LynShae Backend 项目的各种自动化脚本。

## 📜 可用脚本

### 1. start.sh - 一键启动脚本 ⭐

**用途**: 一键检查依赖、启动服务并运行服务器

**用法**:
```bash
# 开发模式（默认，使用 test-server-full.js 含模拟数据）
./scripts/start.sh

# 开发模式（简写）
./scripts/start.sh dev

# 生产模式
./scripts/start.sh prod

# 测试模式
./scripts/start.sh test
```

**功能**:
- ✅ 检查 Node.js、npm、MySQL、Redis 是否安装
- ✅ 自动启动 MySQL 和 Redis 服务（如果未运行）
- ✅ 检查并安装 npm 依赖
- ✅ 检查环境变量配置
- ✅ 根据模式启动相应的服务器

**示例输出**:
```
========================================
   LynShae Backend 一键启动脚本
========================================

📦 检查系统依赖...

✅ Node.js: v18.20.8
✅ npm: 10.8.2
✅ MySQL: mysql  Ver 8.0.45 for macos14.2 on arm64
✅ MySQL 服务：运行中
✅ Redis: redis-cli 8.4.0
✅ Redis 服务：运行中
✅ Redis 连接测试：成功

📦 检查 npm 依赖...
✅ node_modules 已存在

🔧 检查环境配置...
✅ .env 文件已存在

🚀 启动服务器...

运行模式：开发模式 (development)
API 地址：http://localhost:3005

[服务器启动日志...]
```

---

### 2. init-db.sh / init-db.js - 数据库初始化脚本

**用途**: 初始化 MySQL 数据库，创建表结构和初始数据

**用法**:
```bash
# Shell 版本
./scripts/init-db.sh

# Node.js 版本
node scripts/init-db.js
```

**功能**:
- 创建数据库 `lynshae_db`
- 执行 SQL 初始化脚本
- 导入测试数据

---

### 3. seed-data.sql - 测试数据脚本

**用途**: 单独导入测试数据到数据库

**用法**:
```bash
mysql -u root -p lynshae_db < scripts/seed-data.sql
```

---

### 4. deploy.sh / deploy.js - 部署脚本

**用途**: 一键部署到生产环境

**用法**:
```bash
# Shell 版本
./scripts/deploy.sh

# Node.js 版本
node scripts/deploy.js
```

**功能**:
- 构建项目
- 停止旧服务
- 启动新服务
- 健康检查

---

## 🔧 故障排查

### MySQL 连接失败
```bash
# 检查 MySQL 服务状态
brew services list

# 重启 MySQL 服务
brew services restart mysql@8.0

# 查看 MySQL 日志
brew logs mysql@8.0
```

### Redis 连接失败
```bash
# 检查 Redis 服务状态
brew services list

# 重启 Redis 服务
brew services restart redis

# 测试 Redis 连接
redis-cli ping
```

### npm 依赖问题
```bash
# 清理并重新安装
rm -rf node_modules package-lock.json
npm install
```

### 权限问题
```bash
# 给脚本添加执行权限
chmod +x scripts/*.sh
```

---

## 📝 注意事项

1. **首次运行**: 建议先运行 `./scripts/init-db.sh` 初始化数据库
2. **环境变量**: 确保 `.env` 文件已正确配置
3. **端口占用**: 如果 3005 端口被占用，请修改 `.env` 中的 `PORT` 值
4. **开发模式**: 默认使用 `test-server-full.js`，包含模拟数据，适合前后端联调
5. **生产模式**: 使用 `src/server.js`，连接真实数据库

---

## 🎯 快速开始

```bash
# 1. 初始化数据库（首次运行）
./scripts/init-db.sh

# 2. 一键启动服务器
./scripts/start.sh

# 3. 访问 API
# http://localhost:3005/api/v1
```
