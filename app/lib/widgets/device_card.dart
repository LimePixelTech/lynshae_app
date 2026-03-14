import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

/// 设备卡片组件 - 玻璃质感
class DeviceCard extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback onPowerToggle;
  final VoidCallback onModeSwitch;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onPowerToggle,
    required this.onModeSwitch,
    required this.onTap,
  });

  Color get _batteryColor {
    if (device.batteryLevel > 60) return AppColors.successGreen;
    if (device.batteryLevel > 20) return AppColors.warningYellow;
    return AppColors.errorRed;
  }

  Color get _statusColor {
    return device.isOnline ? AppColors.successGreen : AppColors.errorRed;
  }

  String get _statusText => device.isOnline ? '在线' : '离线';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.5),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                  blurRadius: 30,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Stack(
              children: [
                // 装饰光效
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.primaryBlue.withValues(alpha: isDark ? 0.12 : 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 顶部状态栏
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 在线状态
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _statusColor.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _statusColor,
                                    shape: BoxShape.circle,
                                    boxShadow: device.isOnline
                                        ? [
                                            BoxShadow(
                                              color: _statusColor
                                                  .withValues(alpha: 0.5),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _statusText,
                                  style: TextStyle(
                                    color: _statusColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 电量
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _batteryColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  device.batteryLevel > 20
                                      ? Icons.battery_full
                                      : Icons.battery_alert,
                                  color: _batteryColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${device.batteryLevel}%',
                                  style: TextStyle(
                                    color: _batteryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 设备形象
                      Center(
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : Colors.white.withValues(alpha: 0.5),
                            border: Border.all(
                              color:
                                  AppTheme.primaryBlue.withValues(alpha: 0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue
                                    .withValues(alpha: isDark ? 0.15 : 0.1),
                                blurRadius: 25,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.pets_rounded,
                            size: 70,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 设备名称
                      Center(
                        child: Text(
                          device.name,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          device.room ?? '未分配房间',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 模式切换
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildModeButton(
                              context, '陪伴', Icons.home_rounded,
                              DeviceMode.companion, isDark),
                          const SizedBox(width: 10),
                          _buildModeButton(
                              context, '巡逻', Icons.security_rounded,
                              DeviceMode.patrol, isDark),
                          const SizedBox(width: 10),
                          _buildModeButton(
                              context, '跟随',
                              Icons.directions_walk_rounded,
                              DeviceMode.follow, isDark),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 开关机按钮
                      Center(
                        child: GestureDetector(
                          onTap: onPowerToggle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: device.isOnline
                                  ? AppTheme.primaryGradient
                                  : null,
                              color: device.isOnline
                                  ? null
                                  : (isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.08)),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: device.isOnline
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primaryBlue
                                      .withValues(alpha: 0.3),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  device.isOnline
                                      ? Icons.power_settings_new
                                      : Icons.power_off,
                                  color: device.isOnline
                                      ? Colors.white
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  device.isOnline ? '已开机' : '已关机',
                                  style: TextStyle(
                                    color: device.isOnline
                                        ? Colors.white
                                        : theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(BuildContext context, String label, IconData icon,
      DeviceMode mode, bool isDark) {
    final isSelected = device.mode == mode;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onModeSwitch,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: isDark ? 0.25 : 0.2)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBlue.withValues(alpha: 0.4)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppTheme.primaryBlue
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.primaryBlue
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
