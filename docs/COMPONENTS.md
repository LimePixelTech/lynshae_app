# 可复用组件文档

本文档记录了灵羲应用中的可复用组件，方便开发时查阅和使用。

---

## 目录

- [通用组件](#通用组件)
  - [AppNavbar](#appnavbar)
  - [SettingsTile & SettingsCard](#settingstile--settingscard)
- [工具类](#工具类)
  - [AppUtils](#apputils)
- [主题系统](#主题系统)
  - [AppTheme](#apptheme)
- [Widget 组件](#widget 组件)
  - [通用 Widget](#通用 widget)
  - [设备相关](#设备相关)
  - [交互相关](#交互相关)

---

## 通用组件

### AppNavbar

**二级界面通用导航栏组件**

用于所有二级页面的顶部导航栏，保持统一的视觉风格。

**文件路径**: `lib/common/components/app_navbar.dart`

**使用示例**:
```dart
AppNavbar(
  title: '页面标题',
  showScan: true,
  onScanPressed: () => print('扫描'),
  trailing: Text('编辑'),
)
```

**属性说明**:

| 属性 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `title` | `String` | ✓ | - | 页面标题 |
| `showScan` | `bool` | ✗ | `false` | 是否显示扫描二维码按钮 |
| `showNotification` | `bool` | ✗ | `true` | 是否显示通知按钮 |
| `onScanPressed` | `VoidCallback?` | ✗ | - | 扫描按钮点击回调 |
| `onNotificationPressed` | `VoidCallback?` | ✗ | - | 通知按钮点击回调 |
| `trailing` | `Widget?` | ✗ | - | 右侧自定义组件（如编辑按钮） |

**设计特点**:
- 返回按钮：40x40 圆角容器，内含 `chevron_left` 图标
- 标题：20px 粗体白色文字
- 右侧按钮：40x40 圆角容器，半透明背景
- 支持自定义 `trailing` 组件，用于编辑等特殊操作

---

### SettingsTile & SettingsCard

**通用设置项组件**

用于构建设置列表中的单个项目，支持图标、标题、副标题、右箭头等。

**文件路径**: `lib/common/components/settings_tile.dart`

**使用示例**:
```dart
SettingsCard(
  children: [
    SettingsTile(
      icon: Icons.info_outline,
      title: '检查更新',
      subtitle: '当前版本 v1.0.0',
      onTap: () => _checkForUpdate(),
    ),
    SettingsTile(
      icon: Icons.delete_outline,
      title: '清除缓存',
      subtitle: '释放存储空间',
      trailing: Text('24MB'),
      onTap: _clearCache,
    ),
  ],
)
```

#### SettingsTile 属性说明:

| 属性 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `icon` | `IconData` | ✓ | - | 左侧图标 |
| `iconBackgroundColor` | `Color?` | ✗ | `Colors.white.withAlpha(15)` | 图标背景颜色 |
| `iconColor` | `Color?` | ✗ | `Colors.white` | 图标颜色 |
| `title` | `String` | ✓ | - | 主标题 |
| `subtitle` | `String?` | ✗ | - | 副标题 |
| `trailing` | `Widget?` | ✗ | - | 右侧自定义内容（Switch、Text 等） |
| `showArrow` | `bool` | ✗ | `true` | 是否显示右箭头 |
| `onTap` | `VoidCallback?` | ✗ | - | 点击回调 |
| `showDivider` | `bool` | ✗ | `true` | 是否显示分割线 |
| `dividerIndent` | `double?` | ✗ | `68` | 分割线缩进 |

#### SettingsCard 属性说明:

| 属性 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `children` | `List<Widget>` | ✓ | - | 子组件列表（SettingsTile） |
| `padding` | `double` | ✗ | `16` | 卡片边距 |

**设计特点**:
- 统一的圆角背景 (`24px`)
- 自动处理最后一个项目的分割线
- 深色背景色 `#1E293B`

---

## 工具类

### AppUtils

**工具函数集合**

提供应用中常用的工具函数。

**文件路径**: `lib/utils/app_utils.dart`

**使用示例**:
```dart
// 显示加载中
AppUtils.showLoading(context);

// 显示成功提示
AppUtils.showSuccess(context, '操作成功');

// 振动反馈
AppUtils.vibrate();

// 获取电量状态
final status = AppUtils.getBatteryStatus(75);
```

#### 方法说明:

**时间格式化**:
- `formatTime(DateTime time)` → `String` - 格式化为 HH:mm
- `formatDate(DateTime time)` → `String` - 格式化为 yyyy-MM-dd
- `formatRelativeTime(DateTime time)` → `String` - 相对时间（刚刚、5 分钟前）

**加载提示**:
- `showLoading(BuildContext context, {String message})` - 显示加载（毛玻璃风格）
- `hideLoading(BuildContext context)` - 隐藏加载

**Toast 提示**:
- `showSuccess(BuildContext context, String message)` - 成功提示
- `showError(BuildContext context, String message)` - 错误提示
- `showWarning(BuildContext context, String message)` - 警告提示
- `showInfo(BuildContext context, String message)` - 信息提示

**对话框**:
- `showConfirmDialog(BuildContext context, {title, message, confirmText, cancelText})` - 确认对话框

**振动反馈**:
- `vibrate({Duration duration})` - 轻振动
- `vibrateStrong()` - 强烈振动
- `vibrateSelection()` - 选择振动

**电量相关**:
- `getBatteryStatus(int level)` → `String` - 电量状态（充足/良好/一般/低电量）
- `getBatteryColor(int level)` → `Color` - 电量颜色（绿/黄/红）

---

## 主题系统

### AppTheme

**米家风格主题配置**

**文件路径**: `lib/theme/app_theme.dart`

#### 品牌色

| 颜色名 | 色值 | 用途 |
|--------|------|------|
| `primaryBlue` | `#3B7CFF` | 主色调、按钮 |
| `primaryBlueDark` | `#2A5FCC` | 主色调深色 |
| `accentOrange` | `#FF6B35` | 强调色 |
| `accentPink` | `#FF4081` | 强调色 |
| `accentCyan` | `#00C6FF` | 强调色 |
| `accentTeal` | `#00D4AA` | 强调色 |
| `successGreen` | `#34D399` | 成功状态、开关 |
| `warningYellow` | `#FBBF24` | 警告状态 |
| `errorRed` | `#EF4444` | 错误状态 |

#### 深色模式颜色

| 颜色名 | 色值 | 用途 |
|--------|------|------|
| `darkSurface` | `#0F172A` | 主背景 |
| `darkCard` | `#1E293B` | 卡片背景 |
| `darkElevated` | `#334155` | 悬浮卡片 |
| `darkBorder` | `#475569` | 边框色 |
| `darkTextPrimary` | `#F1F5F9` | 主文字 |
| `darkTextSecondary` | `#94A3B8` | 副文字 |

#### 玻璃质感配色

| 颜色名 | 用途 |
|--------|------|
| `glassLight` | 浅色模式毛玻璃 |
| `glassLightBorder` | 浅色模式毛玻璃边框 |
| `glassDark` | 深色模式毛玻璃 |
| `glassDarkBorder` | 深色模式毛玻璃边框 |

#### 使用方法

```dart
// 获取主题色
Container(
  color: AppTheme.primaryBlue,
  decoration: BoxDecoration(
    gradient: AppTheme.primaryGradient,
  ),
)

// 使用深色主题
Theme.of(context)
```

---

## Widget 组件

### 通用 Widget

#### TimerButton
**通用定时器按钮**
- 文件：`lib/widgets/common_widgets.dart`
- 属性：`label`, `icon`, `onTap`

#### AlarmListItem
**闹钟列表项**
- 文件：`lib/widgets/common_widgets.dart`
- 属性：`time`, `label`, `enabled`, `onChanged`

#### FPVArea
**FPV 视频区域**
- 文件：`lib/widgets/common_widgets.dart`
- 属性：`statusText`, `customContent`

#### ClockDisplay
**时间显示组件**
- 文件：`lib/widgets/common_widgets.dart`
- 属性：`time`, `date`

### 设备相关

#### ProductCard
**产品卡片** - `lib/widgets/product_card.dart`

#### DeviceCard
**设备状态卡片** - `lib/widgets/device_card.dart`

#### StatusCard
**状态卡片** - `lib/widgets/status_card.dart`

#### StatusIndicator
**状态指示器** - `lib/widgets/status_indicator.dart`

### 交互相关

#### JoystickWidget
**虚拟摇杆** - `lib/widgets/joystick_widget.dart`

#### ActionButton
**动作按钮** - `lib/widgets/action_button.dart`

#### ActionCircleButton
**圆形动作按钮** - `lib/widgets/action_circle_button.dart`

#### AppSlider
**滑块控件** - `lib/widgets/app_slider.dart`

#### AppButton
**通用按钮** - `lib/widgets/app_button.dart`

#### AppText
**通用文本** - `lib/widgets/app_text.dart`

#### AppListTile
**通用列表项** - `lib/widgets/app_list_tile.dart`

### 羁绊系统相关

#### BondingProgressBar
**羁绊进度条** - `lib/widgets/bonding_progress_bar.dart`

#### DailyTaskCard
**每日任务卡片** - `lib/widgets/daily_task_card.dart`

### 其他

#### GlassContainer
**毛玻璃容器** - `lib/widgets/glass_container.dart`

#### SectionTitle
**章节标题** - `lib/widgets/section_title.dart`

---

## 组件使用规范

### 1. 导航栏规范

**一级主界面**（首页、智能、商城、我的）:
- 直接在 `build` 方法中返回 `Row`
- 使用 `mainAxisAlignment: MainAxisAlignment.spaceBetween`
- 标题字号 `28px`，粗体
- 右侧按钮使用 `_buildHeaderIcon()` 辅助方法
- 不需要返回按钮

**二级界面**:
- 使用 `AppNavbar` 组件
- 标题字号 `20px`，粗体
- 自动包含返回按钮
- 可通过 `trailing` 添加自定义按钮

### 2. 间距规范

一级主界面的标准间距：
```dart
Column(
  children: [
    const SizedBox(height: 12),  // 顶部到标题的间距
    _buildHeader(),
    const SizedBox(height: 12),  // 标题到内容的间距
    // 内容区域...
    const SizedBox(height: 20),  // 内容区块间距
  ],
)
```

### 3. 颜色使用规范

- **主背景**: 使用主题渐变 `AppTheme.miBackgroundGradient`
- **卡片**: `Color(0xFF1E293B)` (深色模式卡片)
- **成功**: `AppTheme.successGreen`
- **警告**: `AppTheme.warningYellow`
- **错误**: `AppTheme.errorRed`
- **半透明背景**: `Colors.white.withAlpha(15)` ~ `Colors.white.withAlpha(30)`

### 4. 圆角规范

- **大卡片**: `BorderRadius.circular(24)`
- **中等容器**: `BorderRadius.circular(20)`
- **按钮/输入框**: `BorderRadius.circular(16)`
- **图标容器**: `BorderRadius.circular(12)`
- **小标签**: `BorderRadius.circular(8)`

### 5. 振动反馈规范

- 轻操作（点击、切换）：`AppUtils.vibrate()`
- 重要操作（删除、确认）：`AppUtils.vibrateStrong()`
- 滑动选择：`AppUtils.vibrateSelection()`

---

## 更新记录

### 2026-03-14
- **AppNavbar**: 统一二级界面导航栏
- **SettingsTile**: 支持 trailing 自定义组件
- **ProfileScreen**: 修复标题对齐问题
- **MallScreen**: 调整右上角按钮数量

### 待添加
- 更多 Widget 组件文档
- 动画组件文档
- 数据模型文档
