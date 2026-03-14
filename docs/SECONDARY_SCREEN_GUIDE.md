# 二级界面开发规范

本文档定义了灵羲 App 中所有二级界面的统一开发规范，确保视觉风格和交互体验的一致性。

---

## 1. 标准布局结构

### 1.1 基础模板

```dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common/components/app_navbar.dart';

class XxxScreen extends StatelessWidget {
  const XxxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkSurface,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            const AppNavbar(title: '页面标题', showNotification: false),
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(...),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 1.2 结构说明

| 层级 | 组件 | 说明 |
|------|------|------|
| 1 | `Scaffold` | 页面根组件 |
| 2 | `SafeArea` | 适配刘海屏/状态栏 |
| 3 | `Column` | 垂直布局容器 |
| 4 | `AppNavbar` | 导航栏（无 padding 包裹） |
| 4 | `Expanded` | 占据剩余空间 |
| 5 | `SingleChildScrollView` | 可滚动内容区 |
| 6 | `Column` | 内容容器 |

---

## 2. 导航栏规范 (AppNavbar)

### 2.1 组件位置

- 文件：`lib/common/components/app_navbar.dart`

### 2.2 样式参数

```dart
AppNavbar(
  title: '页面标题',              // 必填：页面标题
  showNotification: false,        // 可选：是否显示通知按钮，默认 true
  showScan: false,                // 可选：是否显示扫描按钮，默认 false
  trailing: Widget,               // 可选：右侧自定义组件
  onScanPressed: () {},           // 可选：扫描按钮回调
  onNotificationPressed: () {},   // 可选：通知按钮回调
)
```

### 2.3 视觉规格

| 元素 | 规格 |
|------|------|
| 返回按钮 | 40x40，圆角 12px，半透明白色背景 |
| 返回图标 | 24px，白色，`Icons.chevron_left_rounded` |
| 标题字体 | 20px，粗体，白色 |
| 右侧按钮 | 40x40，圆角 12px，图标 22px |
| 内边距 | `horizontal: 16, vertical: 12` |

### 2.4 使用示例

```dart
// 基础用法
const AppNavbar(title: '设备列表', showNotification: false),

// 带右侧编辑按钮
AppNavbar(
  title: '个人信息',
  showNotification: false,
  trailing: GestureDetector(
    onTap: _toggleEditMode,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '编辑',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryBlue,
        ),
      ),
    ),
  ),
),
```

---

## 3. 内容区域规范

### 3.1 Padding 标准

```dart
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
```

| 方向 | 值 | 说明 |
|------|------|------|
| horizontal | 16 | 左右边距，与导航栏对齐 |
| vertical | 16 | 顶部边距，底部可根据需要调整 |

### 3.2 卡片间距

```dart
const SizedBox(height: 16),  // 卡片之间标准间距
const SizedBox(height: 24),  // 大模块间距
const SizedBox(height: 80),  // 底部留白（最后一个元素后）
```

### 3.3 内容卡片

使用 `SettingsCard` 和 `SettingsTile` 组件构建设置列表：

```dart
SettingsCard(
  children: [
    SettingsTile(
      icon: Icons.devices_rounded,
      title: '设备通知',
      subtitle: '设备状态、电量提醒',
      showSwitch: true,
      switchValue: _enabled,
      onSwitchChanged: _toggleSwitch,
    ),
    SettingsTile(
      icon: Icons.storefront_rounded,
      title: '商城通知',
      trailing: Text('已开启'),
      onTap: () => Navigator.push(...),
    ),
  ],
),
```

---

## 4. 通用组件规范

### 4.1 SettingsTile

- 文件：`lib/common/components/settings_tile.dart`

#### 参数说明

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `icon` | IconData | 必填 | 左侧图标 |
| `title` | String | 必填 | 主标题 |
| `subtitle` | String? | null | 副标题 |
| `iconBackgroundColor` | Color? | null | 图标背景色 |
| `iconColor` | Color? | null | 图标颜色 |
| `iconSize` | double? | 22 | 图标尺寸 |
| `iconContainerSize` | double? | 40 | 图标容器尺寸 |
| `showSwitch` | bool | false | 是否显示 Switch |
| `switchValue` | bool? | null | Switch 值 |
| `onSwitchChanged` | Function(bool)? | null | Switch 回调 |
| `trailing` | Widget? | null | 右侧自定义组件 |
| `showArrow` | bool | true | 是否显示右箭头 |
| `onTap` | VoidCallback? | null | 点击回调 |
| `showDivider` | bool | true | 是否显示分割线 |

#### 使用示例

```dart
// 带 Switch
SettingsTile(
  icon: Icons.notifications,
  title: '通知',
  showSwitch: true,
  switchValue: true,
  onSwitchChanged: (v) => setState(() => _enabled = v),
),

// 带右侧文字
SettingsTile(
  icon: Icons.time,
  title: '开始时间',
  trailing: Text('22:00'),
  onTap: () => _selectTime(),
),

// 带箭头
SettingsTile(
  icon: Icons.info,
  title: '关于',
  subtitle: '版本信息',
  onTap: () => Navigator.push(...),
),
```

### 4.2 SettingsCard

- 文件：`lib/common/components/settings_tile.dart`

自动处理最后一个孩子的分割线，提供统一的背景色和圆角。

```dart
SettingsCard(
  children: [...],  // SettingsTile 列表
)
```

---

## 5. 颜色规范

### 5.1 主题色

| 用途 | 颜色值 | 代码 |
|------|--------|------|
| 页面背景 | `#1A1A2E` | `AppTheme.darkSurface` |
| 卡片背景 | `#1E293B` | `const Color(0xFF1E293B)` |
| 主色调 | `#2B7FFF` | `AppTheme.primaryBlue` |
| 强调色 | `#FF6B35` | `AppTheme.accentOrange` |
| 成功色 | `#00C853` | `AppTheme.successGreen` |

