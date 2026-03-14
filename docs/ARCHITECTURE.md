# 🏗️ lynshae_app 架构设计

> 技术架构和模块设计详解

---

## 📐 系统架构

### 分层架构

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Home      │  │   Control   │  │   Bonding   │     │
│  │   Screen    │  │   Screen    │  │   Screen    │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│  ┌─────────────┐  ┌─────────────┐                       │
│  │  Device     │  │   Daily     │                       │
│  │   Card      │  │   Task      │                       │
│  │   Widget    │  │   Card      │                       │
│  └─────────────┘  └─────────────┘                       │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│                   State Management                      │
│  ┌─────────────────────────────────────────────────┐   │
│  │              Provider + ChangeNotifier          │   │
│  │  - DeviceProvider (设备状态)                     │   │
│  │  - InteractionProvider (互动系统)                 │   │
│  │  - SettingsProvider (设置)                       │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│                     Service Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │  Bluetooth  │  │   Storage   │  │    Utils    │     │
│  │   Service   │  │   Service   │  │   Service   │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│                      Data Layer                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Device    │  │   Bonding   │  │   Constants │     │
│  │    Model    │  │    Model    │  │             │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 核心模块

### 1. Presentation Layer (表现层)

#### Screens (屏幕)
- **HomeScreen** - 设备状态监控
- **ControlScreen** - 实时控制
- **BondingScreen** - 情感互动
- **SettingsScreen** - 应用设置

#### Widgets (组件)
- **DeviceCard** - 设备信息卡片
- **BondingProgressBar** - 互动进度条
- **DailyTaskCard** - 日常任务卡片
- **ModeSwitcher** - 模式切换器

### 2. State Management (状态管理)

#### Providers
```dart
// 设备状态管理
class DeviceProvider extends ChangeNotifier {
  DeviceModel _device;
  
  void updateStatus(DeviceStatus status);
  void updateMode(DeviceMode mode);
  void updateBattery(int level);
}

// 互动系统管理
class InteractionProvider extends ChangeNotifier {
  InteractionModel _interaction;

  void addExperience(int exp);
  void completeTask(String taskId);
  BondingLevel get currentLevel;
}
```

### 3. Service Layer (服务层)

#### BluetoothService
```dart
class BluetoothService {
  // 设备扫描
  Future<List<BluetoothDevice>> scanDevices();
  
  // 连接设备
  Future<bool> connect(BluetoothDevice device);
  
  // 断开连接
  Future<void> disconnect();
  
  // 发送命令
  Future<void> sendCommand(String command, Map<String, dynamic> params);
  
  // 接收数据
  Stream<BluetoothData> get dataStream;
}
```

#### StorageService
```dart
class StorageService {
  // 保存设备配置
  Future<void> saveDeviceConfig(DeviceConfig config);
  
  // 加载设备配置
  Future<DeviceConfig?> loadDeviceConfig();
  
  // 保存亲密度数据
  Future<void> saveBondingData(BondingData data);
  
  // 加载亲密度数据
  Future<BondingData?> loadBondingData();
}
```

### 4. Data Layer (数据层)

#### Models (数据模型)

**DeviceModel**
```dart
class DeviceModel {
  final String id;
  final String name;
  final DeviceStatus status;
  final DeviceMode mode;
  final int batteryLevel;
  final int signalStrength;
  final DateTime lastConnected;
  final bool isConnected;
}
```

**BondingModel**
```dart
class BondingModel {
  final int experience;
  final BondingLevel level;
  final List<DailyTask> tasks;
  final List<Achievement> achievements;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

---

## 🔄 数据流

### 设备控制流程

```
用户操作 → ControlScreen
    ↓
调用 Provider.update()
    ↓
Provider 通知 BluetoothService
    ↓
BluetoothService 发送命令
    ↓
设备执行并返回结果
    ↓
BluetoothService 接收响应
    ↓
Provider 更新状态
    ↓
UI 自动刷新
```

### 亲密度更新流程

```
完成任务 → BondingScreen
    ↓
调用 Provider.addExperience()
    ↓
更新 BondingModel
    ↓
检查等级提升
    ↓
保存到 StorageService
    ↓
UI 显示新等级和进度
```

---

## 📦 模块依赖关系

```
main.dart
  ↓
App (MaterialApp)
  ↓
├── AppTheme (主题)
├── AppConstants (常量)
└── AppRouter (路由)
      ↓
   Screens
      ↓
   Providers (状态管理)
      ↓
   Services (业务逻辑)
      ↓
   Models (数据)
```

---

## 🔌 蓝牙通信架构

### 连接管理

```dart
class BluetoothConnectionManager {
  // 单例模式
  static final BluetoothConnectionManager _instance = 
      BluetoothConnectionManager._internal();
  
  factory BluetoothConnectionManager() => _instance;
  
  // 当前连接
  BluetoothDevice? _connectedDevice;
  BluetoothConnection? _connection;
  
  // 连接状态
  ConnectionState _state = ConnectionState.disconnected;
}
```

### 命令协议

```dart
// 命令格式
class BluetoothCommand {
  final String action;        // 动作类型
  final Map<String, dynamic> parameters;  // 参数
  final int timestamp;        // 时间戳
  
  String toJson() => jsonEncode({
    'action': action,
    'params': parameters,
    'ts': timestamp,
  });
}

// 响应格式
class BluetoothResponse {
  final bool success;         // 是否成功
  final String? error;        // 错误信息
  final Map<String, dynamic>? data;  // 返回数据
  
  static BluetoothResponse fromJson(String json) {
    final map = jsonDecode(json);
    return BluetoothResponse(
      success: map['success'] ?? false,
      error: map['error'],
      data: map['data'],
    );
  }
}
```

### 数据包结构

```dart
// 发送数据包
class DataPacket {
  final int sequence;         // 序列号
  final String command;       // 命令
  final List<int> payload;    // 负载数据
  final int checksum;         // 校验和
  
