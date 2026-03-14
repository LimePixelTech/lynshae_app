import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../../common/components/app_navbar.dart';
import '../../common/components/settings_tile.dart';
import '../services/user_settings_service.dart';

/// 通知设置页面
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // 通知开关状态
  bool _deviceNotificationsEnabled = true;
  bool _mallNotificationsEnabled = true;
  bool _dndEnabled = false;

  // 免打扰时间
  TimeOfDay _dndStartTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _dndEndTime = const TimeOfDay(hour: 7, minute: 0);

  // 加载状态
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// 加载所有设置
  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    _deviceNotificationsEnabled =
        await UserSettingsService.isDeviceNotificationsEnabled();
    _mallNotificationsEnabled =
        await UserSettingsService.isMallNotificationsEnabled();
    _dndEnabled = await UserSettingsService.isDndEnabled();

    final startTime = await UserSettingsService.getDndStartTime();
    final endTime = await UserSettingsService.getDndEndTime();

    _dndStartTime = _parseTime(startTime);
    _dndEndTime = _parseTime(endTime);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// 解析时间字符串
  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// 格式化时间
  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// 切换设备通知
  Future<void> _toggleDeviceNotifications(bool value) async {
    setState(() => _deviceNotificationsEnabled = value);
    await UserSettingsService.setDeviceNotificationsEnabled(value);
    AppUtils.vibrate();
    if (mounted && !value) {
      AppUtils.showSuccess(context, '设备通知已关闭');
    }
  }

  /// 切换商城通知
  Future<void> _toggleMallNotifications(bool value) async {
    setState(() => _mallNotificationsEnabled = value);
    await UserSettingsService.setMallNotificationsEnabled(value);
    AppUtils.vibrate();
    if (mounted && !value) {
      AppUtils.showSuccess(context, '商城通知已关闭');
    }
  }

  /// 切换免打扰
  Future<void> _toggleDnd(bool value) async {
    setState(() => _dndEnabled = value);
    await UserSettingsService.setDndEnabled(value);
    AppUtils.vibrate();
    if (mounted) {
      if (value) {
        AppUtils.showSuccess(context, '免打扰已开启');
      } else {
        AppUtils.showSuccess(context, '免打扰已关闭');
      }
    }
  }

  /// 选择免打扰开始时间
  Future<void> _selectDndStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dndStartTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryBlue,
              onPrimary: Colors.white,
              surface: const Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dndStartTime) {
      setState(() => _dndStartTime = picked);
      await UserSettingsService.setDndStartTime(_formatTime(picked));
      AppUtils.vibrate();
    }
  }

  /// 选择免打扰结束时间
  Future<void> _selectDndEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dndEndTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryBlue,
              onPrimary: Colors.white,
              surface: const Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dndEndTime) {
      setState(() => _dndEndTime = picked);
      await UserSettingsService.setDndEndTime(_formatTime(picked));
      AppUtils.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkSurface,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                ),
              )
            : Column(
                children: [
                  // 顶部导航栏
                  const AppNavbar(
                      title: '通知设置', showNotification: false),
                  // 内容区域
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        children: [
                          // 通知分类设置
                          _buildNotificationSection(),
                          const SizedBox(height: 16),
                          // 免打扰设置
                          _buildDndSection(),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// 通知分类设置
  Widget _buildNotificationSection() {
    return SettingsCard(
      children: [
        SettingsTile(
          icon: Icons.devices_rounded,
          iconBackgroundColor: AppTheme.primaryBlue.withAlpha(40),
          iconColor: AppTheme.primaryBlue,
          title: '设备通知',
          subtitle: '设备状态、电量提醒、连接通知',
          showSwitch: true,
          switchValue: _deviceNotificationsEnabled,
          onSwitchChanged: _toggleDeviceNotifications,
          showArrow: false,
        ),
        SettingsTile(
          icon: Icons.storefront_rounded,
          iconBackgroundColor: AppTheme.accentOrange.withAlpha(40),
          iconColor: AppTheme.accentOrange,
          title: '商城通知',
          subtitle: '订单状态、物流信息、促销活动',
          showSwitch: true,
          switchValue: _mallNotificationsEnabled,
          onSwitchChanged: _toggleMallNotifications,
          showArrow: false,
        ),
      ],
    );
  }

  /// 免打扰设置
  Widget _buildDndSection() {
    return SettingsCard(
      children: [
        // 免打扰开关
        SettingsTile(
          icon: Icons.bedtime_rounded,
          iconBackgroundColor: _dndEnabled
              ? AppTheme.accentOrange.withAlpha(40)
              : Colors.white.withAlpha(15),
          iconColor: _dndEnabled
              ? AppTheme.accentOrange
              : Colors.white70,
          title: '免打扰模式',
          subtitle: _dndEnabled
              ? '${_formatTime(_dndStartTime)} - ${_formatTime(_dndEndTime)} 暂停通知'
              : '设定时间段暂停通知',
          showSwitch: true,
          switchValue: _dndEnabled,
          onSwitchChanged: _toggleDnd,
          showArrow: false,
        ),
        if (_dndEnabled) ...[
          SettingsTile(
            icon: Icons.access_time_rounded,
            title: '开始时间',
            trailing: Text(
              _formatTime(_dndStartTime),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
            onTap: _selectDndStartTime,
          ),
          SettingsTile(
            icon: Icons.access_time_rounded,
            title: '结束时间',
            trailing: Text(
              _formatTime(_dndEndTime),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
            onTap: _selectDndEndTime,
          ),
          // 免打扰说明
          _buildDndInfo(),
        ],
      ],
    );
  }

  Widget _buildDndInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.accentOrange.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentOrange.withAlpha(50),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppTheme.accentOrange.withAlpha(200),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '免打扰时段内，通知将静默接收，不发出声音和震动',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.accentOrange.withAlpha(200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