### 5.2 透明度使用

```dart
Colors.white.withAlpha(15)   // 15/255 ≈ 6% 透明度，用于图标背景
Colors.white.withAlpha(20)   // 20/255 ≈ 8% 透明度
Colors.white.withAlpha(10)   // 10/255 ≈ 4% 透明度，用于分割线
AppTheme.primaryBlue.withAlpha(40)  // 40/255 ≈ 16% 透明度
AppTheme.primaryBlue.withAlpha(80)  // 80/255 ≈ 31% 透明度，用于 Switch 背景
```

### 5.3 文字颜色

| 用途 | 颜色 |
|------|------|
| 主标题 | `Colors.white` |
| 副标题 | `Colors.white30` (30% 白) |
| 次要文字 | `Colors.white54` (54% 白) |
| 提示文字 | `Colors.white70` (70% 白) |

---

## 6. 交互规范

### 6.1 点击反馈

```dart
import '../../utils/app_utils.dart';

GestureDetector(
  onTap: () {
    AppUtils.vibrate();  // 震动反馈
    // 业务逻辑
  },
  behavior: HitTestBehavior.opaque,  // 确保点击区域有效
  child: ...
)
```

### 6.2 提示信息

```dart
// 成功提示
AppUtils.showSuccess(context, '操作成功');

// 错误提示
AppUtils.showError(context, '操作失败');

// 信息提示
AppUtils.showInfo(context, '功能开发中');
```

---

## 7. 状态保持规范

### 7.1 设置存储

使用 `UserSettingsService` 存储用户设置：

```dart
import '../services/user_settings_service.dart';

// 读取
final enabled = await UserSettingsService.isDeviceNotificationsEnabled();

// 保存
await UserSettingsService.setDeviceNotificationsEnabled(true);
```

### 7.2 初始化加载

```dart
class _XxxScreenState extends State<XxxScreen> {
  bool _isLoading = true;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    _enabled = await UserSettingsService.isXxxEnabled();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(...),
      );
    }
    return ...;
  }
}
```

---

## 8. 完整示例

```dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../common/components/app_navbar.dart';
import '../../common/components/settings_tile.dart';
import '../../services/user_settings_service.dart';

/// 示例页面
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  bool _enabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    _enabled = await UserSettingsService.isDeviceNotificationsEnabled();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleEnabled(bool value) async {
    setState(() => _enabled = value);
    await UserSettingsService.setDeviceNotificationsEnabled(value);
    AppUtils.vibrate();
    if (mounted && !value) {
      AppUtils.showSuccess(context, '已关闭');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkSurface,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                ),
              )
            : Column(
                children: [
                  // 顶部导航栏
                  const AppNavbar(
                    title: '示例页面',
                    showNotification: false,
                  ),
                  // 内容区域
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          SettingsCard(
                            children: [
                              SettingsTile(
                                icon: Icons.example,
                                iconBackgroundColor: AppTheme.primaryBlue.withAlpha(40),
                                iconColor: AppTheme.primaryBlue,
                                title: '示例设置',
                                subtitle: '说明文字',
                                showSwitch: true,
                                switchValue: _enabled,
                                onSwitchChanged: _toggleEnabled,
                                showArrow: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
```

---

## 9. 检查清单

在提交二级界面前，请确认：

- [ ] 使用了 `AppNavbar` 组件
- [ ] 导航栏无 `const` 修饰（除非是纯常量）
- [ ] 内容区域使用 `Expanded` + `SingleChildScrollView`
- [ ] padding 使用 `symmetric(horizontal: 16, vertical: 16)`
- [ ] 使用了 `SettingsCard` 和 `SettingsTile` 组件
- [ ] 点击事件有 `AppUtils.vibrate()` 反馈
- [ ] 异步操作有 `mounted` 检查
- [ ] 底部有适当留白（`SizedBox(height: 80)`）

---

## 10. 常见错误

### 错误 1：导航栏被 padding 包裹

```dart
// ❌ 错误
SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      const AppNavbar(...),  // 导航栏也被 padding 影响
      ...
    ],
  ),
)

// ✅ 正确
Column(
  children: [
    const AppNavbar(...),  // 导航栏独立
    Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(...),
      ),
    ),
  ],
)
```

### 错误 2：缺少 Expanded

```dart
// ❌ 错误
Column(
  children: [
    const AppNavbar(...),
    SingleChildScrollView(...),  // 没有 Expanded，无法占据剩余空间
  ],
)

// ✅ 正确
Column(
  children: [
    const AppNavbar(...),
    Expanded(
      child: SingleChildScrollView(...),
    ),
  ],
)
```

### 错误 3：异步操作缺少 mounted 检查

```dart
// ❌ 错误
Future<void> _loadData() async {
  final data = await fetchData();
  setState(() => _data = data);  // 可能页面已销毁
}

// ✅ 正确
Future<void> _loadData() async {
  final data = await fetchData();
  if (mounted) {
    setState(() => _data = data);
  }
}
```

---

*最后更新：2026-03-14*
