# 💻 开发指南

> 开发环境配置、编码规范和最佳实践

---

## 🚀 开发环境配置

### 系统要求

**操作系统**
- macOS 10.15+ (推荐 macOS 12+)
- Windows 10+ (64-bit)
- Linux (Ubuntu 20.04+)

**硬件要求**
- 内存：8GB+ (推荐 16GB)
- 硬盘：10GB+ 可用空间
- 屏幕分辨率：1920x1080+

### 软件安装

#### 1. 安装 Flutter

```bash
# macOS
brew install --cask flutter

# 或手动安装
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:$HOME/development/flutter/bin"

# 验证安装
flutter --version
flutter doctor
```

#### 2. 安装 Android Studio

```bash
# macOS
brew install --cask android-studio

# 配置 Android SDK
flutter doctor --android-licenses
```

#### 3. 安装 Xcode (macOS)

```bash
# App Store 安装 Xcode
# 安装命令行工具
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept

# 安装 CocoaPods
sudo gem install cocoapods
```

#### 4. 安装 VS Code 插件

推荐插件：
- Flutter
- Dart
- Flutter Widget Snippets
- Pubspec Assist
- Error Lens

---

## 📦 项目初始化

### 1. 克隆项目

```bash
git clone <repository_url>
cd lynshae_app
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 配置环境变量

创建 `.env` 文件（可选）：

```bash
# API 配置
API_BASE_URL=https://api.lynshae.dev
API_VERSION=v1

# 蓝牙配置
BLUETOOTH_TIMEOUT=30000
BLUETOOTH_RETRY=3
```

### 4. 运行项目

```bash
# 查看可用设备
flutter devices

# 运行到 Android
flutter run

# 运行到 iOS
flutter run

# 运行到 macOS
flutter run -d macos

# 指定设备运行
flutter run -d <device_id>

# 发布模式运行
flutter run --release
```

---

## 🔧 开发工作流

### 1. 代码编辑

```bash
# 打开项目
code .

# 或使用 Android Studio
open -a "Android Studio" .
```

### 2. 热重载

开发过程中使用热重载快速查看更改：

- 保存文件自动热重载
- 按 `r` 键手动热重载
- 按 `R` 键热重启

### 3. 调试

```bash
# 启动调试模式
flutter run --debug

# 查看日志
flutter logs

# 检查代码
flutter analyze

# 格式化代码
dart format .
```

### 4. 测试

```bash
# 运行所有测试
flutter test

# 运行单个测试文件
flutter test test/widget_test.dart

# 带覆盖率测试
flutter test --coverage

# 查看覆盖率
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 📝 编码规范

### Dart 代码规范

#### 命名规范

```dart
// 类名：大驼峰
class DeviceModel {}
class BluetoothService {}

// 变量和函数：小驼峰
int batteryLevel = 100;
void updateStatus() {}

// 常量：小写 + 下划线
const int max_speed = 100;
const String app_name = 'lynshae';

// 枚举：大驼峰
enum DeviceStatus { idle, moving, error }

// 文件命名：小写 + 下划线
// device_model.dart
// bluetooth_service.dart
```

#### 代码格式

```dart
// 使用 2 个空格缩进
class MyClass {
  void myMethod() {
    if (condition) {
      // do something
    }
  }
}

// 操作符两侧加空格
int result = a + b;
if (x == 10) {}

// 逗号后加空格
List<int> numbers = [1, 2, 3, 4];

// 括号前加空格
if (condition) {}
for (int i = 0; i < 10; i++) {}
```

#### 注释规范

```dart
/// 文档注释（用于类、方法）
/// 
/// 详细描述
/// 
/// 示例:
/// ```dart
/// var device = DeviceModel();
/// ```
class DeviceModel {
  /// 设备 ID
  final String id;
  
  /// 设备名称
  final String name;
  
  /// 获取设备状态
  /// 
  /// 返回当前设备的运行状态
  DeviceStatus getStatus() {
    // 实现代码
  }
}

// 单行注释
int count = 0; // 行尾注释
```

---

### Flutter 组件规范

#### 组件结构

```dart
import 'package:flutter/material.dart';

/// 设备信息卡片
/// 
/// 显示设备的基本信息，包括名称、状态、电量等
class DeviceCard extends StatelessWidget {
  /// 设备模型
  final DeviceModel device;
  
  /// 点击回调
  final VoidCallback? onTap;
  
  const DeviceCard({
    Key? key,
    required this.device,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildStatus(),
              _buildBattery(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Text(
      device.name,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
  
  Widget _buildStatus() {
    return Text(
      '状态：${device.status}',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
  
  Widget _buildBattery() {
    return LinearProgressIndicator(
      value: device.batteryLevel / 100,
    );
  }
}
```

#### 状态管理规范

```dart
import 'package:flutter/foundation.dart';

/// 设备状态提供者
class DeviceProvider extends ChangeNotifier {
  DeviceModel _device;
  
  DeviceModel get device => _device;
  
  DeviceProvider() : _device = DeviceModel.initial();
  
  /// 更新设备状态
  void updateStatus(DeviceStatus status) {
    _device = _device.copyWith(status: status);
    notifyListeners();
  }
  
  /// 更新电量
  void updateBattery(int level) {
    _device = _device.copyWith(batteryLevel: level);
    notifyListeners();
  }
  
  /// 更新模式
  void updateMode(DeviceMode mode) {
    _device = _device.copyWith(mode: mode);
    notifyListeners();
  }
}
```

---

## 🎨 UI 开发规范

### 主题使用

```dart
// 使用主题颜色
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: Theme.of(context).textTheme.headlineMedium,
  ),
)

// 使用自定义主题
Container(
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
)
```

### 响应式布局

```dart
// 使用 LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else {
      return TabletLayout();
    }
  },
)

// 使用 MediaQuery
final screenWidth = MediaQuery.of(context).size.width;
final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

// 使用 Flexible 和 Expanded
Row(
  children: [
    Expanded(
      flex: 2,
      child: Widget1(),
    ),
    Expanded(
      flex: 1,
      child: Widget2(),
    ),
  ],
)
```

---

## 🔌 蓝牙开发

### 连接流程

```dart
class BluetoothManager {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  
  /// 初始化蓝牙
  Future<void> initialize() async {
    await _bluetooth.openSettings();
  }
  
