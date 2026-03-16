# LynShae App

灵羲智能 - 移动应用（Flutter）

## 功能特性

- 🤖 机器狗控制
- 📱 设备管理
- 🎮 虚拟摇杆
- 📹 实时视频
- 🔋 电量监控
- 📍 位置追踪

## 环境要求

- Flutter 3.0+
- Dart 3.0+
- Android Studio / VS Code
- Xcode (macOS/iOS)

## 快速开始

```bash
# 安装依赖
flutter pub get

# 运行应用
flutter run

# 构建 Release
flutter build apk --release
flutter build ios --release
```

## 主题系统

支持双主题模式：
- 🌙 深色模式：科技蓝 (#3B7CFF)
- ☀️ 浅色模式：温馨米 (#D4C4B0)

## 主要组件

- `GlassContainer` - 玻璃态容器
- `GlassCard` - 玻璃态卡片
- `GlassButton` - 玻璃态按钮
- `GlassInput` - 玻璃态输入框
- `ProductCard` - 商品卡片

## 通信方式

- **蓝牙**: 设备控制
- **WiFi**: 配网与数据传输
- **HTTP/WebSocket**: 与后端 API 通信

## API 配置

在 `lib/config/api_config.dart` 中配置后端 API 地址：

```dart
const String API_BASE_URL = 'http://localhost:3005/api/v1';
```

## 文档

- [App 说明](docs/App 说明.md)

## 开发指南

详见主项目 [开发文档](../backend/docs/开发指南.md)
