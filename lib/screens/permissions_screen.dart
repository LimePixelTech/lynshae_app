import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../common/components/app_navbar.dart';

/// 系统权限管理界面
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  // 权限列表
  final Map<String, PermissionInfo> _permissions = {
    '位置权限': PermissionInfo(
      description: '用于发现附近的智能设备和提供位置相关服务',
      granted: false,
      icon: Icons.location_on_outlined,
    ),
    '蓝牙权限': PermissionInfo(
      description: '用于连接和控制蓝牙智能设备',
      granted: false,
      icon: Icons.bluetooth_outlined,
    ),
    '相机权限': PermissionInfo(
      description: '用于扫描二维码和拍摄照片',
      granted: false,
      icon: Icons.camera_alt_outlined,
    ),
    '通知权限': PermissionInfo(
      description: '用于接收设备状态和应用通知',
      granted: false,
      icon: Icons.notifications_outlined,
    ),
    '存储权限': PermissionInfo(
      description: '用于保存设备配置和用户数据',
      granted: false,
      icon: Icons.storage_outlined,
    ),
    '麦克风权限': PermissionInfo(
      description: '用于语音控制和语音互动功能',
      granted: false,
      icon: Icons.mic_outlined,
    ),
  };

  void _togglePermission(String name) {
    setState(() {
      _permissions[name]!.granted = !_permissions[name]!.granted;
    });
    AppUtils.vibrate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkSurface,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            const AppNavbar(title: '系统权限管理', showNotification: false),
            // 权限列表
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildPermissionsCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: _permissions.entries.map((entry) {
          final name = entry.key;
          final info = entry.value;
          final isLast = entry.key == _permissions.keys.last;

          return Column(
            children: [
              GestureDetector(
                onTap: () => _togglePermission(name),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          info.icon,
                          color: info.granted ? AppTheme.primaryBlue : Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              info.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 开关
                      Container(
                        width: 52,
                        height: 32,
                        decoration: BoxDecoration(
                          color: info.granted
                              ? AppTheme.primaryBlue.withAlpha(80)
                              : Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              left: info.granted ? 24 : 4,
                              top: 4,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: info.granted
                                      ? AppTheme.primaryBlue
                                      : Colors.white54,
                                  shape: BoxShape.circle,
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
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 68,
                  endIndent: 16,
                  color: Colors.white.withAlpha(10),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class PermissionInfo {
  final String description;
  bool granted;
  final IconData icon;

  PermissionInfo({
    required this.description,
    required this.granted,
    required this.icon,
  });
}
