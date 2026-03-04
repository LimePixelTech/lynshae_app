import 'package:flutter/material.dart';

/// 应用常量定义
class AppConstants {
  // 应用信息
  static const String appName = '智能机器狗';
  static const String appVersion = '1.0.0';

  // 蓝牙相关
  static const String bluetoothServiceUuid =
      '00001101-0000-1000-8000-00805F9B34FB';
  static const int bluetoothTimeout = 30000;
  static const int reconnectDelay = 3000;

  // 设备命令
  static const String cmdMoveForward = 'move_forward';
  static const String cmdMoveBackward = 'move_backward';
  static const String cmdTurnLeft = 'turn_left';
  static const String cmdTurnRight = 'turn_right';
  static const String cmdStop = 'stop';
  static const String cmdAction = 'action';
  static const String cmdGetStatus = 'get_status';

  // 默认值
  static const int defaultBatteryLow = 20;
  static const int defaultBatteryWarning = 10;
  static const double joystickMaxDistance = 1.0;

  // UI 相关
  static const double cardBorderRadius = 20.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double glassBlur = 20.0;

  // 动画时长
  static const int animationDuration = 300;
  static const int longAnimationDuration = 500;

  // 存储键
  static const String keyLastConnectedDevice = 'last_connected_device';
  static const String keySettings = 'app_settings';
  static const String keyBondingData = 'bonding_data';
  static const String keyThemeMode = 'theme_mode';
}

/// 品牌色常量 (不随主题变化)
class AppColors {
  static const Color primaryBlue = Color(0xFF00D4FF);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentPink = Color(0xFFFF4081);
  static const Color successGreen = Color(0xFF4ADE80);
  static const Color warningYellow = Color(0xFFFBBF24);
  static const Color errorRed = Color(0xFFEF4444);
}

/// 路由常量
class AppRoutes {
  static const String home = '/';
  static const String main = '/main';
  static const String control = '/control';
  static const String bonding = '/bonding';
  static const String settings = '/settings';
}
