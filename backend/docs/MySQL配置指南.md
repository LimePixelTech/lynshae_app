# 🔧 MySQL 配置指南

## ✅ 配置完成状态

**数据库密码已配置**: `Hrk20050321003x!`

**数据库信息**:
- 主机：`localhost:3306`
- 数据库：`lynshae_db`
- 用户：`root`
- 表数量：15 张核心表 + 3 个视图
- 初始化数据：角色 (3)、用户 (2)、商品分类 (4)

**测试连接**:
```bash
/opt/homebrew/opt/mysql@8.0/bin/mysql -u root -p'Hrk20050321003x!' -S /tmp/mysql.sock lynshae_db -e "SHOW TABLES;"
```

---

## 解决方案

### 方案一：使用内存模式（推荐用于开发）✅

**开发模式使用 `test-server-full.js`，完全不需要 MySQL！**

```bash
# 直接启动，使用内存模拟数据
./scripts/start-backend.sh -d

# 服务器会自动使用内存数据库，包含完整的测试数据
# - 3 个测试用户
# - 6 个商品
# - 4 个设备
# - 4 个分类
# - 3 个优惠券
```

**优点**:
- ✅ 无需配置 MySQL
- ✅ 启动速度快
- ✅ 数据可重置
- ✅ 适合前后端联调开发

**测试账号**:
- 管理员：`admin@lynshae.com` / `admin123`
- 用户：`test@lynshae.com` / `123456`

---

### 方案二：配置 Homebrew MySQL

如果需要连接真实数据库（生产模式），请配置 Homebrew MySQL：

#### 1. 停止所有 MySQL 服务

```bash
# 停止 Homebrew MySQL
/opt/homebrew/bin/brew services stop mysql@8.0

# 如果可能，也停止官方 MySQL（需要 sudo）
sudo /usr/local/mysql/support-files/mysql.server stop
```

#### 2. 重置 Homebrew MySQL 密码

```bash
# 以安全模式启动（跳过密码验证）
/opt/homebrew/opt/mysql@8.0/bin/mysqld_safe --skip-grant-tables --skip-networking &

# 等待几秒后，重置密码
/opt/homebrew/opt/mysql@8.0/bin/mysql -u root <<EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'LynShae@2026';
FLUSH PRIVILEGES;
EOF

# 停止安全模式
pkill mysqld

# 正常启动 MySQL
/opt/homebrew/bin/brew services start mysql@8.0
```

#### 3. 创建数据库

```bash
/opt/homebrew/opt/mysql@8.0/bin/mysql -u root -pLynShae@2026 <<EOF
CREATE DATABASE IF NOT EXISTS lynshae_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EOF
```

#### 4. 更新环境变量

编辑 `backend/.env`：

```bash
# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_NAME=lynshae_db
DB_USER=root
DB_PASSWORD=LynShae@2026
```

#### 5. 初始化数据库

```bash
cd backend
./scripts/init-db.sh
```

#### 6. 启动生产模式

```bash
./scripts/start-backend.sh -p
```

---

### 方案三：使用官方 MySQL

如果希望使用官方 MySQL (`/usr/local/mysql/`)：

#### 1. 获取或重置密码

```bash
# 尝试默认密码（如果有）
/opt/homebrew/opt/mysql@8.0/bin/mysql -u root -p

# 如果忘记密码，需要按照方案二的步骤重置
```

#### 2. 更新环境变量

编辑 `backend/.env`：

```bash
# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_NAME=lynshae_db
DB_USER=root
DB_PASSWORD=你的 MySQL 密码
```

---

## 快速检查

### 检查 MySQL 状态

```bash
# 检查服务状态
/opt/homebrew/bin/brew services list | grep mysql

# 检查端口占用
lsof -i :3306

# 检查 socket 文件
ls -la /tmp/mysql.sock*
```

### 测试连接

```bash
# 使用 Homebrew MySQL 客户端连接
/opt/homebrew/opt/mysql@8.0/bin/mysql -u root -p -S /tmp/mysql.sock

# 测试 SQL
SHOW DATABASES;
USE lynshae_db;
SHOW TABLES;
```

---

## 常见问题

### Q: 端口 3306 被占用
**A**: 系统中有多个 MySQL 实例。建议只使用 Homebrew MySQL：

```bash
# 停止官方 MySQL
sudo /usr/local/mysql/support-files/mysql.server stop

# 启动 Homebrew MySQL
/opt/homebrew/bin/brew services start mysql@8.0
```

### Q: 无法连接到 MySQL
**A**: 检查 socket 文件位置：

```bash
# 查看 socket 文件
ls -la /tmp/mysql.sock*

# 如果不存在，检查 MySQL 是否运行
/opt/homebrew/bin/brew services list | grep mysql
```

### Q: 忘记 root 密码
**A**: 按照方案二的步骤重置密码。

### Q: 开发时需要数据库怎么办？
**A**: 推荐使用内存模式（方案一），`test-server-full.js` 包含完整的模拟数据，适合 99% 的开发场景。

---

## 推荐配置

### 开发环境
```bash
# 使用内存模式，无需 MySQL
./scripts/start-backend.sh -d
```

### 生产环境
```bash
# 配置 Homebrew MySQL
# 设置 DB_PASSWORD=LynShae@2026
# 启动生产模式
./scripts/start-backend.sh -p
```

### 测试环境
```bash
# 使用测试服务器
./scripts/start-backend.sh -t
```

---

## 相关文档

- [快速开始](./backend/docs/QUICKSTART.md)
- [数据库初始化](./backend/docs/DATABASE_INIT.md)
- [部署指南](./backend/docs/DEPLOYMENT.md)
- [API 文档](./backend/docs/API.md)

---

**最后更新**: 2026-03-15
