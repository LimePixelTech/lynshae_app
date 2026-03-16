import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common/components/app_navbar.dart';

/// 设备列表页面
class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final devices = [
      {'name': 'LynShae', 'type': '智能设备', 'status': '在线', 'icon': Icons.pets_rounded},
      {'name': 'MeowBot', 'type': '机器猫', 'status': '在线', 'icon': Icons.smart_toy_rounded},
      {'name': '晨曦', 'type': '智能时钟', 'status': '离线', 'icon': Icons.access_alarm_rounded},
      {'name': '护眼灯', 'type': '智能灯具', 'status': '离线', 'icon': Icons.lightbulb_rounded},
    ];

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightBgTop,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            const AppNavbar(title: '设备列表', showNotification: false),
            // 设备列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return _buildDeviceCard(device, context, isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(
    Map<String, dynamic> device,
    BuildContext context,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: device['status'] == '在线'
                    ? (isDark ? AppTheme.primaryBlue.withAlpha(30) : AppTheme.warmBeige.withAlpha(30))
                    : (isDark ? Colors.white.withAlpha(10) : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                device['icon'] as IconData,
                color: device['status'] == '在线'
                    ? (isDark ? AppTheme.primaryBlue : AppTheme.warmBrown)
                    : (isDark ? Colors.white.withAlpha(50) : Colors.grey.shade500),
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device['name'] as String,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    device['type'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: device['status'] == '在线'
                    ? AppTheme.successGreen.withAlpha(30)
                    : (isDark ? Colors.white.withAlpha(10) : AppTheme.warmBeige.withAlpha(15)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                device['status'] as String,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: device['status'] == '在线'
                      ? AppTheme.successGreen
                      : (isDark ? Colors.white30 : AppTheme.lightTextMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
