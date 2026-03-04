# 📊 数据模型

> 完整的数据模型定义和使用说明

---

## 📱 DeviceModel (设备模型)

### 类定义

```dart
/// 设备状态枚举
enum DeviceStatus {
  idle,       // 空闲
  moving,     // 移动中
  executing,  // 执行动作
  charging,   // 充电中
  sleeping,   // 休眠
  error       // 错误
}

/// 设备模式枚举
enum DeviceMode {
  companion,  // 陪伴模式
  patrol,     // 巡逻模式
  follow,     // 跟随模式
  sleep       // 休眠模式
}

/// 设备数据模型
class DeviceModel {
  /// 设备唯一标识
  final String id;
  
  /// 设备名称
  final String name;
  
  /// 设备状态
  final DeviceStatus status;
  
  /// 设备模式
  final DeviceMode mode;
  
  /// 电量百分比 (0-100)
  final int batteryLevel;
  
  /// 信号强度 (dBm)
  final int signalStrength;
  
  /// 是否已连接
  final bool isConnected;
  
  /// 最后连接时间
  final DateTime? lastConnected;
  
  /// 固件版本
  final String firmwareVersion;
  
  /// 蓝牙地址
  final String bluetoothAddress;

  const DeviceModel({
    required this.id,
    this.name = '未命名设备',
    this.status = DeviceStatus.idle,
    this.mode = DeviceMode.companion,
    this.batteryLevel = 100,
    this.signalStrength = -70,
    this.isConnected = false,
    this.lastConnected,
    this.firmwareVersion = '1.0.0',
    this.bluetoothAddress = '',
  });

  /// 创建初始设备实例
  factory DeviceModel.initial() {
    return DeviceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// 从 JSON 创建
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '未命名设备',
      status: DeviceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DeviceStatus.idle,
      ),
      mode: DeviceMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => DeviceMode.companion,
      ),
      batteryLevel: json['battery_level'] ?? 100,
      signalStrength: json['signal_strength'] ?? -70,
      isConnected: json['is_connected'] ?? false,
      lastConnected: json['last_connected'] != null
          ? DateTime.parse(json['last_connected'])
          : null,
      firmwareVersion: json['firmware_version'] ?? '1.0.0',
      bluetoothAddress: json['bluetooth_address'] ?? '',
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status.name,
      'mode': mode.name,
      'battery_level': batteryLevel,
      'signal_strength': signalStrength,
      'is_connected': isConnected,
      'last_connected': lastConnected?.toIso8601String(),
      'firmware_version': firmwareVersion,
      'bluetooth_address': bluetoothAddress,
    };
  }

  /// 复制并修改
  DeviceModel copyWith({
    String? id,
    String? name,
    DeviceStatus? status,
    DeviceMode? mode,
    int? batteryLevel,
    int? signalStrength,
    bool? isConnected,
    DateTime? lastConnected,
    String? firmwareVersion,
    String? bluetoothAddress,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      signalStrength: signalStrength ?? this.signalStrength,
      isConnected: isConnected ?? this.isConnected,
      lastConnected: lastConnected ?? this.lastConnected,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      bluetoothAddress: bluetoothAddress ?? this.bluetoothAddress,
    );
  }

  /// 获取状态描述
  String get statusDescription {
    switch (status) {
      case DeviceStatus.idle:
        return '空闲';
      case DeviceStatus.moving:
        return '移动中';
      case DeviceStatus.executing:
        return '执行动作';
      case DeviceStatus.charging:
        return '充电中';
      case DeviceStatus.sleeping:
        return '休眠';
      case DeviceStatus.error:
        return '错误';
    }
  }

  /// 获取模式描述
  String get modeDescription {
    switch (mode) {
      case DeviceMode.companion:
        return '陪伴模式';
      case DeviceMode.patrol:
        return '巡逻模式';
      case DeviceMode.follow:
        return '跟随模式';
      case DeviceMode.sleep:
        return '休眠模式';
    }
  }

  /// 获取电量状态
  String get batteryStatus {
    if (batteryLevel >= 80) return '充足';
    if (batteryLevel >= 50) return '良好';
    if (batteryLevel >= 20) return '较低';
    return '需要充电';
  }

  /// 获取信号质量
  String get signalQuality {
    if (signalStrength >= -50) return '优秀';
    if (signalStrength >= -60) return '良好';
    if (signalStrength >= -70) return '一般';
    if (signalStrength >= -80) return '较差';
    return '很差';
  }
}
```

