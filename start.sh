#!/bin/bash
# LynShae 灵羲智能 - 启动脚本

set -e

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$WORKSPACE_DIR"

echo "========================================"
echo "  LynShae 灵羲智能 - 启动脚本"
echo "========================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker 未安装${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker 已安装${NC}"
}

# 检查 Docker Compose
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        echo -e "${RED}❌ Docker Compose 未安装${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker Compose 已安装${NC}"
}

# 检查 .env 文件
check_env() {
    if [ ! -f ".env" ]; then
        echo -e "${YELLOW}⚠️  .env 文件不存在，从 .env.example 复制${NC}"
        cp .env.example .env
        echo -e "${GREEN}✅ .env 文件已创建${NC}"
    else
        echo -e "${GREEN}✅ .env 文件已存在${NC}"
    fi
}

# 启动服务
start_services() {
    echo ""
    echo "🚀 启动 Docker 服务..."
    
    # 使用 docker compose 或 docker-compose
    if docker compose version &> /dev/null; then
        docker compose up -d
    else
        docker-compose up -d
    fi
    
    echo -e "${GREEN}✅ 服务启动完成${NC}"
}

# 等待服务就绪
wait_for_services() {
    echo ""
    echo "⏳ 等待服务就绪..."
    
    # 等待 MySQL
    echo "  - 等待 MySQL..."
    for i in {1..30}; do
        if docker exec lynshae-mysql mysqladmin ping -h localhost -u root -pLynShae@2026Root &> /dev/null; then
            echo -e "  ${GREEN}✅ MySQL 已就绪${NC}"
            break
        fi
        if [ $i -eq 30 ]; then
            echo -e "  ${RED}❌ MySQL 启动超时${NC}"
            exit 1
        fi
        sleep 1
    done
    
    # 等待 Redis
    echo "  - 等待 Redis..."
    for i in {1..30}; do
        if docker exec lynshae-redis redis-cli ping &> /dev/null; then
            echo -e "  ${GREEN}✅ Redis 已就绪${NC}"
            break
        fi
        if [ $i -eq 30 ]; then
            echo -e "  ${RED}❌ Redis 启动超时${NC}"
            exit 1
        fi
        sleep 1
    done
    
    # 等待 Backend
    echo "  - 等待 Backend API..."
    for i in {1..60}; do
        if curl -s http://localhost:3005/health &> /dev/null; then
            echo -e "  ${GREEN}✅ Backend API 已就绪${NC}"
            break
        fi
        if [ $i -eq 60 ]; then
            echo -e "  ${RED}❌ Backend API 启动超时${NC}"
            echo "  查看日志：docker-compose logs backend"
            exit 1
        fi
        sleep 1
    done
}

# 测试 API
test_api() {
    echo ""
    echo "🧪 测试 API..."
    
    # 健康检查
    HEALTH=$(curl -s http://localhost:3005/health)
    if echo "$HEALTH" | grep -q '"status":"ok"'; then
        echo -e "${GREEN}✅ 健康检查通过${NC}"
    else
        echo -e "${RED}❌ 健康检查失败${NC}"
        exit 1
    fi
    
    # API 文档
    DOCS=$(curl -s http://localhost:3005/api/v1/docs)
    if echo "$DOCS" | grep -q '"name":"LynShae API"'; then
        echo -e "${GREEN}✅ API 文档可访问${NC}"
    else
        echo -e "${RED}❌ API 文档访问失败${NC}"
        exit 1
    fi
}

# 显示服务状态
show_status() {
    echo ""
    echo "========================================"
    echo "  服务状态"
    echo "========================================"
    echo ""
    
    if docker compose version &> /dev/null; then
        docker compose ps
    else
        docker-compose ps
    fi
    
    echo ""
    echo "========================================"
    echo "  访问地址"
    echo "========================================"
    echo ""
    echo "  🌐 Backend API:  http://localhost:3005"
    echo "  🗄️  MySQL:        localhost:3306"
    echo "  💾 Redis:         localhost:6379"
    echo ""
    echo "  默认账号:"
    echo "  👤 管理员：admin@lynshae.com / admin123"
    echo "  👤 测试用户：test@lynshae.com / 123456"
    echo ""
    echo "========================================"
}

# 主函数
main() {
    check_docker
    check_docker_compose
    check_env
    start_services
    wait_for_services
    test_api
    show_status
    
    echo -e "${GREEN}✅ LynShae 系统启动成功！${NC}"
}

# 运行主函数
main