  /// 扫描设备
  Future<List<BluetoothDevice>> scanDevices() async {
    final List<BluetoothDevice> devices = [];
    
    try {
      await _bluetooth.startDiscovery().forEach((device) {
        devices.add(device);
      });
    } catch (e) {
      print('扫描失败：$e');
    }
    
    return devices;
  }
  
  /// 连接设备
  Future<bool> connect(BluetoothDevice device) async {
    try {
      final connection = await _bluetooth.connectToDevice(
        address: device.address,
      );
      return true;
    } catch (e) {
      print('连接失败：$e');
      return false;
    }
  }
  
  /// 发送数据
  Future<void> sendData(String data) async {
    try {
      await _bluetooth.write(data);
    } catch (e) {
      print('发送失败：$e');
    }
  }
}
```

---

## 💾 数据存储

### SharedPreferences

```dart
class StorageService {
  static SharedPreferences? _prefs;
  
  /// 初始化
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// 保存字符串
  static Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }
  
  /// 读取字符串
  static String? getString(String key) {
    return _prefs?.getString(key);
  }
  
  /// 保存整数
  static Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }
  
  /// 读取整数
  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }
  
  /// 保存布尔值
  static Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }
  
  /// 读取布尔值
  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }
  
  /// 清除所有
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
```

---

## 🧪 测试规范

### 单元测试

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lynshae_app/models/device_model.dart';

void main() {
  group('DeviceModel', () {
    test('should create initial device', () {
      final device = DeviceModel.initial();
      
      expect(device.name, '未命名设备');
      expect(device.batteryLevel, 100);
      expect(device.isConnected, false);
    });
    
    test('should update battery level', () {
      final device = DeviceModel.initial();
      final updated = device.copyWith(batteryLevel: 50);
      
      expect(updated.batteryLevel, 50);
      expect(device.batteryLevel, 100); // 原对象不变
    });
  });
}
```

### Widget 测试

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lynshae_app/screens/home_screen.dart';
import 'package:lynshae_app/providers/device_provider.dart';

void main() {
  testWidgets('HomeScreen displays device info', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => DeviceProvider(),
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    
    expect(find.text('设备状态'), findsOneWidget);
    expect(find.byType(DeviceCard), findsOneWidget);
  });
}
```

---

## 🐛 调试技巧

### 打印日志

```dart
// 使用 print
print('Debug: $value');

// 使用 debugPrint（长文本）
debugPrint('Long text: $longText');

// 使用 logger 包
final logger = Logger();
logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
```

### 断点调试

```dart
// 使用 debugger() 语句
import 'package:flutter/foundation.dart';

void myFunction() {
  debugger(); // 在此处中断
  // ... 代码
}
```

### 性能分析

```bash
# 启动性能分析
flutter run --profile

# 使用 DevTools
flutter pub global activate devtools
flutter pub global run devtools

# 或使用 VS Code 的 Flutter DevTools
```

---

## 📦 构建发布

### Android 发布

```bash
# 构建 APK
flutter build apk --release

# 构建 App Bundle
flutter build appbundle --release

# 签名配置
# android/app/build.gradle
android {
    signingConfigs {
        release {
            keyAlias 'lynshae'
            keyPassword 'your_password'
            storeFile file('lynshae.keystore')
            storePassword 'your_password'
        }
    }
}
```

### iOS 发布

```bash
# 构建 IPA
flutter build ios --release

# 在 Xcode 中 Archive
open ios/Runner.xcworkspace
# Product -> Archive
```

### macOS 发布

```bash
# 构建 App
flutter build macos --release

# 签名和公证
# 在 Xcode 中配置
```

---

## 📚 学习资源

### 官方文档
- [Flutter 官方文档](https://flutter.dev/docs)
- [Dart 语言指南](https://dart.dev/guides)
- [Flutter Cookbook](https://flutter.dev/cookbook)

### 视频教程
- [Flutter YouTube](https://www.youtube.com/c/flutterdev)
- [Bilibili Flutter 教程](https://search.bilibili.com/all?keyword=Flutter)

### 社区
- [Flutter 中文网](https://flutter.cn/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit - r/FlutterDev](https://www.reddit.com/r/FlutterDev/)

---

## 🆘 常见问题

### 1. 依赖冲突

```bash
flutter clean
flutter pub get
```

### 2. 构建失败

```bash
# Android
cd android && ./gradlew clean
cd ..
flutter clean
flutter pub get

# iOS
cd ios && pod deintegrate && pod install
cd ..
flutter clean
flutter pub get
```

### 3. 热重载不工作

- 确保使用 `flutter run` 启动
- 按 `r` 键手动热重载
- 检查是否有状态初始化代码

---

## 📚 相关文档

- [项目概述](./PROJECT_OVERVIEW.md)
- [架构设计](./ARCHITECTURE.md)
- [功能特性](./FEATURES.md)
- [API 参考](./API_REFERENCE.md)
- [数据模型](./DATA_MODELS.md)

---

*Last Updated: 2026-03-04 18:45*
