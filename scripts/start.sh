#!/bin/bash

# 🚀 lynshae_app 快速启动脚本
# 用于快速配置开发环境和运行项目

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目信息
PROJECT_NAME="lynshae_app"
PROJECT_VERSION="1.0.0"

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║              🐕 lynshae_app 快速启动                     ║"
echo "║                                                          ║"
echo "║              智能机器狗配套 Flutter APP                  ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="Linux"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        OS="Windows"
    else
        OS="Unknown"
    fi
    echo -e "${BLUE}📱 检测到操作系统：${OS}${NC}"
}

# 检查 Flutter 是否安装
check_flutter() {
    echo -e "${YELLOW}⏳ 检查 Flutter 环境...${NC}"
    
    if command -v flutter &> /dev/null; then
        FLUTTER_VERSION=$(flutter --version | head -n 1)
        echo -e "${GREEN}✅ Flutter 已安装：${FLUTTER_VERSION}${NC}"
        return 0
    else
        echo -e "${RED}❌ Flutter 未安装${NC}"
        return 1
    fi
}

# 检查 Android 环境
check_android() {
    echo -e "${YELLOW}⏳ 检查 Android 环境...${NC}"
    
    if command -v adb &> /dev/null; then
        echo -e "${GREEN}✅ Android SDK 已安装${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Android SDK 未检测到（可选）${NC}"
        return 1
    fi
}

# 检查 iOS 环境（仅 macOS）
check_ios() {
    if [[ "$OS" == "macOS" ]]; then
        echo -e "${YELLOW}⏳ 检查 iOS 环境...${NC}"
        
        if command -v xcodebuild &> /dev/null; then
            echo -e "${GREEN}✅ Xcode 已安装${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️  Xcode 未安装（可选）${NC}"
            return 1
        fi
    fi
}

# 配置国内镜像（中国大陆用户）
setup_china_mirror() {
    echo ""
    read -p "$(echo -e ${YELLOW}🌏 是否使用国内镜像加速？(y/n): ${NC})" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}📦 配置国内镜像...${NC}"
        export PUB_HOSTED_URL=https://pub.flutter-io.cn
        export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
        echo -e "${GREEN}✅ 镜像配置完成${NC}"
    fi
}

# 安装依赖
install_dependencies() {
    echo ""
    echo -e "${BLUE}📦 安装项目依赖...${NC}"
    flutter pub get
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 依赖安装完成${NC}"
    else
        echo -e "${RED}❌ 依赖安装失败${NC}"
        exit 1
    fi
}

# 检查项目配置
check_project() {
    echo ""
    echo -e "${YELLOW}⏳ 检查项目配置...${NC}"
    flutter analyze
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 项目配置正常${NC}"
    else
        echo -e "${YELLOW}⚠️  项目存在一些问题，但不影响运行${NC}"
    fi
}

# 查看可用设备
list_devices() {
    echo ""
    echo -e "${BLUE}📱 可用设备列表:${NC}"
    flutter devices
}

# 运行项目
run_project() {
    echo ""
    read -p "$(echo -e ${YELLOW}🚀 是否立即运行项目？(y/n): ${NC})" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}🚀 启动项目...${NC}"
        flutter run
    fi
}

# 显示帮助信息
show_help() {
    echo ""
    echo "用法：$0 [选项]"
    echo ""
    echo "选项:"
    echo "  --help, -h          显示帮助信息"
    echo "  --mirror, -m        使用国内镜像"
    echo "  --no-run, -n        安装依赖后不运行项目"
    echo "  --clean, -c         清理后重新安装"
    echo ""
    echo "示例:"
    echo "  $0                  # 快速启动"
    echo "  $0 -m               # 使用国内镜像"
    echo "  $0 -c               # 清理后重新安装"
    echo "  $0 -m -n            # 使用国内镜像，不运行项目"
    echo ""
}

# 清理项目
clean_project() {
    echo -e "${YELLOW}🧹 清理项目...${NC}"
    flutter clean
    rm -rf build/
    echo -e "${GREEN}✅ 清理完成${NC}"
}

# 主函数
main() {
    USE_MIRROR=false
    NO_RUN=false
    DO_CLEAN=false
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                exit 0
                ;;
            --mirror|-m)
                USE_MIRROR=true
                shift
                ;;
            --no-run|-n)
                NO_RUN=true
                shift
                ;;
            --clean|-c)
                DO_CLEAN=true
                shift
                ;;
            *)
                echo -e "${RED}❌ 未知选项：$1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 执行流程
    detect_os
    echo ""
    
    # 检查 Flutter
    if ! check_flutter; then
        echo ""
        echo -e "${RED}❌ 请先安装 Flutter${NC}"
        echo -e "${YELLOW}📖 安装指南：https://flutter.dev/docs/get-started/install${NC}"
        echo ""
        exit 1
    fi
    
    # 检查 Android
    check_android
    
    # 检查 iOS
    check_ios
    
    echo ""
    
    # 配置镜像
    if [ "$USE_MIRROR" = true ]; then
        export PUB_HOSTED_URL=https://pub.flutter-io.cn
        export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
        echo -e "${BLUE}📦 已配置国内镜像${NC}"
    fi
    
    # 清理
    if [ "$DO_CLEAN" = true ]; then
        clean_project
    fi
    
    # 安装依赖
    install_dependencies
    
    # 检查项目
    check_project
    
    # 查看设备
    list_devices
    
    # 运行项目
    if [ "$NO_RUN" = false ]; then
        run_project
    fi
    
    echo ""
    echo -e "${GREEN}✅ 启动完成！${NC}"
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║  📖 更多文档请查看:                                      ║"
    echo "║     - DEPLOYMENT_GUIDE.md (完整部署指南)                ║"
    echo "║     - docs/ (项目文档)                                  ║"
    echo "║                                                          ║"
    echo "║  🌐 官方网站：https://lynshae.dev                       ║"
    echo "║  📧 技术支持：support@lynshae.dev                       ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
}

# 执行主函数
main "$@"
