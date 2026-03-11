import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../widgets/joystick_widget.dart';
import '../widgets/app_slider.dart';
import '../widgets/section_title.dart';
import '../widgets/common_widgets.dart';
import '../widgets/action_circle_button.dart';
import '../widgets/status_card.dart';

/// 产品控制工厂页面
/// 根据产品类型展示不同的控制界面
class ProductControlScreen extends StatefulWidget {
  final Product product;

  const ProductControlScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductControlScreen> createState() => _ProductControlScreenState();
}

class _ProductControlScreenState extends State<ProductControlScreen> {
  bool isEmergencyStopped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient(context),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.product.name),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _buildControlBody(),
      ),
    );
  }

  Widget _buildControlBody() {
    switch (widget.product.type) {
      case ProductType.robotDog:
        return _buildRobotDogControl();
      case ProductType.robotCat:
        return _buildRobotCatControl();
      case ProductType.smartClock:
        return _buildSmartClockControl();
      case ProductType.smartLamp:
        return _buildSmartLampControl();
      case ProductType.airPurifier:
        return _buildAirPurifierControl();
    }
  }

  // 机器狗控制界面
  Widget _buildRobotDogControl() {
    return SafeArea(
      child: Column(
        children: [
          // FPV 区域
          Expanded(
            flex: 2,
            child: FPVArea(),
          ),
          // 控制区域
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 摇杆
                  Expanded(
                    child: JoystickWidget(
                      size: 160,
                      onChange: (angle, distance) {
                        // 处理移动
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  // 动作按钮
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ActionCircleButton(
                          icon: Icons.pets,
                          label: '握手',
                          color: AppTheme.primaryBlue,
                          onTap: () => _onActionExecuted('握手'),
                        ),
                        ActionCircleButton(
                          icon: Icons.rotate_right,
                          label: '转圈',
                          color: AppTheme.accentOrange,
                          onTap: () => _onActionExecuted('转圈'),
                        ),
                        ActionCircleButton(
                          icon: Icons.emoji_people,
                          label: '坐下',
                          color: AppTheme.accentPink,
                          onTap: () => _onActionExecuted('坐下'),
                        ),
                        ActionCircleButton(
                          icon: Icons.directions_walk,
                          label: '跟随',
                          color: AppTheme.successGreen,
                          onTap: () => _onActionExecuted('跟随'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 紧急停止按钮
          if (isEmergencyStopped)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => isEmergencyStopped = false);
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('恢复控制'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 机器猫控制界面
  Widget _buildRobotCatControl() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: FPVArea(),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 互动动作
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ActionCircleButton(
                        icon: Icons.pets,
                        label: '蹭腿',
                        color: AppTheme.primaryBlue,
                        onTap: () => _onActionExecuted('蹭腿'),
                      ),
                      ActionCircleButton(
                        icon: Icons.music_note,
                        label: '喵叫',
                        color: AppTheme.accentOrange,
                        onTap: () => _onActionExecuted('喵叫'),
                      ),
                      ActionCircleButton(
                        icon: Icons.circle,
                        label: '打滚',
                        color: AppTheme.accentPink,
                        onTap: () => _onActionExecuted('打滚'),
                      ),
                      ActionCircleButton(
                        icon: Icons.bed,
                        label: '睡觉',
                        color: AppTheme.successGreen,
                        onTap: () => _onActionExecuted('睡觉'),
                      ),
                      ActionCircleButton(
                        icon: Icons.toys,
                        label: '追球',
                        color: const Color(0xFFFFD93D),
                        onTap: () => _onActionExecuted('追球'),
                      ),
                      ActionCircleButton(
                        icon: Icons.cleaning_services,
                        label: '舔毛',
                        color: const Color(0xFF6BCB77),
                        onTap: () => _onActionExecuted('舔毛'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 情绪状态
                  InfoCard(
                    title: '情绪状态',
                    value: '开心',
                    icon: Icons.sentiment_very_satisfied,
                    color: AppTheme.successGreen,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 智能闹钟控制界面
  Widget _buildSmartClockControl() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 时间显示
            const ClockDisplay(time: '07:30', date: '2026 年 3 月 10 日 星期二'),
            const SizedBox(height: 32),
            // 闹钟设置
            const SimpleSectionTitle(title: '闹钟列表'),
            const SizedBox(height: 12),
            _buildAlarmList(),
            const SizedBox(height: 24),
            // 白噪音
            const SimpleSectionTitle(title: '白噪音'),
            const SizedBox(height: 12),
            _buildSoundOptions(),
          ],
        ),
      ),
    );
  }

  // 智能台灯控制界面
  Widget _buildSmartLampControl() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 亮度调节
            const SimpleSectionTitle(title: '亮度'),
            const SizedBox(height: 12),
            AppSlider(value: 80, onChanged: (v) {}),
            const SizedBox(height: 24),
            // 色温调节
            const SimpleSectionTitle(title: '色温'),
            const SizedBox(height: 12),
            AppSlider(value: 50, onChanged: (v) {}, activeColor: AppTheme.accentOrange),
            const SizedBox(height: 24),
            // 模式选择
            const SimpleSectionTitle(title: '场景模式'),
            const SizedBox(height: 12),
            _buildLightModes(),
            const SizedBox(height: 24),
            // 定时开关
            const SimpleSectionTitle(title: '定时'),
            const SizedBox(height: 12),
            _buildTimerSettings(),
          ],
        ),
      ),
    );
  }

  // 空气净化器控制界面
  Widget _buildAirPurifierControl() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 空气质量
            LargeStatusCard(
              title: '空气质量',
              mainValue: '优',
              subtitle: 'PM2.5: 35 μg/m³',
              icon: Icons.air,
              color: AppTheme.successGreen,
            ),
            const SizedBox(height: 24),
            // 风速调节
            const SimpleSectionTitle(title: '风速'),
            const SizedBox(height: 12),
            AppSlider(value: 60, onChanged: (v) {}),
            const SizedBox(height: 24),
            // 模式选择
            const SimpleSectionTitle(title: '运行模式'),
            const SizedBox(height: 12),
            _buildPurifierModes(),
          ],
        ),
      ),
    );
  }

  void _onActionExecuted(String actionName) {
    AppUtils.showSuccess(context, '执行$actionName');
  }

  // 闹钟列表
  Widget _buildAlarmList() {
    final alarms = [
      {'time': '07:30', 'label': '起床', 'enabled': true},
      {'time': '08:45', 'label': '出门', 'enabled': true},
      {'time': '22:30', 'label': '睡觉', 'enabled': false},
    ];

    return Column(
      children: alarms.map((alarm) {
        return AlarmListItem(
          time: alarm['time'] as String,
          label: alarm['label'] as String,
          enabled: alarm['enabled'] as bool,
          onChanged: (v) {},
        );
      }).toList(),
    );
  }

  // 白噪音选项
  Widget _buildSoundOptions() {
    return Row(
      children: [
        SceneButton(
          icon: Icons.water,
          label: '雨声',
          color: AppTheme.primaryBlue,
          onTap: () => AppUtils.showSuccess(context, '播放雨声白噪音'),
        ),
        SceneButton(
          icon: Icons.forest,
          label: '森林',
          color: AppTheme.primaryBlue,
          onTap: () => AppUtils.showSuccess(context, '播放森林白噪音'),
        ),
        SceneButton(
          icon: Icons.waves,
          label: '海浪',
          color: AppTheme.primaryBlue,
          onTap: () => AppUtils.showSuccess(context, '播放海浪白噪音'),
        ),
        SceneButton(
          icon: Icons.local_fire_department,
          label: '篝火',
          color: AppTheme.primaryBlue,
          onTap: () => AppUtils.showSuccess(context, '播放篝火白噪音'),
        ),
      ],
    );
  }

  // 灯光模式
  Widget _buildLightModes() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ModeSelectorButton(
          label: '阅读',
          icon: Icons.wb_sunny,
          isSelected: false,
          selectedColor: const Color(0xFFFFD93D),
          onTap: () => AppUtils.showSuccess(context, '切换到阅读模式'),
        ),
        ModeSelectorButton(
          label: '电脑',
          icon: Icons.computer,
          isSelected: false,
          selectedColor: const Color(0xFF00D4FF),
          onTap: () => AppUtils.showSuccess(context, '切换到电脑模式'),
        ),
        ModeSelectorButton(
          label: '睡前',
          icon: Icons.bedtime,
          isSelected: false,
          selectedColor: const Color(0xFF6C5CE7),
          onTap: () => AppUtils.showSuccess(context, '切换到睡前模式'),
        ),
        ModeSelectorButton(
          label: '娱乐',
          icon: Icons.auto_awesome,
          isSelected: false,
          selectedColor: const Color(0xFFFF6B6B),
          onTap: () => AppUtils.showSuccess(context, '切换到娱乐模式'),
        ),
      ],
    );
  }

  // 定时设置
  Widget _buildTimerSettings() {
    return Row(
      children: [
        TimerButton(
          label: '30 分钟后关闭',
          icon: Icons.timer,
          onTap: () => AppUtils.showSuccess(context, '30 分钟后关闭'),
        ),
        const SizedBox(width: 8),
        TimerButton(
          label: '1 小时后关闭',
          icon: Icons.timer_3,
          onTap: () => AppUtils.showSuccess(context, '1 小时后关闭'),
        ),
      ],
    );
  }

  // 净化器模式
  Widget _buildPurifierModes() {
    return Row(
      children: [
        SceneButton(
          icon: Icons.auto_mode,
          label: '自动',
          color: AppTheme.primaryBlue,
          onTap: () => AppUtils.showSuccess(context, '切换到自动模式'),
        ),
        SceneButton(
          icon: Icons.speed,
          label: '强力',
          color: AppTheme.primaryBlue,
          onTap: () => AppUtils.showSuccess(context, '切换到强力模式'),
        ),
        SceneButton(
          icon: Icons.nights_stay,
          label: '睡眠',
          color: AppTheme.primaryBlue,
          onTap: () => AppUtils.showSuccess(context, '切换到睡眠模式'),
        ),
        SceneButton(
          icon: Icons.timer,
          label: '定时',
          color: AppTheme.primaryBlue,
          onTap: () => AppUtils.showSuccess(context, '切换到定时模式'),
        ),
      ],
    );
  }
}
