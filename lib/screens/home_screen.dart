import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../widgets/device_card.dart';
import '../widgets/glass_container.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DeviceModel device = DeviceModel(
    id: 'dog_001',
    name: 'LynShae',
    isOnline: true,
    batteryLevel: 78,
    mode: DeviceMode.companion,
    macAddress: 'A4:B5:C6:D7:E8:F9',
    firmwareVersion: 'v2.1.0',
  );

  bool isScanning = false;
  List<DeviceModel> discoveredDevices = [];
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && device.isOnline) {
        setState(() {
          device = device.copyWith(
            batteryLevel: (device.batteryLevel - 1).clamp(0, 100),
          );
        });
        _startAutoRefresh();
      }
    });
  }

  Future<void> _scanDevices() async {
    if (isScanning) return;
    setState(() {
      isScanning = true;
      discoveredDevices = [];
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      isScanning = false;
      discoveredDevices = [
        DeviceModel(
          id: 'dog_002',
          name: 'LynShae-Pro',
          isOnline: true,
          batteryLevel: 92,
          mode: DeviceMode.companion,
          macAddress: 'B5:C6:D7:E8:F9:A0',
          firmwareVersion: 'v2.1.0',
        ),
      ];
    });
    AppUtils.vibrate();
  }

  void _togglePower() {
    setState(() {
      device = device.copyWith(isOnline: !device.isOnline);
    });
    AppUtils.vibrate();
    if (!device.isOnline) {
      AppUtils.showSuccess(context, '设备已关机');
    }
  }

  void _switchMode(DeviceMode mode) {
    setState(() {
      device = device.copyWith(mode: mode);
    });
    Navigator.pop(context);
    AppUtils.vibrate();
    AppUtils.showSuccess(context, '已切换到${mode.displayName}');
  }

  void _showModeSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.85),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.15)
                      : Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(ctx)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '选择模式',
                  style: TextStyle(
                    color: Theme.of(ctx).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildModeOption(
                    ctx, DeviceMode.companion, '陪伴模式', Icons.favorite_rounded),
                _buildModeOption(
                    ctx, DeviceMode.patrol, '巡逻模式', Icons.security_rounded),
                _buildModeOption(ctx, DeviceMode.follow, '跟随模式',
                    Icons.directions_walk_rounded),
                _buildModeOption(
                    ctx, DeviceMode.sleep, '休眠模式', Icons.bedtime_rounded),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeOption(
      BuildContext ctx, DeviceMode mode, String label, IconData icon) {
    final isSelected = device.mode == mode;
    final theme = Theme.of(ctx);
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(
        icon,
        color: isSelected
            ? AppTheme.primaryBlue
            : theme.colorScheme.onSurface.withOpacity(0.5),
        size: 26,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? AppTheme.primaryBlue
              : theme.colorScheme.onSurface,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryBlue)
          : null,
      onTap: () => _switchMode(mode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.primaryBlue,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DeviceCard(
                        device: device,
                        onPowerToggle: _togglePower,
                        onModeSwitch: _showModeSelector,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.control),
                      ),
                      const SizedBox(height: 20),
                      _buildQuickActions(),
                      const SizedBox(height: 20),
                      _buildSmartHomeSection(),
                      const SizedBox(height: 20),
                      _buildDeviceDiscovery(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        device = device.copyWith(batteryLevel: 85, isOnline: true);
        isRefreshing = false;
      });
      AppUtils.showSuccess(context, '设备状态已更新');
    }
  }

  Widget _buildTopBar() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: device.isOnline
                      ? AppColors.successGreen
                      : AppColors.errorRed,
                  shape: BoxShape.circle,
                  boxShadow: device.isOnline
                      ? [
                          BoxShadow(
                            color: AppColors.successGreen.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                device.isOnline ? '局域网连接' : '离线',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  size: 18),
              const SizedBox(width: 4),
              Text(
                'Freakz3z',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '快速操作',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildActionButton(
              icon: Icons.videocam_rounded,
              label: '实时画面',
              onTap: () => Navigator.pushNamed(context, AppRoutes.control),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              icon: Icons.mic_rounded,
              label: '语音对话',
              color: AppColors.accentOrange,
              onTap: () => AppUtils.showInfo(context, '语音对话功能开发中'),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              icon: Icons.favorite_rounded,
              label: '羁绊中心',
              color: AppColors.accentPink,
              onTap: () => Navigator.pushNamed(context, AppRoutes.bonding),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.primaryBlue,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(vertical: 18),
          borderColor: color.withOpacity(0.25),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmartHomeSection() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '智能家居联动',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () =>
                  AppUtils.showInfo(context, '智能家居管理开发中'),
              child: const Text('管理'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassContainer(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              _buildSmartDevice('客厅灯', Icons.lightbulb_outline, true),
              _buildSmartDevice('空调', Icons.ac_unit, false),
              _buildSmartDevice('门锁', Icons.lock_outline, true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmartDevice(String name, IconData icon, bool isOn) {
    final theme = Theme.of(context);
    final color = isOn
        ? AppColors.primaryBlue
        : theme.colorScheme.onSurface.withOpacity(0.3);
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(isOn ? 0.9 : 0.4),
              fontSize: 12,
            ),
          ),
          Text(
            isOn ? '开启' : '关闭',
            style: TextStyle(
              color: isOn
                  ? AppColors.primaryBlue
                  : theme.colorScheme.onSurface.withOpacity(0.3),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceDiscovery() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '设备发现',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: isScanning ? null : _scanDevices,
              icon: isScanning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.primaryBlue),
                      ),
                    )
                  : const Icon(Icons.refresh_rounded, size: 18),
              label: Text(isScanning ? '扫描中...' : '扫描'),
            ),
          ],
        ),
        if (discoveredDevices.isNotEmpty)
          GlassContainer(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            borderColor: AppColors.primaryBlue.withOpacity(0.3),
            child: Column(
              children: discoveredDevices
                  .map((d) => ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.pets,
                              color: AppColors.primaryBlue, size: 20),
                        ),
                        title: Text(d.name,
                            style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          '电量 ${d.batteryLevel}%',
                          style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.5)),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => AppUtils.showSuccess(
                              context, '正在绑定 ${d.name}'),
                          child: const Text('绑定'),
                        ),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
