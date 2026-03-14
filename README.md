# 🏠 Lynshae Project

> 灵羲 - 智能设备控制平台

---

## 📁 项目结构

本项目采用前后端分离的架构：

```
lynshae_app/
├── app/              # Flutter 移动端应用 (Android/iOS/macOS)
├── backend/          # Node.js 后端服务 (Express + MySQL + Redis)
├── docs/             # 项目文档
├── scripts/          # 构建和部署脚本
└── README.md         # 本文件
```

---

## 📱 移动端 App (app/)

Flutter 跨平台移动应用，支持 Android、iOS 和 macOS。

### 功能特性
- 🎮 **实时控制** - 虚拟摇杆、动作执行
- 💕 **情感互动** - 陪伴互动、等级系统
- 📊 **状态监控** - 电量、信号、模式
- 🔧 **设备管理** - 配置设置、固件升级

### 快速开始

```bash
cd app

# 获取依赖
flutter pub get

# 运行项目
flutter run

# 构建发布
flutter build apk --release    # Android
flutter build ios --release    # iOS
```

### 详细文档
- [App README](app/README.md)
- [快速开始指南](docs/QUICK_START.md)
- [部署指南](docs/DEPLOYMENT_GUIDE.md)

---

## 🔧 后端服务 (backend/)

基于 Node.js + Express 的 RESTful API 服务。

### 技术栈
- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Database**: MySQL 8.0
- **Cache**: Redis 7.x
- **Deployment**: Docker + Docker Compose

### 快速开始

```bash
cd backend

# 复制环境变量
cp .env.example .env

# 一键启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f
```

### 详细文档
- [后端 README](backend/README.md)
- [API 文档](backend/docs/API.md)
- [部署指南](backend/docs/DEPLOYMENT.md)

---

## 📚 文档导航

| 文档 | 路径 | 描述 |
|------|------|------|
| 项目概述 | docs/PROJECT_OVERVIEW.md | 项目定位和功能 |
| 架构设计 | docs/ARCHITECTURE.md | 技术架构说明 |
| 功能特性 | docs/FEATURES.md | 详细功能列表 |
| 开发指南 | docs/DEVELOPMENT_GUIDE.md | 开发环境和规范 |
| 数据模型 | docs/DATA_MODELS.md | 数据模型定义 |

---

## 🚀 一键部署

### 开发环境

```bash
# 启动后端服务
cd backend && docker-compose up -d

# 启动前端应用
cd app && flutter run
```

### 生产环境

```bash
# 使用生产配置启动所有服务
docker-compose -f docker-compose.prod.yml up -d
```

---

## 📋 目录说明

| 目录 | 描述 |
|------|------|
| `app/` | Flutter 移动端应用 |
| `backend/` | Node.js 后端服务 |
| `docs/` | 项目文档 |
| `scripts/` | 构建和部署脚本 |
| `.claude/` | Claude 配置 |
| `.git/` | Git 版本控制 |

---

## 🛠️ 开发环境要求

- **Flutter**: 3.41.3+
- **Dart**: 3.11.1+
- **Node.js**: 18+
- **Docker**: 20.10+
- **MySQL**: 8.0+ (Docker)
- **Redis**: 7.x (Docker)

---

## 📞 联系方式

- 📧 Email: support@lingxi.com
- 🐛 Issues: [GitHub Issues](https://github.com/freakz3z/lynshae_app/issues)

---

<div align="center">
  <strong>灵羲 - 让智能设备成为你生活中最贴心的伙伴</strong>
  <br/>
  <sub>最后更新：2026-03-14</sub>
</div>