---

## 💕 BondingModel (亲密度模型)

### 类定义

```dart
/// 亲密度等级枚举
enum BondingLevel {
  stranger,      // 初识 (0-100)
  acquaintance,  // 熟悉 (101-300)
  trusted,       // 信赖 (301-600)
  close,         // 亲密 (601-1000)
  soulmate       // 灵魂伴侣 (1001+)
}

/// 日常任务
class DailyTask {
  final String id;
  final String title;
  final String description;
  final int experienceReward;
  final bool isCompleted;
  final DateTime? completedAt;
  final String type; // interaction, exercise, training, etc.

  const DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.experienceReward,
    this.isCompleted = false,
    this.completedAt,
    required this.type,
  });

  DailyTask copyWith({
    String? id,
    String? title,
    String? description,
    int? experienceReward,
    bool? isCompleted,
    DateTime? completedAt,
    String? type,
  }) {
    return DailyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      experienceReward: experienceReward ?? this.experienceReward,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      type: type ?? this.type,
    );
  }
}

/// 成就
class Achievement {
  final String id;
  final String title;
  final String description;
  final int experienceReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String iconPath;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.experienceReward,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.iconPath,
  });
}

/// 亲密度数据模型
class BondingModel {
  /// 当前经验值
  final int experience;
  
  /// 当前等级
  final BondingLevel level;
  
  /// 日常任务列表
  final List<DailyTask> tasks;
  
  /// 成就列表
  final List<Achievement> achievements;
  
  /// 创建时间
  final DateTime createdAt;
  
  /// 更新时间
  final DateTime updatedAt;
  
  /// 总互动次数
  final int totalInteractions;
  
  /// 连续签到天数
  final int consecutiveDays;

  const BondingModel({
    this.experience = 0,
    this.level = BondingLevel.stranger,
    this.tasks = const [],
    this.achievements = const [],
    required this.createdAt,
    required this.updatedAt,
    this.totalInteractions = 0,
    this.consecutiveDays = 0,
  });

  /// 创建初始实例
  factory BondingModel.initial() {
    return BondingModel(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// 从 JSON 创建
  factory BondingModel.fromJson(Map<String, dynamic> json) {
    return BondingModel(
      experience: json['experience'] ?? 0,
      level: BondingLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => BondingLevel.stranger,
      ),
      tasks: (json['tasks'] as List?)
              ?.map((t) => DailyTask.fromJson(t))
              .toList() ??
          [],
      achievements: (json['achievements'] as List?)
              ?.map((a) => Achievement.fromJson(a))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      totalInteractions: json['total_interactions'] ?? 0,
      consecutiveDays: json['consecutive_days'] ?? 0,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'experience': experience,
      'level': level.name,
      'tasks': tasks.map((t) => t.toJson()).toList(),
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'total_interactions': totalInteractions,
      'consecutive_days': consecutiveDays,
    };
  }

  /// 复制并修改
  BondingModel copyWith({
    int? experience,
    BondingLevel? level,
    List<DailyTask>? tasks,
    List<Achievement>? achievements,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalInteractions,
    int? consecutiveDays,
  }) {
    return BondingModel(
      experience: experience ?? this.experience,
      level: level ?? this.level,
      tasks: tasks ?? this.tasks,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalInteractions: totalInteractions ?? this.totalInteractions,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
    );
  }

  /// 添加经验值
  BondingModel addExperience(int exp) {
    final newExp = experience + exp;
    final newLevel = _calculateLevel(newExp);
    
    return copyWith(
      experience: newExp,
      level: newLevel,
      updatedAt: DateTime.now(),
    );
  }

  /// 计算等级
  BondingLevel _calculateLevel(int exp) {
    if (exp >= 1001) return BondingLevel.soulmate;
    if (exp >= 601) return BondingLevel.close;
    if (exp >= 301) return BondingLevel.trusted;
    if (exp >= 101) return BondingLevel.acquaintance;
    return BondingLevel.stranger;
  }

  /// 获取当前等级描述
  String get levelDescription {
    switch (level) {
      case BondingLevel.stranger:
        return '初识';
      case BondingLevel.acquaintance:
        return '熟悉';
      case BondingLevel.trusted:
        return '信赖';
      case BondingLevel.close:
        return '亲密';
      case BondingLevel.soulmate:
        return '灵魂伴侣';
    }
  }

  /// 获取下一级所需经验
  int get experienceToNextLevel {
    switch (level) {
      case BondingLevel.stranger:
        return 100 - experience;
      case BondingLevel.acquaintance:
        return 300 - experience;
      case BondingLevel.trusted:
        return 600 - experience;
      case BondingLevel.close:
        return 1000 - experience;
      case BondingLevel.soulmate:
        return 0;
    }
  }

  /// 获取等级进度 (0.0 - 1.0)
  double get levelProgress {
    switch (level) {
      case BondingLevel.stranger:
        return experience / 100;
      case BondingLevel.acquaintance:
        return (experience - 100) / 200;
      case BondingLevel.trusted:
        return (experience - 300) / 300;
      case BondingLevel.close:
        return (experience - 600) / 400;
      case BondingLevel.soulmate:
        return 1.0;
    }
  }
}
```

