class DogAction {
  final String id;
  final String name;
  final String iconName;
  final String description;
  final int bondingPoints;
  final bool isUnlocked;
  final int? requiredLevel;

  const DogAction({
    required this.id,
    required this.name,
    required this.iconName,
    required this.description,
    this.bondingPoints = 5,
    this.isUnlocked = true,
    this.requiredLevel,
  });

  static const List<DogAction> defaultActions = [
    DogAction(
      id: 'handshake',
      name: '握手',
      iconName: 'handshake',
      description: '伸出爪子与你握手',
      bondingPoints: 10,
    ),
    DogAction(
      id: 'spin',
      name: '转圈',
      iconName: 'rotate_right',
      description: '快乐地转一个圈',
      bondingPoints: 10,
    ),
    DogAction(
      id: 'bow',
      name: '作揖',
      iconName: 'emoji_people',
      description: '传统礼仪动作',
      bondingPoints: 15,
    ),
    DogAction(
      id: 'sit',
      name: '坐下',
      iconName: 'airline_seat_recline_normal',
      description: '乖乖坐下',
      bondingPoints: 5,
    ),
    DogAction(
      id: 'stand',
      name: '站立',
      iconName: 'accessibility_new',
      description: '站立姿势',
      bondingPoints: 5,
    ),
    DogAction(
      id: 'dance',
      name: '跳舞',
      iconName: 'music_note',
      description: '随着音乐起舞',
      bondingPoints: 20,
      requiredLevel: 1,
    ),
    DogAction(
      id: 'bark',
      name: '叫声',
      iconName: 'record_voice_over',
      description: '发出可爱的叫声',
      bondingPoints: 5,
    ),
    DogAction(
      id: 'wag',
      name: '摇尾巴',
      iconName: 'motion_photos_on',
      description: '开心地摇尾巴',
      bondingPoints: 10,
    ),
  ];
}

enum DeviceMode {
  companion('陪伴', 'companion', 0xFF2196F3),
  patrol('巡逻', 'patrol', 0xFF4CAF50),
  follow('跟随', 'follow', 0xFFFF9800),
  sleep('休眠', 'sleep', 0xFF9E9E9E);

  final String displayName;
  final String iconKey;
  final int colorValue;

  const DeviceMode(this.displayName, this.iconKey, this.colorValue);
}

class DeviceStatus {
  final bool isOnline;
  final int batteryLevel;
  final DeviceMode currentMode;
  final bool isCharging;
  final String? errorMessage;

  const DeviceStatus({
    this.isOnline = false,
    this.batteryLevel = 0,
    this.currentMode = DeviceMode.sleep,
    this.isCharging = false,
    this.errorMessage,
  });

  DeviceStatus copyWith({
    bool? isOnline,
    int? batteryLevel,
    DeviceMode? currentMode,
    bool? isCharging,
    String? errorMessage,
  }) {
    return DeviceStatus(
      isOnline: isOnline ?? this.isOnline,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      currentMode: currentMode ?? this.currentMode,
      isCharging: isCharging ?? this.isCharging,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  String get batteryStatus {
    if (isCharging) return '充电中';
    if (batteryLevel > 80) return '充足';
    if (batteryLevel > 50) return '良好';
    if (batteryLevel > 20) return '一般';
    return '低电量';
  }

  int get batteryColor {
    if (batteryLevel > 60) return 0xFF4CAF50;
    if (batteryLevel > 20) return 0xFFFFA000;
    return 0xFFE53935;
  }
}
