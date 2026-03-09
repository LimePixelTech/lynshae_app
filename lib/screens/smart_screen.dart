import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';

/// 智能界面 - 包含场景和快捷操作
class SmartScreen extends StatefulWidget {
  const SmartScreen({super.key});

  @override
  State<SmartScreen> createState() => _SmartScreenState();
}

class _SmartScreenState extends State<SmartScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSceneSection(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildAutomationSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        '智能',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  /// 智能场景部分
  Widget _buildSceneSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scenes = [
      {
        'name': '起床模式',
        'icon': Icons.wb_sunny_rounded,
        'color': const Color(0xFFFFD93D),
        'description': '开启窗帘、播放音乐'
      },
      {
        'name': '睡眠模式',
        'icon': Icons.bedtime_rounded,
        'color': const Color(0xFF6C5CE7),
        'description': '关闭灯光、开启白噪音'
      },
      {
        'name': '离家模式',
        'icon': Icons.home_rounded,
        'color': const Color(0xFF00D4FF),
        'description': '关闭所有设备、开启安防'
      },
      {
        'name': '回家模式',
        'icon': Icons.door_front_door_rounded,
        'color': const Color(0xFF4ADE80),
        'description': '开启灯光、调节温度'
      },
      {
        'name': '观影模式',
        'icon': Icons.movie_rounded,
        'color': const Color(0xFFFF6B6B),
        'description': '调暗灯光、开启投影仪'
      },
      {
        'name': '阅读模式',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFF9B59B6),
        'description': '台灯亮度100%、关闭其他灯光'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTextHeadline('智能场景'),
            TextButton.icon(
              onPressed: () {
                Toast.info(context, '添加场景功能开发中');
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('添加'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: scenes.length,
          itemBuilder: (context, index) {
            final scene = scenes[index];
            final color = scene['color'] as Color;
            return GestureDetector(
              onTap: () {
                AppUtils.vibrate();
                Toast.success(context, '${scene['name']}已激活');
              },
              child: GlassContainer(
                padding: const EdgeInsets.all(16),
                borderColor: color.withAlpha(80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        scene['icon'] as IconData,
                        color: color,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    AppTextTitleMedium(
                      scene['name'] as String,
                      color: isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.gray800,
                    ),
                    const SizedBox(height: 4),
                    AppTextOverline(
                      scene['description'] as String,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.gray500,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 快捷操作部分
  Widget _buildQuickActions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextHeadline('快捷操作'),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            _buildQuickAction(
              icon: Icons.power_settings_new_rounded,
              label: '全部开启',
              color: AppTheme.successGreen,
              onTap: () {
                AppUtils.vibrate();
                Toast.success(context, '全部设备已开启');
              },
            ),
            _buildQuickAction(
              icon: Icons.power_off_rounded,
              label: '全部关闭',
              color: AppTheme.errorRed,
              onTap: () {
                AppUtils.vibrate();
                Toast.success(context, '全部设备已关闭');
              },
            ),
            _buildQuickAction(
              icon: Icons.brightness_high_rounded,
              label: '最大亮度',
              color: const Color(0xFFFFD93D),
              onTap: () {
                AppUtils.vibrate();
                Toast.success(context, '所有灯光已调至最亮');
              },
            ),
            _buildQuickAction(
              icon: Icons.brightness_low_rounded,
              label: '夜间模式',
              color: const Color(0xFF6C5CE7),
              onTap: () {
                AppUtils.vibrate();
                Toast.success(context, '已开启夜间模式');
              },
            ),
            _buildQuickAction(
              icon: Icons.lock_rounded,
              label: '一键布防',
              color: const Color(0xFFFF6B6B),
              onTap: () {
                AppUtils.vibrate();
                Toast.success(context, '已开启安防模式');
              },
            ),
            _buildQuickAction(
              icon: Icons.thermostat_rounded,
              label: '恒温26°',
              color: const Color(0xFF00D4FF),
              onTap: () {
                AppUtils.vibrate();
                Toast.success(context, '空调已设为26°C');
              },
            ),
            _buildQuickAction(
              icon: Icons.cleaning_services_rounded,
              label: '开始清扫',
              color: const Color(0xFF4ADE80),
              onTap: () {
                AppUtils.vibrate();
                Toast.success(context, '扫地机器人开始清扫');
              },
            ),
            _buildQuickAction(
              icon: Icons.more_horiz_rounded,
              label: '更多',
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.gray500,
              onTap: () {
                Toast.info(context, '更多快捷操作开发中');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withAlpha(40),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withAlpha(80)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          AppTextOverline(
            label,
            color: isDark
                ? AppTheme.darkTextSecondary
                : AppTheme.gray500,
          ),
        ],
      ),
    );
  }

  /// 自动化部分
  Widget _buildAutomationSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final automations = [
      {
        'name': '日出时开启窗帘',
        'trigger': '日出',
        'action': '开启窗帘',
        'enabled': true,
      },
      {
        'name': '离家自动关闭设备',
        'trigger': '离开家',
        'action': '关闭所有设备',
        'enabled': true,
      },
      {
        'name': '夜间自动调节灯光',
        'trigger': '22:00',
        'action': '调暗灯光',
        'enabled': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTextHeadline('自动化'),
            TextButton.icon(
              onPressed: () {
                Toast.info(context, '添加自动化功能开发中');
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('添加'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: automations.length,
          itemBuilder: (context, index) {
            final auto = automations[index];
            final enabled = auto['enabled'] as bool;
            return GlassContainer(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              borderColor: enabled
                  ? AppTheme.primaryBlue.withAlpha(80)
                  : (isDark
                      ? Colors.white.withAlpha(25)
                      : Colors.white.withAlpha(100)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: enabled
                          ? AppTheme.primaryBlue.withAlpha(40)
                          : (isDark
                              ? AppTheme.darkElevated.withAlpha(100)
                              : AppTheme.gray100),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.auto_mode_rounded,
                      color: enabled
                          ? AppTheme.primaryBlue
                          : (isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.gray400),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextTitleSmall(
                          auto['name'] as String,
                          color: isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.gray800,
                        ),
                        const SizedBox(height: 2),
                        AppTextOverline(
                          '${auto['trigger']} · ${auto['action']}',
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.gray500,
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: enabled,
                    onChanged: (v) {},
                    activeTrackColor: AppTheme.primaryBlue.withAlpha(100),
                    activeThumbColor: AppTheme.primaryBlue,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
