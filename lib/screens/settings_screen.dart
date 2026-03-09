import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../widgets/glass_container.dart';
import '../theme/app_theme.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DeviceModel device = DeviceModel(
    id: 'dog_001',
    name: 'Lynshae',
    macAddress: 'A1:B2:C3:D4:E5:F6',
    firmwareVersion: 'v2.1.0',
  );

  bool isLedOn = true;
  int volume = 80;
  double joystickSensitivity = 0.7;
  TimeOfDay doNotDisturbStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay doNotDisturbEnd = const TimeOfDay(hour: 8, minute: 0);
  bool isUpdating = false;
  double updateProgress = 0.0;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = device.name;
  }

  void _showRenameDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => AlertDialog(
        title: Text('重命名设备',
            style:
                TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: '设备名称',
            hintText: '输入新名称',
          ),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                device = device.copyWith(name: _nameController.text);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('设备名称已更新')),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _startFirmwareUpdate() {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text('固件升级',
              style: TextStyle(color: theme.colorScheme.onSurface)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('发现新版本：v2.2.0',
                  style: TextStyle(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 8),
              Text('更新内容：',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface)),
              Text('• 优化运动稳定性\n• 新增3个动作\n• 修复已知问题',
                  style: TextStyle(
                      color:
                          theme.colorScheme.onSurface.withOpacity(0.7))),
              const SizedBox(height: 16),
              const Text(
                '升级过程中请保持设备连接，不要断开电源。',
                style: TextStyle(
                    color: AppTheme.warningYellow, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('稍后再说'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _performUpdate();
              },
              child: const Text('立即升级'),
            ),
          ],
        );
      },
    );
  }

  void _performUpdate() {
    setState(() {
      isUpdating = true;
      updateProgress = 0.0;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => updateProgress = 0.2);
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => updateProgress = 0.5);
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => updateProgress = 0.8);
    });
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          updateProgress = 1.0;
          isUpdating = false;
          device = device.copyWith(firmwareVersion: 'v2.2.0');
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('固件升级成功！'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isUpdating
          ? _buildUpdateProgress(theme, isDark)
          : SafeArea(
              child: CustomScrollView(
                slivers: [
                  // 顶部标题
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          GlassContainer(
                            padding: const EdgeInsets.all(12),
                            borderRadius: 16,
                            child: Icon(Icons.settings_rounded,
                                size: 24,
                                color: theme.colorScheme.onSurface),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '设备设置',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 基础信息
                  SliverToBoxAdapter(
                    child: _buildGlassSection(
                      title: '基础信息',
                      children: [
                        _buildInfoTile(
                          theme: theme,
                          icon: Icons.pets_rounded,
                          label: '设备名称',
                          value: device.name,
                          onTap: _showRenameDialog,
                          trailing: Icon(Icons.edit_rounded,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.3),
                              size: 18),
                        ),
                        _buildDivider(isDark),
                        _buildInfoTile(
                          theme: theme,
                          icon: Icons.wifi_tethering_rounded,
                          label: 'MAC地址',
                          value: device.macAddress,
                        ),
                        _buildDivider(isDark),
                        _buildInfoTile(
                          theme: theme,
                          icon: Icons.system_update_rounded,
                          label: '固件版本',
                          value: device.firmwareVersion,
                          onTap: device.firmwareVersion != 'v2.2.0'
                              ? _startFirmwareUpdate
                              : null,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: device.firmwareVersion == 'v2.2.0'
                                  ? AppTheme.successGreen.withOpacity(0.15)
                                  : AppTheme.warningYellow
                                      .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              device.firmwareVersion == 'v2.2.0'
                                  ? '已是最新'
                                  : '有新版本',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    device.firmwareVersion == 'v2.2.0'
                                        ? AppTheme.successGreen
                                        : AppTheme.warningYellow,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 功能设置
                  SliverToBoxAdapter(
                    child: _buildGlassSection(
                      title: '功能设置',
                      children: [
                        _buildSwitchTile(
                          theme: theme,
                          icon: Icons.lightbulb_outline_rounded,
                          label: 'LED指示灯',
                          value: isLedOn,
                          onChanged: (v) => setState(() => isLedOn = v),
                        ),
                        _buildDivider(isDark),
                        _buildSliderTile(
                          theme: theme,
                          icon: volume > 0
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                          label: '音量设置',
                          value: volume.toDouble(),
                          max: 100,
                          divisions: 20,
                          suffix: '$volume%',
                          onChanged: (v) =>
                              setState(() => volume = v.toInt()),
                        ),
                        _buildDivider(isDark),
                        _buildSliderTile(
                          theme: theme,
                          icon: Icons.gamepad_rounded,
                          label: '摇杆灵敏度',
                          value: joystickSensitivity,
                          min: 0.3,
                          max: 1.0,
                          divisions: 7,
                          suffix:
                              '${(joystickSensitivity * 100).toInt()}%',
                          onChanged: (v) =>
                              setState(() => joystickSensitivity = v),
                        ),
                      ],
                    ),
                  ),

                  // 勿扰设置
                  SliverToBoxAdapter(
                    child: _buildGlassSection(
                      title: '勿扰设置',
                      children: [
                        _buildInfoTile(
                          theme: theme,
                          icon: Icons.nights_stay_rounded,
                          label: '勿扰开始时间',
                          value:
                              '${doNotDisturbStart.hour.toString().padLeft(2, '0')}:${doNotDisturbStart.minute.toString().padLeft(2, '0')}',
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: doNotDisturbStart,
                            );
                            if (time != null) {
                              setState(
                                  () => doNotDisturbStart = time);
                            }
                          },
                          trailing: Icon(Icons.chevron_right_rounded,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.3)),
                        ),
                        _buildDivider(isDark),
                        _buildInfoTile(
                          theme: theme,
                          icon: Icons.wb_sunny_rounded,
                          label: '勿扰结束时间',
                          value:
                              '${doNotDisturbEnd.hour.toString().padLeft(2, '0')}:${doNotDisturbEnd.minute.toString().padLeft(2, '0')}',
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: doNotDisturbEnd,
                            );
                            if (time != null) {
                              setState(
                                  () => doNotDisturbEnd = time);
                            }
                          },
                          trailing: Icon(Icons.chevron_right_rounded,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.3)),
                        ),
                      ],
                    ),
                  ),

                  // 帮助与反馈
                  SliverToBoxAdapter(
                    child: _buildGlassSection(
                      title: '帮助与反馈',
                      children: [
                        _buildActionTile(
                            theme: theme,
                            icon: Icons.help_outline_rounded,
                            label: '常见问题',
                            onTap: () {}),
                        _buildDivider(isDark),
                        _buildActionTile(
                            theme: theme,
                            icon: Icons.bug_report_outlined,
                            label: '故障排查',
                            onTap: () {}),
                        _buildDivider(isDark),
                        _buildActionTile(
                            theme: theme,
                            icon: Icons.headset_mic_outlined,
                            label: '联系客服',
                            onTap: () {}),
                      ],
                    ),
                  ),

                  const SliverPadding(
                      padding: EdgeInsets.only(bottom: 100)),
                ],
              ),
            ),
    );
  }

  Widget _buildUpdateProgress(ThemeData theme, bool isDark) {
    return Center(
      child: GlassContainer(
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.system_update_rounded,
                size: 64, color: AppTheme.primaryBlue),
            const SizedBox(height: 24),
            Text(
              '正在升级固件...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '请勿断开设备连接',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: updateProgress,
                  backgroundColor: AppTheme.primaryBlue.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryBlue),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${(updateProgress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassSection({
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          GlassContainer(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: isDark
          ? Colors.white.withOpacity(0.06)
          : Colors.black.withOpacity(0.06),
    );
  }

  Widget _buildThemeSelector(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.palette_outlined,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              size: 22),
          const SizedBox(width: 12),
          Text('主题模式',
              style: TextStyle(color: theme.colorScheme.onSurface)),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildThemeBtn(
                    Icons.light_mode_rounded, ThemeMode.light, theme),
                _buildThemeBtn(Icons.phone_android_rounded,
                    ThemeMode.system, theme),
                _buildThemeBtn(
                    Icons.dark_mode_rounded, ThemeMode.dark, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeBtn(
      IconData icon, ThemeMode mode, ThemeData theme) {
    final isSelected = SmartDogApp.themeNotifier.value == mode;
    return GestureDetector(
      onTap: () {
        SmartDogApp.themeNotifier.value = mode;
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected
              ? AppTheme.primaryBlue
              : theme.colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon,
          color: theme.colorScheme.onSurface.withOpacity(0.5), size: 22),
      title: Text(label,
          style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14)),
      subtitle: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon,
          color: theme.colorScheme.onSurface.withOpacity(0.5), size: 22),
      title: Text(label,
          style: TextStyle(color: theme.colorScheme.onSurface)),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryBlue,
    );
  }

  Widget _buildSliderTile({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required double value,
    double min = 0,
    required double max,
    required int divisions,
    required String suffix,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  size: 22),
              const SizedBox(width: 12),
              Text(label,
                  style:
                      TextStyle(color: theme.colorScheme.onSurface)),
              const Spacer(),
              Text(suffix,
                  style: TextStyle(
                      color: theme.colorScheme.onSurface
                          .withOpacity(0.6),
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon,
          color: theme.colorScheme.onSurface.withOpacity(0.5), size: 22),
      title: Text(label,
          style: TextStyle(color: theme.colorScheme.onSurface)),
      trailing: Icon(Icons.chevron_right_rounded,
          color: theme.colorScheme.onSurface.withOpacity(0.3)),
      onTap: onTap,
    );
  }
}
