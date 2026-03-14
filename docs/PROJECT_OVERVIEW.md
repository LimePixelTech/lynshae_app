# 🐕 lynshae_app 项目概述

> 灵羲 - 智能设备控制 App - 控制中枢、互动窗口、智能陪伴

---

## 🎯 项目定位

**lynshae_app** 是一款专为智能设备设计的移动端控制应用，提供：

- 🎮 **实时控制** - 虚拟摇杆、动作执行
- 💕 **情感互动** - 陪伴互动、等级系统
- 📊 **状态监控** - 电量、信号、模式
- 🔧 **设备管理** - 配置设置、固件升级

### 产品愿景

> 让智能设备成为你生活中最贴心的智能伙伴

### 核心功能

1. **设备管理** - 多设备连接管理
2. **智能控制** - 精准运动控制
3. **互动养成** - 情感化互动系统
4. **智能场景** - 自动化任务执行

---

## 📊 技术栈

### 核心框架
- **Flutter** 3.41.3 - 跨平台 UI 框架
- **Dart** 3.11.1 - 类型安全语言

### 主要依赖
- `flutter_bluetooth_serial` - 蓝牙通信
- `flutter_joystick` - 虚拟摇杆
- `go_router` - 路由管理
- `provider` - 状态管理
- `shared_preferences` - 本地存储
- `flutter_animate` - 动画效果

### 平台支持
- ✅ Android 5.0+ (API 21+)
- ✅ iOS 12.0+
- ✅ macOS 10.15+

---

## 🏗️ 架构设计

### 分层架构

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Screens, Widgets, UI States)      │
├─────────────────────────────────────┤
│         State Management            │
│      (Provider, ChangeNotifier)     │
├─────────────────────────────────────┤
│         Service Layer               │
│  (Bluetooth, Storage, Utils)        │
├─────────────────────────────────────┤
│         Data Layer                  │
│   (Models, Constants, Config)       │
└─────────────────────────────────────┘
```

### 核心模块

1. **BluetoothService** - 蓝牙连接管理
2. **StorageService** - 本地数据存储
3. **DeviceModel** - 设备状态管理
4. **BondingModel** - 亲密度系统
5. **AppTheme** - 主题配置

---

## ✨ 功能特性

### 1. 首页 (HomeScreen)
- ✅ 设备状态卡片
- ✅ 电量显示
- ✅ 模式切换按钮
- ✅ 信号强度指示
- ✅ 快速操作入口

### 2. 控制页 (ControlScreen)
- ✅ 虚拟摇杆
- ✅ 动作按钮
- ✅ 紧急停止
- ✅ 实时状态反馈
- ✅ 延迟监控

### 3. 亲密度页 (BondingScreen)
- ✅ 亲密度进度条
- ✅ 等级展示
- ✅ 日常任务列表
- ✅ 成就系统
- ✅ 互动记录

### 4. 设置页 (SettingsScreen)
- ✅ 应用设置
- ✅ 设备配置
- ✅ 关于页面
- ✅ 帮助文档

---

## 📁 项目结构

```
lynshae_app/
├── lib/
│   ├── main.dart                 # 应用入口
│   ├── constants/
│   │   └── app_constants.dart    # 应用常量
│   ├── models/
│   │   ├── device_model.dart     # 设备模型
│   │   └── bonding_model.dart    # 亲密度模型
│   ├── screens/
│   │   ├── home_screen.dart      # 首页
│   │   ├── control_screen.dart   # 控制页
│   │   ├── bonding_screen.dart   # 亲密度页
│   │   └── settings_screen.dart  # 设置页
│   ├── services/
│   │   ├── bluetooth_service.dart # 蓝牙服务
│   │   └── storage_service.dart   # 存储服务
│   ├── theme/
│   │   └── app_theme.dart        # 主题配置
│   ├── utils/
│   │   └── app_utils.dart        # 工具函数
│   └── widgets/
│       ├── bonding_progress_bar.dart
│       ├── daily_task_card.dart
│       └── device_card.dart
├── assets/                       # 静态资源
├── android/                      # Android 配置
├── ios/                          # iOS 配置
├── macos/                        # macOS 配置
└── pubspec.yaml                  # 依赖配置
```

---

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.41.3+
- Dart SDK 3.11.1+
- Android Studio / Xcode
- 支持蓝牙的设备

### 安装步骤

```bash
# 克隆项目
git clone <repository_url>
cd lynshae_app

# 安装依赖
flutter pub get