  List<int> toBytes() {
    // 转换为字节数组
  }
}

// 接收数据包
class ReceivedPacket {
  final int sequence;
  final List<int> data;
  final int rssi;             // 信号强度
  
  bool isValid() {
    // 校验数据包
  }
}
```

---

## 💾 存储架构

### SharedPreferences 使用

```dart
// 键名常量
class StorageKeys {
  static const String deviceConfig = 'device_config';
  static const String bondingData = 'bonding_data';
  static const String userSettings = 'user_settings';
  static const String appPreferences = 'app_preferences';
}

// 数据序列化
class StorageSerializer {
  static String serializeDeviceConfig(DeviceConfig config) {
    return jsonEncode(config.toJson());
  }
  
  static DeviceConfig deserializeDeviceConfig(String json) {
    return DeviceConfig.fromJson(jsonDecode(json));
  }
}
```

### 数据结构

```dart
// 设备配置
class DeviceConfig {
  String deviceId;
  String deviceName;
  DeviceMode defaultMode;
  int maxSpeed;
  bool autoReconnect;
}

// 用户设置
class UserSettings {
  bool notifications;
  String language;
  ThemeMode theme;
  bool soundEffects;
}
```

---

## 🎨 UI 架构

### 组件层次

```
App
└── MaterialApp
    └── Navigator
        └── Screen
            ├── AppBar
            ├── Body
            │   ├── Provider Consumer
            │   └── Widget Tree
            └── BottomNavigationBar
```

### 状态更新机制

```dart
// 使用 Provider
class DeviceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Column(
            children: [
              Text('电量：${provider.device.batteryLevel}%'),
              Text('状态：${provider.device.status}'),
            ],
          ),
        );
      },
    );
  }
}
```

---

## 🔐 安全设计

### 权限管理

```dart
class PermissionManager {
  // 请求蓝牙权限
  static Future<bool> requestBluetoothPermission() async {
    final status = await Permission.bluetooth.request();
    return status.isGranted;
  }
  
  // 请求位置权限（Android 需要）
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }
}
```

### 数据加密

```dart
class DataEncryption {
  // 加密敏感数据
  static String encrypt(String data, String key) {
    // AES 加密实现
  }
  
  // 解密数据
  static String decrypt(String encryptedData, String key) {
    // AES 解密实现
  }
}
```

---

## 🚀 性能优化

### 1. 蓝牙通信优化

```dart
// 命令队列
class CommandQueue {
  final Queue<BluetoothCommand> _queue = Queue();
  bool _isProcessing = false;
  
  Future<void> enqueue(BluetoothCommand command) async {
    _queue.add(command);
    if (!_isProcessing) {
      await _processQueue();
    }
  }
  
  Future<void> _processQueue() async {
    _isProcessing = true;
    while (_queue.isNotEmpty) {
      final command = _queue.removeFirst();
      await _sendCommand(command);
    }
    _isProcessing = false;
  }
}
```

### 2. UI 渲染优化

```dart
// 使用 const 构造函数
const DeviceCard()

// 避免在 build 中创建对象
final _formatter = NumberFormat('0.0');

// 使用 RepaintBoundary
RepaintBoundary(
  child: CustomPaint(...),
)
```

### 3. 数据存储优化

```dart
// 批量保存
class BatchStorage {
  final Map<String, String> _cache = {};
  
  void set(String key, String value) {
    _cache[key] = value;
  }
  
  Future<void> commit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringMap(_cache);
    _cache.clear();
  }
}
```

---

## 📊 错误处理

### 全局错误处理

```dart
// Flutter 错误处理
FlutterError.onError = (FlutterErrorDetails details) {
  // 记录错误
  ErrorService.log(details);
  
  // 显示错误提示
  showErrorDialog(details.exception);
};

// Zone 错误处理
runZonedGuarded(() {
  runApp(MyApp());
}, (error, stack) {
  // 处理未捕获错误
  ErrorService.handle(error, stack);
});
```

### 蓝牙错误处理

```dart
class BluetoothErrorHandler {
  static void handleError(BluetoothError error) {
    switch (error.code) {
      case BluetoothErrorCode.deviceNotFound:
        showDeviceNotFoundDialog();
        break;
      case BluetoothErrorCode.connectionFailed:
        showConnectionFailedDialog();
        break;
      case BluetoothErrorCode.timeout:
        showTimeoutDialog();
        break;
      default:
        showGenericErrorDialog(error.message);
    }
  }
}
```

---

## 📈 扩展性设计

### 插件系统

```dart
// 插件接口
abstract class DevicePlugin {
  String get name;
  String get version;
  
  Future<void> initialize();
  Future<void> execute(Map<String, dynamic> params);
  Future<void> dispose();
}

// 插件管理器
class PluginManager {
  final Map<String, DevicePlugin> _plugins = {};
  
  void register(DevicePlugin plugin) {
    _plugins[plugin.name] = plugin;
  }
  
  Future<void> executePlugin(String name, Map<String, dynamic> params) async {
    final plugin = _plugins[name];
    if (plugin != null) {
      await plugin.execute(params);
    }
  }
}
```

---

## 📚 相关文档

- [项目概述](./PROJECT_OVERVIEW.md)
- [功能特性](./FEATURES.md)
- [开发指南](./DEVELOPMENT_GUIDE.md)
- [API 参考](./API_REFERENCE.md)
- [蓝牙协议](./BLUETOOTH_PROTOCOL.md)
- [数据模型](./DATA_MODELS.md)

---

*Last Updated: 2026-03-04 18:45*
