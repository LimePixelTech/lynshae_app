# 📱 灵羲 (Lynshae) - 移动端应用

> 灵羲智能设备控制平台 - Flutter 跨平台移动应用

---

## 🎯 应用简介

灵羲是一款基于 Flutter 的智能设备控制平台应用，提供：

- 🎮 **实时控制** - 虚拟摇杆、动作执行
- 💕 **情感互动** - 陪伴互动、情感等级系统
- 📊 **状态监控** - 电量、信号、模式
- 🔧 **设备管理** - 配置设置、固件升级

## 🚀 快速开始

### 环境要求

- Flutter 3.41.3+
- Dart 3.11.1+
- Android Studio / Xcode

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
# Android
flutter run

# iOS
flutter run -d ios

# macOS
flutter run -d macos
```

### 构建发布版本

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# macOS
flutter build macos --release
```

## 📁 项目结构

```
app/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── constants/
│   │   └── app_constants.dart       # 应用常量
│   ├── models/
│   │   ├── device_model.dart        # 设备模型
│   │   ├── interaction_model.dart   # 情感互动模型
│   │   ├── action_model.dart        # 动作模型
│   │   └── product_model.dart       # 产品模型
│   ├── screens/
│   │   ├── main_screen.dart         # 主导航页
│   │   ├── home_screen.dart         # 设备首页
│   │   ├── control_screen.dart      # 实时控制页
│   │   ├── interaction_screen.dart  # 情感互动页
│   │   └── settings_screen.dart     # 设置页
│   ├── theme/
│   │   └── app_theme.dart           # 主题配置
│   └── widgets/                     # 可复用组件
├── assets/                          # 资源文件
├── android/                         # Android 平台配置
├── ios/                             # iOS 平台配置
├── macos/                           # macOS 平台配置
└── pubspec.yaml                     # 依赖配置
```

## 🎨 主题设计

应用采用蓝橙配色方案：

- **主色调**: `#2B7FFF` (科技蓝) - 主要操作、控件
- **强调色**: `#FF6B35` (活力橙) - 警告、次要操作
- **深色背景**: `#1A1A2E` - 深色主题基底
- **卡片背景**: `#16213E` - 卡片表面

## 🛠️ 常用命令

```bash
# 获取依赖
flutter pub get

# 代码分析
flutter analyze

# 代码格式化
dart format lib/

# 运行测试
flutter test

# 清理构建缓存
flutter clean
```

## 📦 主要依赖

| 依赖 | 用途 |
|------|------|
| `flutter_bluetooth_serial` | 蓝牙设备通信 |
| `wifi_scan` | WiFi 设备发现 |
| `permission_handler` | 运行时权限管理 |
| `flutter_joystick` | 虚拟摇杆 |
| `go_router` | 导航路由 |
| `shared_preferences` | 本地存储 |
| `flutter_animate` | 动画效果 |

## 📝 开发指南

### 添加新设备模式

1. 在 `lib/models/device_model.dart` 中添加枚举值
2. 在扩展方法中添加显示名称和图标
3. 在 `home_screen.dart` 中添加 UI 处理

### 添加新动作

1. 在 `control_screen.dart` 中添加 `DogAction`
2. 在 `_executeAction()` 中实现执行逻辑
3. 添加相应的动画和反馈

### 主题切换

应用支持深色/浅色主题切换：

```dart
// 切换到深色模式
LynshaeApp.themeNotifier.value = ThemeMode.dark;

// 切换到浅色模式
LynshaeApp.themeNotifier.value = ThemeMode.light;
```

## 🐛 常见问题

### 无法在 Android 设备上运行

1. 检查 USB 调试已开启
2. 运行 `flutter doctor` 诊断问题
3. 确保已安装正确的 USB 驱动

### 蓝牙连接失败

1. 检查位置权限已授予
2. 确保设备已配对
3. 检查蓝牙权限在 AndroidManifest.xml 中已配置

## 📄 许可证

MIT License

---

<div align="center">
  <strong>灵羲 - 让智能设备成为你生活中最贴心的伙伴</strong>
  <br/>
  <sub>最后更新：2026-03-14</sub>
</div>
