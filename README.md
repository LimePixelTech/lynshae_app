# 🐕 lynshae_app

> 智能机器狗配套 Flutter APP - 控制中枢、互动窗口、养成陪伴

[![Flutter](https://img.shields.io/badge/Flutter-3.41.3-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.1-blue.svg)](https://dart.dev)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20macOS-green.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## 📱 应用预览

<div align="center">
  <img src="docs/assets/screenshots/home.png" alt="首页" width="200"/>
  <img src="docs/assets/screenshots/control.png" alt="控制" width="200"/>
  <img src="docs/assets/screenshots/bonding.png" alt="亲密度" width="200"/>
</div>

---

## ✨ 核心特性

### 🎮 实时控制
- 虚拟摇杆精准操控
- 预设动作一键执行
- 紧急停止保护
- 实时状态反馈

### 💕 亲密度养成
- 5 个亲密度等级系统
- 日常任务与成就
- 互动记录追踪
- 情感化反馈

### 📊 设备监控
- 电量实时监控
- 信号强度显示
- 多模式切换（陪伴/巡逻/跟随/休眠）
- 智能家居集成

### 🔧 便捷管理
- 蓝牙快速配对
- 设备配置管理
- 固件升级支持
- 用户偏好设置

---

## 🚀 快速开始

### 环境要求

- **Flutter**: 3.41.3+
- **Dart**: 3.11.1+
- **Android**: API 21+ (Android 5.0+)
- **iOS**: 12.0+
- **macOS**: 10.15+

### 安装步骤

```bash
# 1. 克隆项目
git clone https://github.com/your-username/lynshae_app.git
cd lynshae_app

# 2. 安装依赖
flutter pub get

# 3. 运行项目
flutter run
```

### 详细部署指南

📖 **从零开始部署**: 请查看 [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

该指南包含：
- ✅ 完整的开发环境搭建教程
- ✅ Android / iOS / macOS 平台部署
- ✅ 发布版本构建与签名
- ✅ 常见问题排查方案
- ✅ 性能优化建议

---

## 📁 项目结构

```
lynshae_app/
├── lib/
│   ├── main.dart                 # 应用入口
│   ├── constants/                # 常量定义
│   ├── models/                   # 数据模型
│   ├── screens/                  # 屏幕组件
│   ├── services/                 # 服务层
│   ├── theme/                    # 主题配置
│   ├── utils/                    # 工具函数
│   └── widgets/                  # 可复用组件
├── docs/                         # 项目文档
├── assets/                       # 静态资源
├── android/                      # Android 配置
├── ios/                          # iOS 配置
├── macos/                        # macOS 配置
└── pubspec.yaml                  # 项目配置
```

---

## 📚 文档导航

| 文档 | 描述 |
|------|------|
| [🚀 部署指南](DEPLOYMENT_GUIDE.md) | 从零开始的完整部署教程 |
| [📋 项目概述](docs/PROJECT_OVERVIEW.md) | 项目定位、功能特性、技术栈 |
| [🏗️ 架构设计](docs/ARCHITECTURE.md) | 分层架构、核心模块设计 |
| [🎯 功能特性](docs/FEATURES.md) | 详细功能说明 |
| [💻 开发指南](docs/DEVELOPMENT_GUIDE.md) | 开发环境、编码规范、最佳实践 |
| [📊 数据模型](docs/DATA_MODELS.md) | 数据模型定义与使用 |
| [🔌 蓝牙协议](docs/BLUETOOTH_PROTOCOL.md) | 蓝牙通信协议规范 |

---

## 🎨 UI 设计

### 配色方案

| 颜色 | 色值 | 用途 |
|------|------|------|
| 科技蓝 | `#4A90E2` | 主色调、按钮、强调 |
| 温暖橙 | `#FF6B6B` | 辅助色、通知、警告 |
| 深空灰 | `#1A1A2E` | 背景色 |
| 卡片色 | `#16213E` | 卡片背景 |
| 成功绿 | `#4CAF50` | 成功状态 |
| 警告黄 | `#FFC107` | 警告状态 |
| 错误红 | `#F44336` | 错误状态 |

### 设计风格
- 现代化卡片设计
- 圆角处理（12dp）
- 渐变效果
- 流畅动画（200-300ms）
- 暗黑模式优先

---

## 🛠️ 开发命令

```bash
# 获取依赖
flutter pub get

# 代码检查
flutter analyze

# 格式化代码
dart format .

# 运行测试
flutter test

# 清理构建
flutter clean

# 查看设备
flutter devices

# 运行应用
flutter run

# 构建 APK
flutter build apk --release

# 构建 iOS
flutter build ios --release

# 构建 macOS
flutter build macos --release
```

---

## 📦 主要依赖

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 蓝牙通信
  flutter_bluetooth_serial: ^0.4.0
  
  # 网络扫描
  wifi_scan: ^0.4.1
  
  # 权限管理
  permission_handler: ^11.1.0
  
  # 路由管理
  go_router: ^13.0.1
  
  # 虚拟摇杆
  flutter_joystick: ^0.2.0
  
  # 进度指示
  percent_indicator: ^4.2.3
  
  # 动画效果
  flutter_animate: ^4.3.0
  
  # 本地存储
  shared_preferences: ^2.2.2
```

---

## 🎯 核心数据模型

### 设备状态 (DeviceStatus)
```dart
enum DeviceStatus {
  idle,       // 空闲
  moving,     // 移动中
  executing,  // 执行动作
  charging,   // 充电中
  sleeping,   // 休眠
  error       // 错误
}
```

### 设备模式 (DeviceMode)
```dart
enum DeviceMode {
  companion,  // 陪伴模式
  patrol,     // 巡逻模式
  follow,     // 跟随模式
  sleep       // 休眠模式
}
```

### 亲密度等级 (BondingLevel)
```dart
enum BondingLevel {
  stranger,      // 初识 (0-100)
  acquaintance,  // 熟悉 (101-300)
  trusted,       // 信赖 (301-600)
  close,         // 亲密 (601-1000)
  soulmate       // 灵魂伴侣 (1001+)
}
```

### 狗狗动作 (DogAction)
```dart
enum DogAction {
  shake,      // 握手
  sit,        // 坐下
  rollover,   // 打滚
  jump,       // 跳跃
  bark,       // 吠叫
  dance,      // 跳舞
  beg,        // 乞讨
  spin        // 转圈
}
```

---

## 🤝 贡献指南

我们欢迎各种形式的贡献！

### 贡献流程

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 开发规范

- 遵循 [Dart 代码规范](https://dart.dev/guides/language/effective-dart/style)
- 编写清晰的注释和文档
- 为新功能添加测试
- 确保代码检查通过 (`flutter analyze`)

详见 [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 🐛 问题反馈

遇到问题？请通过以下方式联系我们：

- 🐛 **提交 Issue**: [GitHub Issues](https://github.com/lynshae/lynshae_app/issues)
- 📧 **邮件联系**: support@lynshae.dev
- 💬 **社区讨论**: [Discord](https://discord.gg/lynshae)

提交 Issue 时请提供：
- 问题描述
- 复现步骤
- 环境信息（Flutter 版本、设备型号、系统版本）
- 错误日志或截图

---

## 📈 开发路线图

### 已完成 ✅
- [x] 项目框架搭建
- [x] 核心数据模型
- [x] 蓝牙服务
- [x] 存储服务
- [x] 主屏幕组件
- [x] UI 主题配置
- [x] 亲密度系统
- [x] 日常任务系统
- [x] 完整文档体系

### 进行中 🚧
- [ ] 蓝牙通信协议完善
- [ ] 设备卡片组件优化
- [ ] 动作执行功能
- [ ] 真机测试

### 计划中 📋
- [ ] 智能家居集成
- [ ] 固件升级功能
- [ ] 数据统计分析
- [ ] 社交分享功能
- [ ] 多语言支持
- [ ] 无障碍访问

---

## 📄 开源协议

本项目采用 [MIT](LICENSE) 协议开源。

```
MIT License

Copyright (c) 2026 lynshae Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 🙏 致谢

感谢以下开源项目：

- [Flutter](https://flutter.dev) - 跨平台 UI 框架
- [flutter_bluetooth_serial](https://pub.dev/packages/flutter_bluetooth_serial) - 蓝牙通信
- [flutter_joystick](https://pub.dev/packages/flutter_joystick) - 虚拟摇杆
- [go_router](https://pub.dev/packages/go_router) - 路由管理
- [flutter_animate](https://pub.dev/packages/flutter_animate) - 动画效果

---

## 📞 联系我们

- **官网**: https://lynshae.dev
- **邮箱**: support@lynshae.dev
- **Discord**: [加入社区](https://discord.gg/lynshae)
- **Twitter**: [@lynshae_dev](https://twitter.com/lynshae_dev)
- **GitHub**: [@lynshae](https://github.com/lynshae)

---

<div align="center">
  <strong>🐕 Made with ❤️ by lynshae Team</strong>
  <br/>
  <sub>让机器狗成为你生活中最贴心的智能伙伴</sub>
</div>