---

## 🎮 DogAction (狗狗动作)

### 动作枚举

```dart
/// 狗狗动作枚举
enum DogAction {
  shake,      // 握手
  sit,        // 坐下
  rollover,   // 打滚
  jump,       // 跳跃
  bark,       // 吠叫
  dance,      // 跳舞
  beg,        // 乞讨
  spin,       // 转圈
  lieDown,    // 躺下
  stay,       // 等待
  come,       // 过来
  fetch,      // 捡球
}

/// 动作元数据
class ActionMetadata {
  final DogAction action;
  final String name;
  final String description;
  final String iconPath;
  final int cooldownSeconds;
  final int experienceReward;

  const ActionMetadata({
    required this.action,
    required this.name,
    required this.description,
    required this.iconPath,
    this.cooldownSeconds = 5,
    this.experienceReward = 10,
  });

  /// 获取所有动作元数据
  static const List<ActionMetadata> all = [
    ActionMetadata(
      action: DogAction.shake,
      name: '握手',
      description: '抬起前爪与人握手',
      iconPath: 'assets/icons/shake.png',
    ),
    ActionMetadata(
      action: DogAction.sit,
      name: '坐下',
      description: '乖乖坐下',
      iconPath: 'assets/icons/sit.png',
    ),
    ActionMetadata(
      action: DogAction.rollover,
      name: '打滚',
      description: '在地上打滚',
      iconPath: 'assets/icons/rollover.png',
      experienceReward: 20,
    ),
    // ... 更多动作
  ];
}
```

---

## 📡 BluetoothData (蓝牙数据)

### 数据包结构

```dart
/// 蓝牙命令
class BluetoothCommand {
  final String action;
  final Map<String, dynamic> parameters;
  final int timestamp;
  final int sequence;

  BluetoothCommand({
    required this.action,
    this.parameters = const {},
    required this.timestamp,
    required this.sequence,
  });

  String toJson() {
    return jsonEncode({
      'action': action,
      'params': parameters,
      'ts': timestamp,
      'seq': sequence,
    });
  }

  List<int> toBytes() {
    final json = toJson();
    return utf8.encode(json);
  }
}

/// 蓝牙响应
class BluetoothResponse {
  final bool success;
  final String? error;
  final Map<String, dynamic>? data;
  final int timestamp;

  BluetoothResponse({
    required this.success,
    this.error,
    this.data,
    required this.timestamp,
  });

  factory BluetoothResponse.fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return BluetoothResponse(
      success: map['success'] ?? false,
      error: map['error'],
      data: map['data'] as Map<String, dynamic>?,
      timestamp: map['timestamp'] ?? 0,
    );
  }
}

/// 设备状态更新
class DeviceStatusUpdate {
  final DeviceStatus status;
  final int batteryLevel;
  final int signalStrength;
  final DateTime timestamp;

  DeviceStatusUpdate({
    required this.status,
    required this.batteryLevel,
    required this.signalStrength,
    required this.timestamp,
  });
}
```

