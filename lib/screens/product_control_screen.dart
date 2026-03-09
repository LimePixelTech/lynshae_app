import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../widgets/joystick_widget.dart';

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
    final theme = Theme.of(context);

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
      default:
        return _buildGenericControl();
    }
  }

  // 机器狗控制界面
  Widget _buildRobotDogControl() {
    return SafeArea(
      child: Column(
        children: [
          // FPV区域
          Expanded(
            flex: 2,
            child: _buildFPVArea(),
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
                    child: _buildActionButtons([
                      {'icon': Icons.pets, 'label': '握手', 'color': AppTheme.primaryBlue},
                      {'icon': Icons.rotate_right, 'label': '转圈', 'color': AppTheme.accentOrange},
                      {'icon': Icons.emoji_people, 'label': '坐下', 'color': AppTheme.accentPink},
                      {'icon': Icons.directions_walk, 'label': '跟随', 'color': AppTheme.successGreen},
                    ]),
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
            child: _buildFPVArea(),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 互动动作
                  _buildActionButtons([
                    {'icon': Icons.pets, 'label': '蹭腿', 'color': AppTheme.primaryBlue},
                    {'icon': Icons.music_note, 'label': '喵叫', 'color': AppTheme.accentOrange},
                    {'icon': Icons.circle, 'label': '打滚', 'color': AppTheme.accentPink},
                    {'icon': Icons.bed, 'label': '睡觉', 'color': AppTheme.successGreen},
                    {'icon': Icons.toys, 'label': '追球', 'color': Color(0xFFFFD93D)},
                    {'icon': Icons.cleaning_services, 'label': '舔毛', 'color': Color(0xFF6BCB77)},
                  ]),
                  const SizedBox(height: 20),
                  // 情绪状态
                  _buildStatusCard('情绪状态', '开心', Icons.sentiment_very_satisfied, AppTheme.successGreen),
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
            _buildClockDisplay(),
            const SizedBox(height: 32),
            // 闹钟设置
            _buildSectionTitle('闹钟列表'),
            const SizedBox(height: 12),
            _buildAlarmList(),
            const SizedBox(height: 24),
            // 白噪音
            _buildSectionTitle('白噪音'),
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
            _buildSectionTitle('亮度'),
            const SizedBox(height: 12),
            _buildBrightnessSlider(),
            const SizedBox(height: 24),
            // 色温调节
            _buildSectionTitle('色温'),
            const SizedBox(height: 12),
            _buildColorTempSlider(),
            const SizedBox(height: 24),
            // 模式选择
            _buildSectionTitle('场景模式'),
            const SizedBox(height: 12),
            _buildLightModes(),
            const SizedBox(height: 24),
            // 定时开关
            _buildSectionTitle('定时'),
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
            _buildAirQualityCard(),
            const SizedBox(height: 24),
            // 风速调节
            _buildSectionTitle('风速'),
            const SizedBox(height: 12),
            _buildFanSpeedSlider(),
            const SizedBox(height: 24),
            // 模式选择
            _buildSectionTitle('运行模式'),
            const SizedBox(height: 12),
            _buildPurifierModes(),
          ],
        ),
      ),
    );
  }

  // 通用控制界面
  Widget _buildGenericControl() {
    return SafeArea(
      child: Center(
        child: Text(
          '${widget.product.type.name}控制界面开发中',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  // FPV视频区域
  Widget _buildFPVArea() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 模拟视频背景
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam_off,
                      size: 48,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '实时视频流',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 状态叠加层
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 动作按钮组
  Widget _buildActionButtons(List<Map<String, dynamic>> actions) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions.map((action) {
        return GestureDetector(
          onTap: () {
            AppUtils.vibrate();
            AppUtils.showSuccess(context, '执行${action['label']}');
          },
          child: Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: (action['color'] as Color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (action['color'] as Color).withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  action['icon'] as IconData,
                  color: action['color'] as Color,
                  size: 24,
                ),
                const SizedBox(height: 6),
                Text(
                  action['label'] as String,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // 状态卡片
  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 时钟显示
  Widget _buildClockDisplay() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '07:30',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '2026年3月10日 星期二',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
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
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (alarm['enabled'] as bool)
                ? AppTheme.primaryBlue.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                alarm['time'] as String,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: (alarm['enabled'] as bool)
                      ? AppTheme.primaryBlue
                      : Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                alarm['label'] as String,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              Switch.adaptive(
                value: alarm['enabled'] as bool,
                onChanged: (v) {},
                activeColor: AppTheme.primaryBlue,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // 白噪音选项
  Widget _buildSoundOptions() {
    final sounds = [
      {'icon': Icons.water, 'label': '雨声'},
      {'icon': Icons.forest, 'label': '森林'},
      {'icon': Icons.waves, 'label': '海浪'},
      {'icon': Icons.local_fire_department, 'label': '篝火'},
    ];

    return Row(
      children: sounds.map((sound) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              AppUtils.showSuccess(context, '播放${sound['label']}白噪音');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(sound['icon'] as IconData, color: AppTheme.primaryBlue),
                  const SizedBox(height: 8),
                  Text(
                    sound['label'] as String,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 亮度滑块
  Widget _buildBrightnessSlider() {
    return Slider(
      value: 80,
      min: 0,
      max: 100,
      onChanged: (v) {},
      activeColor: AppTheme.primaryBlue,
    );
  }

  // 色温滑块
  Widget _buildColorTempSlider() {
    return Slider(
      value: 50,
      min: 0,
      max: 100,
      onChanged: (v) {},
      activeColor: AppTheme.accentOrange,
    );
  }

  // 灯光模式
  Widget _buildLightModes() {
    final modes = [
      {'icon': Icons.wb_sunny, 'label': '阅读', 'color': Color(0xFFFFD93D)},
      {'icon': Icons.computer, 'label': '电脑', 'color': Color(0xFF00D4FF)},
      {'icon': Icons.bedtime, 'label': '睡前', 'color': Color(0xFF6C5CE7)},
      {'icon': Icons.auto_awesome, 'label': '娱乐', 'color': Color(0xFFFF6B6B)},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: modes.map((mode) {
        return GestureDetector(
          onTap: () {
            AppUtils.showSuccess(context, '切换到${mode['label']}模式');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: (mode['color'] as Color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (mode['color'] as Color).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(mode['icon'] as IconData, color: mode['color'] as Color, size: 18),
                const SizedBox(width: 6),
                Text(
                  mode['label'] as String,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // 定时设置
  Widget _buildTimerSettings() {
    return Row(
      children: [
        Expanded(
          child: _buildTimerButton('30分钟后关闭', Icons.timer),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTimerButton('1小时后关闭', Icons.timer_3),
        ),
      ],
    );
  }

  Widget _buildTimerButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        AppUtils.showSuccess(context, label);
      },
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryBlue.withOpacity(0.15),
        foregroundColor: AppTheme.primaryBlue,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  // 空气质量卡片
  Widget _buildAirQualityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.successGreen.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.air, color: AppTheme.successGreen, size: 32),
              const SizedBox(width: 12),
              Text(
                '空气质量',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '优',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppTheme.successGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'PM2.5: 35 μg/m³',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 风速滑块
  Widget _buildFanSpeedSlider() {
    return Slider(
      value: 60,
      min: 0,
      max: 100,
      onChanged: (v) {},
      activeColor: AppTheme.primaryBlue,
    );
  }

  // 净化器模式
  Widget _buildPurifierModes() {
    final modes = [
      {'icon': Icons.auto_mode, 'label': '自动'},
      {'icon': Icons.speed, 'label': '强力'},
      {'icon': Icons.nights_stay, 'label': '睡眠'},
      {'icon': Icons.timer, 'label': '定时'},
    ];

    return Row(
      children: modes.map((mode) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              AppUtils.showSuccess(context, '切换到${mode['label']}模式');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(mode['icon'] as IconData, color: AppTheme.primaryBlue),
                  const SizedBox(height: 8),
                  Text(
                    mode['label'] as String,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 标题
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
