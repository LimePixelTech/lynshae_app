import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../models/device_model.dart';

/// 产品卡片组件
/// 用于首页显示设备信息
class ProductCard extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback onTap;
  final VoidCallback onPowerToggle;

  const ProductCard({
    super.key,
    required this.device,
    required this.onTap,
    required this.onPowerToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = device.isOnline && device.status != DeviceStatus.offline;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withAlpha(40)
                  : AppTheme.warmBrown.withAlpha(15),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconBox(isDark, isEnabled),
                _buildPowerButton(isDark, isEnabled),
              ],
            ),
            const SizedBox(height: 8),
            _buildProductInfo(isDark, isEnabled),
            const SizedBox(height: 6),
            _buildBatteryRow(isDark, isEnabled),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(bool isDark, bool isEnabled) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isEnabled
            ? (isDark ? Colors.white.withAlpha(20) : AppTheme.warmBeige.withAlpha(40))
            : (isDark ? Colors.white.withAlpha(10) : Colors.grey.shade400.withAlpha(30)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getDeviceIcon(),
        color: isEnabled
            ? (isDark ? Colors.white : AppTheme.warmBrown)
            : (isDark ? Colors.white.withAlpha(40) : Colors.grey.shade500),
        size: 22,
      ),
    );
  }

  Widget _buildPowerButton(bool isDark, bool isEnabled) {
    return GestureDetector(
      onTap: onPowerToggle,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isEnabled
              ? AppTheme.successGreen
              : (isDark ? Colors.white.withAlpha(30) : AppTheme.gray300),
          border: Border.all(
            color: isEnabled
                ? AppTheme.successGreen
                : (isDark ? Colors.white.withAlpha(50) : AppTheme.gray400),
            width: 1,
          ),
        ),
        child: Icon(
          isEnabled ? Icons.check_circle_rounded : Icons.circle_outlined,
          color: isEnabled
              ? Colors.white
              : (isDark ? Colors.white70 : AppTheme.gray600),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildProductInfo(bool isDark, bool isEnabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          device.name,
          style: TextStyle(
            color: isEnabled
                ? (isDark ? Colors.white : AppTheme.lightTextPrimary)
                : (isDark ? Colors.white.withAlpha(40) : Colors.grey.shade500),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          device.model ?? '智能设备',
          style: TextStyle(
            color: isEnabled
                ? (isDark ? Colors.white54 : AppTheme.lightTextSecondary)
                : (isDark ? Colors.white.withAlpha(25) : Colors.grey.shade400),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryRow(bool isDark, bool isEnabled) {
    final batteryLevel = device.batteryLevel;
    final batteryColor = AppUtils.getBatteryColor(batteryLevel);

    return Row(
      children: [
        Icon(
          isEnabled ? Icons.bolt_rounded : Icons.battery_alert_outlined,
          color: isEnabled ? batteryColor : (isDark ? Colors.white30 : AppTheme.lightTextMuted),
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          '$batteryLevel%',
          style: TextStyle(
            color: isEnabled ? batteryColor : (isDark ? Colors.white30 : AppTheme.lightTextMuted),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (!device.isOnline)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(30),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '离线',
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  IconData _getDeviceIcon() {
    final name = device.name.toLowerCase();
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
