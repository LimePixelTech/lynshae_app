import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';

/// 设备详情页面 - 参考 OPPO Enco X3 样式
class DeviceDetailScreen extends StatefulWidget {
  final DeviceModel device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late bool _isOn;
  late bool _isConnected;
  late int _batteryLevel;

  @override
  void initState() {
    super.initState();
    _isOn = widget.device.isOnline && widget.device.status != DeviceStatus.offline;
    _isConnected = widget.device.isOnline;
    _batteryLevel = widget.device.batteryLevel;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkSurface : const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 设备图片和状态
                    _buildDeviceHeader(isDark),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              AppUtils.vibrate();
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: isDark ? Colors.white70 : Colors.black87,
                size: 24,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              AppUtils.vibrate();
              AppUtils.showInfo(context, '更多选项');
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color: isDark ? Colors.white70 : Colors.black87,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 设备名称
          Text(
            widget.device.name,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // 连接状态和电量
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _isConnected ? AppTheme.successGreen : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _isConnected ? '已连接' : '未连接',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              if (_isConnected && _batteryLevel > 0) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.battery_full_rounded,
                  size: 16,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  '$_batteryLevel%',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 32),
          // 设备图片
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isOn
                      ? (isDark
                          ? [
                              AppTheme.primaryBlue.withAlpha(40),
                              AppTheme.primaryBlue.withAlpha(10),
                            ]
                          : [
                              AppTheme.warmBeige.withAlpha(40),
                              AppTheme.warmBeige.withAlpha(10),
                            ])
                      : [
                          Colors.grey.withAlpha(30),
                          Colors.grey.withAlpha(10),
                        ],
                ),
              ),
              child: Icon(
                _getDeviceIcon(),
                size: 160,
                color: _isOn
                    ? (isDark ? Colors.white.withAlpha(220) : Colors.black87)
                    : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon() {
    final name = widget.device.name.toLowerCase();
    if (name.contains('dog') || name.contains('机器狗')) {
      return Icons.pets_rounded;
    } else if (name.contains('cat') || name.contains('机器猫')) {
      return Icons.pets_rounded;
    } else if (name.contains('clock') || name.contains('时钟')) {
      return Icons.access_time_rounded;
    } else if (name.contains('lamp') || name.contains('灯')) {
      return Icons.lightbulb_rounded;
    }
    return Icons.devices_rounded;
  }
}
