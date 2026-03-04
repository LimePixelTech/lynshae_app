/// 设备模型类
/// 表示智能机器狗的各种状态信息
class DeviceModel {
  final String id;
  final String name;
  final String macAddress;
  final String firmwareVersion;
  final DeviceStatus status;
  final int batteryLevel;
  final DeviceMode mode;
  final bool isOnline;
  final String? room;

  DeviceModel({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.firmwareVersion,
    this.status = DeviceStatus.idle,
    this.batteryLevel = 100,
    this.mode = DeviceMode.companion,
    this.isOnline = true,
    this.room,
  });

  DeviceModel copyWith({
    String? id,
    String? name,
    String? macAddress,
    String? firmwareVersion,
    DeviceStatus? status,
    int? batteryLevel,
    DeviceMode? mode,
    bool? isOnline,
    String? room,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      macAddress: macAddress ?? this.macAddress,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      status: status ?? this.status,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      mode: mode ?? this.mode,
      isOnline: isOnline ?? this.isOnline,
      room: room ?? this.room,
    );
  }
}

/// 设备运行状态
enum DeviceStatus {
  idle,      // 空闲
  moving,    // 移动中
  executing, // 执行动作中
  charging,  // 充电中
  sleeping,  // 休眠
  error,     // 错误
  online,    // 在线
  offline,   // 离线
  busy,      // 忙碌
}

/// 设备模式
enum DeviceMode {
  companion, // 陪伴模式
  patrol,    // 巡逻模式
  follow,    // 跟随模式
  sleep,     // 休眠模式
}

extension DeviceModeExtension on DeviceMode {
  String get displayName {
    switch (this) {
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

  String get icon {
    switch (this) {
      case DeviceMode.companion:
        return '🏠';
      case DeviceMode.patrol:
        return '🛡️';
      case DeviceMode.follow:
        return '🚶';
      case DeviceMode.sleep:
        return '💤';
    }
  }
}

extension DeviceStatusExtension on DeviceStatus {
  String get displayName {
    switch (this) {
      case DeviceStatus.idle:
        return '待机中';
      case DeviceStatus.moving:
        return '移动中';
      case DeviceStatus.executing:
        return '执行动作';
      case DeviceStatus.charging:
        return '充电中';
      case DeviceStatus.sleeping:
        return '休眠中';
      case DeviceStatus.error:
        return '异常';
      case DeviceStatus.online:
        return '在线';
      case DeviceStatus.offline:
        return '离线';
      case DeviceStatus.busy:
        return '忙碌';
    }
  }
}
