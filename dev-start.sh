#!/bin/bash

# LynShae 快速启动脚本（本地开发模式）
# 适用于 macOS

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🚀 LynShae 灵羲智能 - 本地开发模式启动"
echo "========================================="
echo ""

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装或未在 PATH 中"
    exit 1
fi

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安装"
    exit 1
fi

# 1. 启动数据库服务
echo "📦 启动 MySQL 和 Redis..."
docker-compose up -d mysql redis

# 等待数据库就绪
echo "⏳ 等待数据库启动..."
sleep 10

# 测试数据库连接
if docker exec lynshae-mysql mysqladmin ping -h localhost -u lynshae -pLynShae@2026 &> /dev/null; then
    echo "✅ MySQL 已就绪"
else
    echo "❌ MySQL 启动失败"
    exit 1
fi

# 2. 启动后端服务
echo ""
echo "🔧 启动后端服务..."
cd backend

if [ ! -d "node_modules" ]; then
    echo "📦 安装依赖..."
    npm install
fi

# 检查 .env 文件
if [ ! -f ".env" ]; then
    echo "📝 创建 .env 配置文件..."
    cp .env.example .env
fi

# 启动后端
echo "🚀 启动后端 API 服务 (端口 3005)..."
npm run dev &
BACKEND_PID=$!

cd ..

# 等待后端启动
sleep 5

# 测试后端
if curl -s http://localhost:3005/health &> /dev/null; then
    echo "✅ 后端 API 已就绪"
else
    echo "⚠️  后端服务可能还在启动中..."
fi

echo ""
echo "========================================="
echo "🎉 启动完成！"
echo ""
echo "📡 服务地址:"
echo "   - Backend API: http://localhost:3005"
echo "   - MySQL:       localhost:3306"
echo "   - Redis:       localhost:6379"
echo ""
echo "🔐 默认账号:"
echo "   - 管理员：admin@lynshae.com / admin123"
echo "   - 测试用户：test@lynshae.com / 123456"
echo ""
echo "📖 查看日志：docker-compose logs -f"
echo "🛑 停止服务：docker-compose down"
echo "========================================="
echo ""

# 保持脚本运行
wait $BACKEND_PID
