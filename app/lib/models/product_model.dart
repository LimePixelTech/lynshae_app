import 'package:flutter/material.dart';
import 'device_model.dart';

/// 产品类型枚举
enum ProductType {
  robotDog('智能设备', Icons.pets_rounded, Color(0xFF00D4FF)),
  robotCat('机器猫', Icons.smart_toy_rounded, Color(0xFFFF6B6B)),
  smartClock('智能闹钟', Icons.access_alarm_rounded, Color(0xFFFFD93D)),
  smartLamp('智能台灯', Icons.lightbulb_rounded, Color(0xFF6BCB77)),
  airPurifier('空气净化器', Icons.air_rounded, Color(0xFF4D96FF));

  final String name;
  final IconData icon;
  final Color color;

  const ProductType(this.name, this.icon, this.color);
}

/// 产品模型
/// 用于表示各种智能设备
class Product {
  final String id;
  final String name;
  final ProductType type;
  final DeviceModel? device;
  final bool isOnline;
  final int batteryLevel;
  final bool isOn;

  Product({
    required this.id,
    required this.name,
    required this.type,
    this.device,
    this.isOnline = false,
    this.batteryLevel = 0,
    this.isOn = false,
  });

  Product copyWith({
    String? id,
    String? name,
    ProductType? type,
    DeviceModel? device,
    bool? isOnline,
    int? batteryLevel,
    bool? isOn,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      device: device ?? this.device,
      isOnline: isOnline ?? this.isOnline,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isOn: isOn ?? this.isOn,
    );
  }
}
