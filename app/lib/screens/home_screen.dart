import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import 'device_list_screen.dart';
import 'device_detail_screen.dart';

/// 首页 - 米家风格设备列表
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 所有设备列表
  final List<DeviceModel> _allDevices = [
    DeviceModel(
      id: 'dog_001',
      name: 'LynShae',
      model: 'LS-Pro-X1',
      isOnline: true,
      batteryLevel: 78,
      status: DeviceStatus.idle,
    ),
    DeviceModel(
      id: 'cat_001',
      name: 'MeowBot',
      model: 'LS-Cat-Lite',
      isOnline: true,
      batteryLevel: 65,
      status: DeviceStatus.idle,
    ),
    DeviceModel(
      id: 'clock_001',
      name: '晨曦',
      model: 'LS-Clock-S1',
      isOnline: true,
      batteryLevel: 100,
      status: DeviceStatus.online,
    ),
    DeviceModel(
      id: 'lamp_001',
      name: '护眼灯',
      model: 'LS-Lamp-Pro',
      isOnline: false,
      batteryLevel: 0,
      status: DeviceStatus.offline,
    ),
  ];

  void _toggleDevicePower(int index) {
    AppUtils.vibrate();
    setState(() {
      final device = _allDevices[index];
      _allDevices[index] = device.copyWith(
        status: device.status == DeviceStatus.offline 
            ? DeviceStatus.idle 
            : DeviceStatus.offline,
      );
    });
  }

  void _openDeviceList() {
    AppUtils.vibrate();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DeviceListScreen(),
      ),
    );
  }

  void _openDeviceDetail(DeviceModel device) {
    AppUtils.vibrate();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailScreen(device: device),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // 页面标题
                    _buildPageTitle(),
                    const SizedBox(height: 20),
                    // 设备网格
                    _buildDeviceGrid(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildHeaderIcon(Icons.menu_rounded, isDark, onTap: _openDeviceList),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeaderIcon(Icons.notifications_outlined, isDark),
              const SizedBox(width: 12),
              _buildHeaderIcon(Icons.add_rounded, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, bool isDark, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withAlpha(20)
              : AppTheme.warmBeige.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      '我的设备',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : AppTheme.lightTextPrimary,
      ),
    );
  }

  Widget _buildDeviceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _allDevices.length,
      itemBuilder: (context, index) {
        final device = _allDevices[index];
        return _buildDeviceCard(device);
      },
    );
  }

  Widget _buildDeviceCard(DeviceModel device) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = device.isOnline && device.status != DeviceStatus.offline;

    return GestureDetector(
      onTap: () => _openDeviceDetail(device),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isEnabled
              ? (isDark ? AppTheme.darkCard : AppTheme.lightCard)
              : (isDark ? const Color(0xFF0D1117) : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEnabled
                ? (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
                : (isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E5E5)),
            width: 1,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: (isDark ? AppTheme.primaryBlue : AppTheme.warmBeige).withAlpha(30),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部区域：设备图标 + 开关
              Row(
                children: [
                  // 设备图标
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? (isDark ? AppTheme.primaryBlue.withAlpha(40) : AppTheme.warmBeige.withAlpha(40))
                          : (isDark ? Colors.white.withAlpha(10) : Colors.grey.shade400.withAlpha(30)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getDeviceIcon(device),
                      color: isEnabled
                          ? (isDark ? AppTheme.primaryBlue : AppTheme.warmBrown)
                          : (isDark ? Colors.white.withAlpha(40) : Colors.grey.shade500),
                      size: 26,
                    ),
                  ),
                  const Spacer(),
                  // 电源开关
                  GestureDetector(
                    onTap: device.isOnline
                        ? () {
                            AppUtils.vibrate();
                            _toggleDevicePower(_allDevices.indexOf(device));
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isEnabled
                            ? AppTheme.successGreen
                            : (isDark ? const Color(0xFF1F2937) : Colors.grey.shade300),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isEnabled
                              ? AppTheme.successGreen.withAlpha(150)
                              : (isDark ? Colors.white.withAlpha(20) : Colors.grey.shade400.withAlpha(50)),
                          width: 1,
                        ),
                        boxShadow: isEnabled
                            ? [
                                BoxShadow(
                                  color: AppTheme.successGreen.withAlpha(100),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: Icon(
                          key: ValueKey(isEnabled),
                          isEnabled ? Icons.check_circle_rounded : Icons.circle_outlined,
                          color: isEnabled
                              ? Colors.white
                              : (isDark ? Colors.white.withAlpha(60) : Colors.grey.shade500),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // 设备名称
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 350),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isEnabled
                      ? (isDark ? Colors.white : AppTheme.lightTextPrimary)
                      : (isDark ? Colors.white.withAlpha(40) : Colors.grey.shade500),
                ),
                child: Text(device.name),
              ),
              const SizedBox(height: 4),
              // 设备类型/房间
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 350),
                style: TextStyle(
                  fontSize: 12,
                  color: isEnabled
                      ? (isDark ? Colors.white.withAlpha(50) : AppTheme.lightTextSecondary)
                      : (isDark ? Colors.white.withAlpha(25) : Colors.grey.shade400),
                ),
                child: Text(device.model ?? '智能设备'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getDeviceIcon(DeviceModel device) {
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
