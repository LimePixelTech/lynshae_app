import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common/components/app_navbar.dart';
import '../../common/components/settings_tile.dart';
import '../../utils/permission_utils.dart';

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
      checkPermission: PermissionUtils.checkLocationPermission,
      requestPermission: PermissionUtils.requestLocationPermission,
    ),
    '蓝牙权限': PermissionInfo(
      description: '用于连接和控制蓝牙智能设备',
      granted: false,
      icon: Icons.bluetooth_outlined,
      checkPermission: PermissionUtils.checkBluetoothPermission,
      requestPermission: PermissionUtils.requestBluetoothPermission,
    ),
    '相机权限': PermissionInfo(
      description: '用于扫描二维码和拍摄照片',
      granted: false,
      icon: Icons.camera_alt_outlined,
      checkPermission: PermissionUtils.checkCameraPermission,
      requestPermission: PermissionUtils.requestCameraPermission,
    ),
    '通知权限': PermissionInfo(
      description: '用于接收设备状态和应用通知',
      granted: false,
      icon: Icons.notifications_outlined,
      checkPermission: PermissionUtils.checkNotificationPermission,
      requestPermission: PermissionUtils.requestNotificationPermission,
    ),
    '存储权限': PermissionInfo(
      description: '用于保存设备配置和用户数据',
      granted: false,
      icon: Icons.storage_outlined,
      checkPermission: PermissionUtils.checkStoragePermission,
      requestPermission: PermissionUtils.requestStoragePermission,
    ),
    '麦克风权限': PermissionInfo(
      description: '用于语音控制和语音互动功能',
      granted: false,
      icon: Icons.mic_outlined,
      checkPermission: PermissionUtils.checkMicrophonePermission,
      requestPermission: PermissionUtils.requestMicrophonePermission,
    ),
  };

  @override
  void initState() {
    super.initState();
    _checkAllPermissions();
  }

  /// 检查所有权限状态
  Future<void> _checkAllPermissions() async {
    for (final entry in _permissions.entries) {
      final info = entry.value;
      final granted = await info.checkPermission();
      if (mounted) {
        setState(() {
          info.granted = granted;
        });
      }
    }
  }

  Future<void> _requestPermission(String name) async {
    final info = _permissions[name]!;

    if (info.granted) {
      // 已授权，提示用户已在设置中管理
      _showPermissionSettingsDialog(name);
      return;
    }

    try {
      final granted = await info.requestPermission();

      if (mounted) {
        setState(() {
          info.granted = granted;
        });

        if (!granted) {
          _showPermissionDeniedDialog(name);
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(name, e.toString());
      }
    }
  }

  void _showPermissionSettingsDialog(String name) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        title: Text(
          '$name 已授权',
          style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary),
        ),
        content: Text(
          '如需修改权限设置，请前往系统应用设置',
          style: TextStyle(color: isDark ? Colors.white70 : AppTheme.lightTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消', style: TextStyle(color: isDark ? Colors.white70 : AppTheme.lightTextSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await PermissionUtils.openAppSettings();
            },
            child: Text('去设置', style: TextStyle(color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown)),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog(String name) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        title: Text(
          '权限被拒绝',
          style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary),
        ),
        content: Text(
          '$name 已被拒绝，部分功能可能无法使用。',
          style: TextStyle(color: isDark ? Colors.white70 : AppTheme.lightTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('确定', style: TextStyle(color: isDark ? Colors.white70 : AppTheme.lightTextSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await PermissionUtils.openAppSettings();
            },
            child: Text('去设置', style: TextStyle(color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String name, String error) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        title: Text(
          '请求失败',
          style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary),
        ),
        content: Text(
          '请求 $name 时发生错误：$error',
          style: TextStyle(color: isDark ? Colors.white70 : AppTheme.lightTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('确定', style: TextStyle(color: isDark ? Colors.white70 : AppTheme.lightTextSecondary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightBgTop,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            const AppNavbar(title: '系统权限管理', showNotification: false),
            // 权限列表
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: _buildPermissionsCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SettingsCard(
      children: _permissions.entries.map((entry) {
        final name = entry.key;
        final info = entry.value;
        final isLast = entry.key == _permissions.keys.last;

        return SettingsTile(
          icon: info.icon,
          iconBackgroundColor: info.granted
              ? (isDark ? AppTheme.primaryBlue.withAlpha(40) : AppTheme.warmBeige.withAlpha(40))
              : (isDark ? Colors.white.withAlpha(15) : AppTheme.warmBeige.withAlpha(20)),
          iconColor: info.granted
              ? (isDark ? AppTheme.primaryBlue : AppTheme.warmBrown)
              : (isDark ? Colors.white : AppTheme.lightTextSecondary),
          title: name,
          subtitle: info.description,
          showSwitch: true,
          switchValue: info.granted,
          onSwitchChanged: (value) => _requestPermission(name),
          showArrow: false,
          showDivider: !isLast,
        );
      }).toList(),
    );
  }
}

class PermissionInfo {
  final String description;
  bool granted;
  final IconData icon;
  final Future<bool> Function() checkPermission;
  final Future<bool> Function() requestPermission;

  PermissionInfo({
    required this.description,
    required this.granted,
    required this.icon,
    required this.checkPermission,
    required this.requestPermission,
  });
}