---

## ⚙️ AppSettings (应用设置)

### 设置模型

```dart
/// 主题模式
enum AppTheme {
  light,
  dark,
  system,
}

/// 语言设置
enum AppLanguage {
  zhCN,    // 简体中文
  enUS,    // 英文
  jaJP,    // 日文
  koKR,    // 韩文
  zhTW,    // 繁体中文
}

/// 应用设置
class AppSettings {
  /// 主题模式
  final AppTheme theme;
  
  /// 语言
  final AppLanguage language;
  
  /// 是否启用通知
  final bool notifications;
  
  /// 是否启用声音效果
  final bool soundEffects;
  
  /// 是否启用震动反馈
  final bool hapticFeedback;
  
  /// 摇杆灵敏度 (1-100)
  final int joystickSensitivity;
  
  /// 自动重连
  final bool autoReconnect;
  
  /// 最大速度限制 (0-100)
  final int maxSpeed;

  const AppSettings({
    this.theme = AppTheme.system,
    this.language = AppLanguage.zhCN,
    this.notifications = true,
    this.soundEffects = true,
    this.hapticFeedback = true,
    this.joystickSensitivity = 50,
    this.autoReconnect = true,
    this.maxSpeed = 100,
  });

  /// 从 JSON 创建
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      theme: AppTheme.values.firstWhere(
        (e) => e.name == json['theme'],
        orElse: () => AppTheme.system,
      ),
      language: AppLanguage.values.firstWhere(
        (e) => e.name == json['language'],
        orElse: () => AppLanguage.zhCN,
      ),
      notifications: json['notifications'] ?? true,
      soundEffects: json['sound_effects'] ?? true,
      hapticFeedback: json['haptic_feedback'] ?? true,
      joystickSensitivity: json['joystick_sensitivity'] ?? 50,
      autoReconnect: json['auto_reconnect'] ?? true,
      maxSpeed: json['max_speed'] ?? 100,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'theme': theme.name,
      'language': language.name,
      'notifications': notifications,
      'sound_effects': soundEffects,
      'haptic_feedback': hapticFeedback,
      'joystick_sensitivity': joystickSensitivity,
      'auto_reconnect': autoReconnect,
      'max_speed': maxSpeed,
    };
  }

  AppSettings copyWith({
    AppTheme? theme,
    AppLanguage? language,
    bool? notifications,
    bool? soundEffects,
    bool? hapticFeedback,
    int? joystickSensitivity,
    bool? autoReconnect,
    int? maxSpeed,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      notifications: notifications ?? this.notifications,
      soundEffects: soundEffects ?? this.soundEffects,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      joystickSensitivity: joystickSensitivity ?? this.joystickSensitivity,
      autoReconnect: autoReconnect ?? this.autoReconnect,
      maxSpeed: maxSpeed ?? this.maxSpeed,
    );
  }
}
```

---

## 📊 数据转换示例

### JSON 序列化/反序列化

```dart
// 保存设备数据
final device = DeviceModel.initial();
final json = device.toJson();
await StorageService.save('device', json);

// 加载设备数据
final savedJson = await StorageService.load('device');
if (savedJson != null) {
  final device = DeviceModel.fromJson(savedJson);
}

// 保存亲密度数据
final bonding = BondingModel.initial();
final json = bonding.toJson();
await StorageService.save('bonding', json);

// 加载亲密度数据
final savedJson = await StorageService.load('bonding');
if (savedJson != null) {
  final bonding = BondingModel.fromJson(savedJson);
}
```

---

## 📚 相关文档

- [项目概述](./PROJECT_OVERVIEW.md)
- [架构设计](./ARCHITECTURE.md)
- [功能特性](./FEATURES.md)
- [开发指南](./DEVELOPMENT_GUIDE.md)
- [API 参考](./API_REFERENCE.md)

---

*Last Updated: 2026-03-04 18:45*
