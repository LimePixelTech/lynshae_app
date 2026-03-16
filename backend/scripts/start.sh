#!/bin/bash

# LynShae Backend 一键启动脚本
# 用法：./scripts/start.sh [mode]
# mode: dev (开发模式，默认) | prod (生产模式) | test (测试模式)

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

# 启动模式
MODE=${1:-dev}

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   LynShae Backend 一键启动脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查 Node.js
check_nodejs() {
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js 未安装，请先安装 Node.js 18+${NC}"
        echo "   安装命令：brew install node@18"
        exit 1
    fi
    
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✅ Node.js: ${NODE_VERSION}${NC}"
}

# 检查 npm
check_npm() {
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}❌ npm 未安装${NC}"
        exit 1
    fi
    
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}✅ npm: ${NPM_VERSION}${NC}"
}

# 检查 MySQL
check_mysql() {
    if ! command -v mysql &> /dev/null; then
        echo -e "${YELLOW}⚠️  MySQL 客户端未找到，但可能已安装${NC}"
        return
    fi
    
    MYSQL_VERSION=$(mysql --version)
    echo -e "${GREEN}✅ MySQL: ${MYSQL_VERSION}${NC}"
    
    # 检查 MySQL 服务是否运行
    if brew services list | grep -q "mysql.*started"; then
        echo -e "${GREEN}✅ MySQL 服务：运行中${NC}"
    else
        echo -e "${YELLOW}⚠️  MySQL 服务未运行，正在启动...${NC}"
        brew services start mysql@8.0 || brew services start mysql
    fi
}

# 检查 Redis
check_redis() {
    if ! command -v redis-cli &> /dev/null; then
        echo -e "${YELLOW}⚠️  Redis 客户端未找到${NC}"
        echo "   安装命令：brew install redis"
        return
    fi
    
    REDIS_VERSION=$(redis-cli --version)
    echo -e "${GREEN}✅ Redis: ${REDIS_VERSION}${NC}"
    
    # 检查 Redis 服务是否运行
    if brew services list | grep -q "redis.*started"; then
        echo -e "${GREEN}✅ Redis 服务：运行中${NC}"
    else
        echo -e "${YELLOW}⚠️  Redis 服务未运行，正在启动...${NC}"
        brew services start redis
    fi
    
    # 测试 Redis 连接
    if redis-cli ping &> /dev/null; then
        echo -e "${GREEN}✅ Redis 连接测试：成功${NC}"
    else
        echo -e "${RED}❌ Redis 连接失败${NC}"
    fi
}

# 检查依赖
check_dependencies() {
    echo -e "${BLUE}📦 检查系统依赖...${NC}"
    echo ""
    
    check_nodejs
    check_npm
    check_mysql
    check_redis
    
    echo ""
}

# 安装 npm 依赖
install_dependencies() {
    echo -e "${BLUE}📦 检查 npm 依赖...${NC}"
    
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}⚠️  node_modules 不存在，正在安装依赖...${NC}"
        npm install
        echo -e "${GREEN}✅ 依赖安装完成${NC}"
    else
        echo -e "${GREEN}✅ node_modules 已存在${NC}"
        
        # 检查 package-lock.json 是否有变化
        if [ -f "node_modules/.package-lock.json" ]; then
            echo -e "${GREEN}✅ 依赖已安装${NC}"
        fi
    fi
    
    echo ""
}

# 检查环境变量
check_env() {
    echo -e "${BLUE}🔧 检查环境配置...${NC}"
    
    if [ ! -f ".env" ]; then
        echo -e "${YELLOW}⚠️  .env 文件不存在，正在从 .env.example 创建...${NC}"
        if [ -f ".env.example" ]; then
            cp .env.example .env
            echo -e "${GREEN}✅ .env 文件已创建，请编辑配置后重新运行${NC}"
            echo ""
            exit 0
        else
            echo -e "${RED}❌ .env.example 不存在，请手动创建 .env 文件${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✅ .env 文件已存在${NC}"
    fi
    
    echo ""
}

# 启动服务器
start_server() {
    echo -e "${BLUE}🚀 启动服务器...${NC}"
    echo ""
    
    case $MODE in
        dev)
            echo -e "${GREEN}运行模式：开发模式 (development)${NC}"
            echo -e "${GREEN}API 地址：http://localhost:3005${NC}"
            echo ""
            # 使用 test-server-full.js 启动（包含模拟数据）
            if [ -f "test-server-full.js" ]; then
                node test-server-full.js
            elif [ -f "src/server.js" ]; then
                node src/server.js
            else
                echo -e "${RED}❌ 找不到服务器入口文件${NC}"
                exit 1
            fi
            ;;
        prod)
            echo -e "${GREEN}运行模式：生产模式 (production)${NC}"
            export NODE_ENV=production
            node src/server.js
            ;;
        test)
            echo -e "${GREEN}运行模式：测试模式 (test)${NC}"
            if [ -f "test-server.js" ]; then
                node test-server.js
            else
                echo -e "${RED}❌ 找不到测试服务器文件${NC}"
                exit 1
            fi
            ;;
        *)
            echo -e "${RED}❌ 未知的运行模式：$MODE${NC}"
            echo "   可用模式：dev, prod, test"
            exit 1
            ;;
    esac
}

# 主流程
main() {
    check_dependencies
    install_dependencies
    check_env
    start_server
}

# 捕获退出信号
trap 'echo -e "\n${YELLOW}👋 服务器已停止${NC}"; exit 0' INT TERM

# 运行主流程
main
