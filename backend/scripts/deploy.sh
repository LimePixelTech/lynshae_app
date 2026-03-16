#!/bin/bash

# ============================================================
# LynShae Backend 一键部署脚本
# 用途：快速部署 LynShae 后端服务
# 系统要求：Docker, Docker Compose, Git
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查依赖
check_dependencies() {
    log_info "检查系统依赖..."
    
    local missing_deps=()
    
    # 检查 Docker
    if ! command -v docker &> /dev/null; then
        missing_deps+=("docker")
    fi
    
    # 检查 Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        missing_deps+=("docker-compose")
    fi
    
    # 检查 Git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "缺少依赖：${missing_deps[*]}"
        log_info "请使用以下命令安装:"
        log_info "  macOS: brew install ${missing_deps[*]}"
        log_info "  Ubuntu: sudo apt install ${missing_deps[*]}"
        exit 1
    fi
    
    log_success "系统依赖检查通过"
}

# 检查 Node.js (本地开发用)
check_nodejs() {
    if command -v node &> /dev/null; then
        local node_version=$(node -v)
        log_info "Node.js 版本：$node_version"
        
        # 检查版本 >= 18
        if [ $(node -v | cut -d'.' -f1 | tr -d 'v') -lt 18 ]; then
            log_warning "Node.js 版本过低，建议使用 v18 或更高版本"
        fi
    else
        log_warning "未检测到 Node.js，Docker 部署模式不需要"
    fi
}

# 创建必要目录
create_directories() {
    log_info "创建必要目录..."
    
    mkdir -p docker/mysql/data
    mkdir -p docker/mysql/init
    mkdir -p docker/mysql/conf
    mkdir -p docker/redis/data
    mkdir -p docker/redis/conf
    mkdir -p uploads
    mkdir -p logs
    mkdir -p scripts
    
    log_success "目录创建完成"
}

# 复制数据库初始化脚本
copy_database_scripts() {
    log_info "复制数据库初始化脚本..."
    
    if [ -f "../database/lynshae_init.sql" ]; then
        cp ../database/lynshae_init.sql docker/mysql/init/01_init.sql
        log_success "数据库初始化脚本已复制"
    else
        log_warning "未找到数据库初始化脚本，请手动放置到 docker/mysql/init/"
    fi
}

# 生成环境变量文件
generate_env() {
    log_info "生成环境变量配置..."
    
    if [ ! -f ".env" ]; then
        cp .env.example .env
        
        # 生成随机 JWT Secret
        local jwt_secret=$(openssl rand -hex 32)
        sed -i.bak "s/JWT_SECRET=.*/JWT_SECRET=$jwt_secret/" .env
        rm -f .env.bak
        
        log_success "环境变量配置已生成 (.env)"
        log_warning "请检查 .env 文件并修改密码等敏感信息"
    else
        log_info ".env 文件已存在，跳过生成"
    fi
}

# 安装依赖 (本地开发)
install_dependencies() {
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        log_info "安装 Node.js 依赖..."
        npm ci --production
        log_success "依赖安装完成"
    fi
}

# 启动 Docker 服务
start_services() {
    log_info "启动 Docker 服务..."
    
    # 检查 docker compose 命令
    if docker compose version &> /dev/null; then
        docker compose up -d
    else
        docker-compose up -d
    fi
    
    log_success "服务启动成功"
}

# 等待服务就绪
wait_for_services() {
    log_info "等待服务启动..."
    
    # 等待 MySQL
    log_info "等待 MySQL 启动..."
    local mysql_retries=30
    while [ $mysql_retries -gt 0 ]; do
        if docker exec lynshae-mysql mysqladmin ping -h localhost -u root -p${DB_PASSWORD:-LynShae@2026} &> /dev/null; then
            log_success "MySQL 已就绪"
            break
        fi
        sleep 2
        mysql_retries=$((mysql_retries - 1))
    done
    
    if [ $mysql_retries -eq 0 ]; then
        log_error "MySQL 启动超时"
        exit 1
    fi
    
    # 等待 Redis
    log_info "等待 Redis 启动..."
    local redis_retries=10
    while [ $redis_retries -gt 0 ]; do
        if docker exec lynshae-redis redis-cli ping &> /dev/null; then
            log_success "Redis 已就绪"
            break
        fi
        sleep 1
        redis_retries=$((redis_retries - 1))
    done
    
    if [ $redis_retries -eq 0 ]; then
        log_error "Redis 启动超时"
        exit 1
    fi
    
    # 等待应用
    log_info "等待应用启动..."
    sleep 5
    
    local app_retries=10
    while [ $app_retries -gt 0 ]; do
        if curl -s http://localhost:${PORT:-3000}/health &> /dev/null; then
            log_success "应用已就绪"
            break
        fi
        sleep 2
        app_retries=$((app_retries - 1))
    done
    
    if [ $app_retries -eq 0 ]; then
        log_warning "应用健康检查未通过，请查看日志：docker logs lynshae-app"
    fi
}

# 显示部署信息
show_info() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}   LynShae Backend 部署完成！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${BLUE}服务状态:${NC}"
    echo "  - MySQL:   http://localhost:${DB_PORT:-3306}"
    echo "  - Redis:   http://localhost:${REDIS_PORT:-6379}"
    echo "  - API:     http://localhost:${PORT:-3000}"
    echo ""
    echo -e "${BLUE}管理命令:${NC}"
    echo "  查看日志：    docker logs -f lynshae-app"
    echo "  停止服务：    docker-compose down"
    echo "  重启服务：    docker-compose restart"
    echo "  进入容器：    docker exec -it lynshae-app sh"
    echo ""
    echo -e "${YELLOW}默认管理员账号:${NC}"
    echo "  邮箱：admin@lynshae.com"
    echo "  密码：请查看初始化日志或数据库"
    echo ""
    echo -e "${YELLOW}下一步:${NC}"
    echo "  1. 修改 .env 文件中的密码和密钥"
    echo "  2. 访问 http://localhost:${PORT:-3000}/health 检查服务"
    echo "  3. 查看 API 文档：http://localhost:${PORT:-3000}/api-docs"
    echo ""
}

# 主函数
main() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}   LynShae Backend 一键部署${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    
    check_dependencies
    check_nodejs
    create_directories
    copy_database_scripts
    generate_env
    install_dependencies
    start_services
    wait_for_services
    show_info
}

# 执行主函数
main "$@"
