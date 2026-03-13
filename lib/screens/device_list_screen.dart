import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../common/components/app_navbar.dart';

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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        AppUtils.vibrate();
                        AppUtils.showSuccess(context, '查看 ${device['name']}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                device['icon'] as IconData,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    device['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    device['type'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white30,
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
                            const SizedBox(width: 12),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white30,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
