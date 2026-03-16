/// 设备模型类
/// 表示智能设备的各种状态信息
class DeviceModel {
  final String id;
  final String name;
  final String? sn;
  final String? model;
  final String? macAddress;
  final String? firmwareVersion;
  final String? bindCode;
  final DeviceStatus status;
  final int batteryLevel;
  final DeviceMode mode;
  final bool isOnline;
  final String? room;
  final DateTime? createdAt;
  final DateTime? lastActiveAt;

  DeviceModel({
    required this.id,
    required this.name,
    this.sn,
    this.model,
    this.macAddress,
    this.firmwareVersion,
    this.bindCode,
    this.status = DeviceStatus.idle,
    this.batteryLevel = 100,
    this.mode = DeviceMode.companion,
    this.isOnline = true,
    this.room,
    this.createdAt,
    this.lastActiveAt,
  });

  /// 从 JSON 创建设备模型（适配后端 API）
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String? ?? json['device_id'] as String? ?? '',
      name: json['name'] as String? ?? json['device_name'] as String? ?? '未知设备',
      sn: json['sn'] as String?,
      model: json['model'] as String?,
      macAddress: json['mac_address'] as String?,
      firmwareVersion: json['firmware_version'] as String?,
      bindCode: json['bind_code'] as String?,
      status: DeviceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DeviceStatus.idle,
      ),
      batteryLevel: json['battery_level'] as int? ?? 100,
      mode: DeviceMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => DeviceMode.companion,
      ),
      isOnline: json['is_online'] as bool? ?? false,
      room: json['room'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'] as String)
          : null,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sn': sn,
      'model': model,
      'mac_address': macAddress,
      'firmware_version': firmwareVersion,
      'bind_code': bindCode,
      'status': status.name,
      'battery_level': batteryLevel,
      'mode': mode.name,
      'is_online': isOnline,
      'room': room,
    };
  }

  DeviceModel copyWith({
    String? id,
    String? name,
    String? sn,
    String? model,
    String? macAddress,
    String? firmwareVersion,
    String? bindCode,
    DeviceStatus? status,
    int? batteryLevel,
    DeviceMode? mode,
    bool? isOnline,
    String? room,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sn: sn ?? this.sn,
      model: model ?? this.model,
      macAddress: macAddress ?? this.macAddress,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      bindCode: bindCode ?? this.bindCode,
      status: status ?? this.status,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      mode: mode ?? this.mode,
      isOnline: isOnline ?? this.isOnline,
      room: room ?? this.room,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
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
