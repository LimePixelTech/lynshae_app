#!/bin/bash
# LynShae 数据库初始化脚本

MYSQL_USER="root"
MYSQL_PASSWORD="Hrk20050321003x!"
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"
DB_NAME="lynshae_db"

# 查找 MySQL 客户端
if command -v /opt/homebrew/opt/mysql@8.0/bin/mysql &> /dev/null; then
    MYSQL_CMD="/opt/homebrew/opt/mysql@8.0/bin/mysql"
elif command -v /usr/local/mysql/bin/mysql &> /dev/null; then
    MYSQL_CMD="/usr/local/mysql/bin/mysql"
elif command -v mysql &> /dev/null; then
    MYSQL_CMD="mysql"
else
    echo "❌ 未找到 MySQL 客户端"
    exit 1
fi

echo "🔧 使用 MySQL 客户端：$MYSQL_CMD"

# 使用配置的密码连接
echo "🔑 连接 MySQL..."
if [ -z "$MYSQL_PASSWORD" ]; then
    $MYSQL_CMD -u $MYSQL_USER -h $MYSQL_HOST -P $MYSQL_PORT -e "SELECT 1;" &> /dev/null
else
    $MYSQL_CMD -u $MYSQL_USER -h $MYSQL_HOST -P $MYSQL_PORT -p"$MYSQL_PASSWORD" -e "SELECT 1;" &> /dev/null
fi

if [ $? -eq 0 ]; then
    echo "✅ MySQL 连接成功!"
    MYSQL_PASS="$MYSQL_PASSWORD"
else
    echo "❌ 无法连接到 MySQL，请检查配置"
    exit 1
fi

# 创建数据库
echo "📦 创建数据库 $DB_NAME..."
if [ -z "$MYSQL_PASS" ]; then
    $MYSQL_CMD -u $MYSQL_USER -h $MYSQL_HOST -P $MYSQL_PORT -e "CREATE DATABASE IF NOT EXISTS $DB_NAME DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;"
else
    $MYSQL_CMD -u $MYSQL_USER -h $MYSQL_HOST -P $MYSQL_PORT -p"$MYSQL_PASS" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;"
fi

# 执行初始化脚本
echo "📝 执行数据库初始化脚本..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -z "$MYSQL_PASS" ]; then
    $MYSQL_CMD -u $MYSQL_USER -h $MYSQL_HOST -P $MYSQL_PORT $DB_NAME < ../../database/lynshae_init.sql
else
    $MYSQL_CMD -u $MYSQL_USER -h $MYSQL_HOST -P $MYSQL_PORT -p"$MYSQL_PASS" $DB_NAME < ../../database/lynshae_init.sql
fi

echo "✅ 数据库初始化完成!"
echo ""
echo "📊 数据库信息:"
echo "   数据库名：$DB_NAME"
echo "   主机：$MYSQL_HOST:$MYSQL_PORT"
echo ""
echo "🎉 现在可以启动后端服务："
echo "   开发模式：./scripts/start-backend.sh -d"
echo "   生产模式：./scripts/start-backend.sh -p"