# 运行项目
flutter run
```

### 构建发布

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# macOS
flutter build macos --release
```

---

## 🔧 开发命令

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
```

---

## 📊 核心数据模型

### DeviceStatus (设备状态)
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

### DeviceMode (设备模式)
```dart
enum DeviceMode {
  companion,  // 陪伴模式
  patrol,     // 巡逻模式
  follow,     // 跟随模式
  sleep       // 休眠模式
}
```

### BondingLevel (互动等级)
```dart
enum BondingLevel {
  stranger,      // 初识 (0-100)
  acquaintance,  // 熟悉 (101-300)
  trusted,       // 信赖 (301-600)
  close,         // 亲密 (601-1000)
  soulmate       // 灵魂伴侣 (1001+)
}
```

### DeviceAction (设备动作)
```dart
enum DeviceAction {
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

## 🎨 UI 设计

### 配色方案

```dart
// 主色调
primaryColor: Color(0xFF4A90E2)    // 科技蓝
accentColor: Color(0xFFFF6B6B)     // 温暖橙

// 背景色
backgroundColor: Color(0xFF1A1A2E)  // 深空灰
cardColor: Color(0xFF16213E)        // 卡片色

// 状态色
successColor: Color(0xFF4CAF50)     // 成功绿
warningColor: Color(0xFFFFC107)     // 警告黄
errorColor: Color(0xFFF44336)       // 错误红
```

### 设计风格

- **现代化卡片** - 圆角、阴影、渐变
- **流畅动画** - 页面切换、状态变化
- **直观交互** - 大按钮、清晰反馈
- **暗黑模式** - 护眼设计

---

## 🔌 蓝牙通信

### 连接流程

1. 扫描附近设备
2. 请求配对
3. 建立连接
4. 数据通信
5. 断开连接

### 数据协议

```dart
// 命令格式
{
  "command": "move",
  "params": {
    "direction": "forward",
    "speed": 50
  }
}

// 响应格式
{
  "status": "success",
  "data": {
    "battery": 85,
    "signal": -60
  }
}
```

---

## 🐛 常见问题

### 1. 蓝牙连接失败

**原因**:
- 蓝牙未开启
- 权限未授予
- 设备未配对或不在范围内

**解决**:
```dart
// 检查蓝牙状态
final bluetoothState = await FlutterBluetoothSerial.instance.state;

// 请求权限
await Permission.bluetooth.request();

// 扫描设备
FlutterBluetoothSerial.instance.startDiscovery();
```

### 2. 控制无响应

**原因**:
- 蓝牙未连接
- 设备未连接或处于休眠模式
- 命令格式错误

**解决**:
- 检查连接状态
- 唤醒设备
- 查看日志输出

### 3. 互动数据丢失

**原因**:
- 存储权限问题
- 应用被清理
- 数据未同步

**解决**:
```dart
// 保存数据
await StorageService.saveInteractionData(data);

// 恢复数据
final data = await StorageService.loadInteractionData();
```

---

## 📈 开发进度

### 已完成
- ✅ 项目框架搭建
- ✅ 核心数据模型
- ✅ 蓝牙服务
- ✅ 存储服务
- ✅ 主屏幕组件
- ✅ UI 主题系统
- ✅ 互动等级系统
- ✅ 日常任务系统

### 进行中
- ⏳ 蓝牙通信协议完善
- ⏳ 设备卡片组件
- ⏳ 编译错误修复

### 待开发
- 📋 动作执行功能
- 📋 智能家居集成
- 📋 固件升级
- 📋 数据统计
- 📋 社交分享

---

## 📚 相关文档

- [架构设计](./ARCHITECTURE.md)
- [功能特性](./FEATURES.md)
- [开发指南](./DEVELOPMENT_GUIDE.md)
- [API 参考](./API_REFERENCE.md)
- [蓝牙协议](./BLUETOOTH_PROTOCOL.md)
- [数据模型](./DATA_MODELS.md)

---

## 🆘 获取帮助

### 技术支持
- 📧 邮箱：support@lynshae.dev
- 💬 Discord: [加入社区](https://discord.gg/lynshae)
- 🐛 Issues: [提交问题](https://github.com/lynshae/lynshae_app/issues)

### 学习资源
- [Flutter 官方文档](https://flutter.dev/docs)
- [Dart 语言指南](https://dart.dev/guides)
- [蓝牙开发指南](https://developer.android.com/guide/topics/connectivity/bluetooth)

---

*Last Updated: 2026-03-04 18:45*
