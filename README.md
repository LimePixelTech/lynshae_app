# 🏠 lynshae_app

[![Flutter](https://img.shields.io/badge/Flutter-3.41.3-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.1-blue.svg)](https://dart.dev)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20macOS-green.svg)](https://flutter.dev)

---

## ✨ 设计特色

### 🎨 液态玻璃质感 (Liquid Glass)

本应用采用独特的液态玻璃设计语言，营造通透、轻盈的视觉体验：

- **背景模糊** - BackdropFilter 实现毛玻璃效果
- **半透明层级** - 精准控制透明度营造深度感
- **细腻边框** - 0.5px 高光边框勾勒轮廓
- **柔和阴影** - 弥散投影增强悬浮感
- **流畅动效** - 200-300ms 缓动曲线

### 🌓 双主题系统

| 主题 | 特点 | 使用场景 |
|------|------|----------|
| **浅色模式** | 简约白灰配色，清新明亮 | 日间使用 |
| **深色模式** | 高级深色背景，护眼舒适 | 夜间使用 |

---

## 🧩 组件系统

### 核心组件库 (lib/widgets/)

| 组件 | 用途 | 特性 |
|------|------|------|
| **GlassContainer** | 玻璃容器 | 毛玻璃效果，自动适配主题 |
| **AppText** | 文字组件 | 统一排版层级，自动颜色 |
| **AppButton** | 按钮组件 | 多种类型，支持主题切换 |
| **AppListTile** | 列表项 | 统一列表样式，支持图标 |
| **Toast** | 轻提示 | 顶部浮现，自动消失 |
| **Alert** | 对话框 | 多种类型，玻璃背景 |

### 主题系统 (lib/theme/)

```dart
// 品牌色
primaryBlue = Color(0xFF007AFF)      // 科技蓝
accentOrange = Color(0xFFFF9500)     // 活力橙
successGreen = Color(0xFF34C759)     // 成功绿
warningYellow = Color(0xFFFFCC00)    // 警告黄
errorRed = Color(0xFFFF3B30)         // 错误红

// 深色模式专用
darkSurface = Color(0xFF000000)      // 深色背景
darkElevated = Color(0xFF1C1C1E)     // 深色浮层
glassDark = Color(0x15FFFFFF)        // 深色玻璃

// 浅色模式玻璃
glassLight = Color(0x40FFFFFF)       // 浅色玻璃
```

---

## 📱 界面预览

### 首页 (HomeScreen)
- 设备状态卡片
- 快捷操作按钮
- 实时数据显示

### 智能页 (SmartScreen)
- 场景模式（起床、睡眠、离家、回家等）
- 快捷操作（全部开启/关闭、亮度调节等）
- 自动化规则

### 设置页 (SettingsScreen)
- 主题切换
- 消息通知
- 语言设置
- 账号安全

### 我的页 (ProfileScreen)
- 用户信息
- 统计数据
- 关于应用
- 退出登录

---

## 🏗️ 项目结构

```
lib/
├── main.dart                     # 应用入口
├── theme/
│   └── app_theme.dart            # 主题配置（双主题系统）
├── screens/
│   ├── main_screen.dart          # 主屏幕（含底部导航）
│   ├── home_screen.dart          # 首页
│   ├── smart_screen.dart         # 智能页
│   ├── settings_screen.dart      # 设置页
│   └── profile_screen.dart       # 我的页
├── widgets/
│   ├── widgets.dart              # 组件统一导出
│   ├── glass_container.dart      # 玻璃容器组件
│   ├── app_text.dart             # 文字组件
│   ├── app_button.dart           # 按钮组件
│   ├── app_list_tile.dart        # 列表项组件
│   ├── app_toast.dart            # Toast轻提示
│   └── app_alert.dart            # Alert对话框
├── utils/
│   └── app_utils.dart            # 工具函数
└── services/
    └── storage_service.dart      # 存储服务
```

---

## 🚀 快速开始

### 环境要求

- Flutter >= 3.41.3
- Dart >= 3.11.1
- Android SDK >= 21
- iOS >= 12.0

### 安装步骤

```bash
# 克隆项目
git clone https://github.com/freakz3z/lynshae_app.git
cd lynshae_app

# 获取依赖
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

## 🎨 设计规范

### 颜色使用

```dart
// 获取当前主题色
final isDark = Theme.of(context).brightness == Brightness.dark;

// 使用主题色
AppTheme.primaryBlue           // 主色调
AppTheme.gray800               // 深色文字（浅色模式）
AppTheme.darkTextPrimary       // 主要文字（深色模式）

// 使用玻璃色
GlassContainer(
  color: isDark ? AppTheme.glassDark : AppTheme.glassLight,
  borderColor: isDark ? AppTheme.glassDarkBorder : AppTheme.glassLightBorder,
)
```

### 文字层级

| 层级 | 组件 | 字号 | 用途 |
|------|------|------|------|
| Display | AppTextDisplayLarge | 32 | 页面大标题 |
| Headline | AppTextHeadline | 20 | 区块标题 |
| Title | AppTextTitle | 17 | 卡片标题 |
| Body | AppTextBody | 16 | 正文内容 |
| Caption | AppTextCaption | 12 | 辅助说明 |
| Overline | AppTextOverline | 11 | 标签文字 |

---

## 🛠️ 开发指南

### 创建玻璃卡片

```dart
GlassContainer(
  padding: const EdgeInsets.all(16),
  borderRadius: 16,
  child: Column(
    children: [
      AppTextTitle('标题'),
      AppTextBody('内容'),
    ],
  ),
)
```

### 显示 Toast 提示

```dart
// 成功提示
Toast.success(context, '操作成功');

// 错误提示
Toast.error(context, '操作失败');

// 警告提示
Toast.warning(context, '请检查输入');

// 信息提示
Toast.info(context, '功能开发中');
```

### 显示 Alert 对话框

```dart
// 确认对话框
final result = await AppAlert.confirm(
  context,
  title: '确认删除',
  message: '确定要删除该设备吗？',
);
```

### 振动反馈

```dart
// 轻振动
AppUtils.vibrate();

// 重振动
AppUtils.vibrateStrong();
```

---

## 🔄 更新日志

### v1.0.0 - 2026-03-09

**重构主题系统**
- 新增双主题系统（浅色/深色）
- 新增灰阶色系
- 新增玻璃质感配色

**新增组件库**
- GlassContainer - 玻璃容器
- AppText - 文字组件
- AppButton - 按钮组件
- AppListTile - 列表项
- Toast - 轻提示
- Alert - 对话框