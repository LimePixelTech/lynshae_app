import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../common/components/app_navbar.dart';
import '../../common/components/settings_tile.dart';

/// 设备列表页面
class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = [
      {'name': 'LynShae Pro', 'type': '机器狗', 'status': '在线', 'icon': Icons.pets_rounded},
      {'name': 'MeowBot', 'type': '机器猫', 'status': '在线', 'icon': Icons.smart_toy_rounded},
      {'name': '晨曦闹钟', 'type': '智能时钟', 'status': '离线', 'icon': Icons.access_alarm_rounded},
      {'name': '护眼台灯', 'type': '智能灯具', 'status': '离线', 'icon': Icons.lightbulb_rounded},
    ];

    return Scaffold(
      backgroundColor: AppTheme.darkSurface,
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
                  return DeviceListScreen._buildDeviceCard(device, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDeviceCard(Map<String, dynamic> device, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SettingsCard(
        children: [
          SettingsTile(
            icon: device['icon'] as IconData,
            iconContainerSize: 56,
            iconSize: 28,
            title: device['name'] as String,
            subtitle: device['type'] as String,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: device['status'] == '在线'
                    ? AppTheme.successGreen.withAlpha(30)
                    : Colors.white.withAlpha(10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                device['status'] as String,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: device['status'] == '在线'
                      ? AppTheme.successGreen
                      : Colors.white30,
                ),
              ),
            ),
            onTap: () {
              AppUtils.vibrate();
              AppUtils.showSuccess(context, '查看 ${device['name']}');
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
