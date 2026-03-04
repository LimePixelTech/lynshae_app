import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/joystick_widget.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool isEmergencyStopped = false;
  double signalStrength = 85;
  int latency = 45;
  int batteryLevel = 78;

  final List<Map<String, dynamic>> actions = [
    {'id': 'shake', 'name': '握手', 'icon': Icons.front_hand},
    {'id': 'spin', 'name': '转圈', 'icon': Icons.rotate_right},
    {'id': 'bow', 'name': '作揖', 'icon': Icons.emoji_people},
    {'id': 'sit', 'name': '坐下', 'icon': Icons.chair},
    {'id': 'stand', 'name': '站立', 'icon': Icons.accessibility_new},
  ];

  String? executingAction;

  void _executeAction(String actionId) {
    if (isEmergencyStopped) return;
    setState(() => executingAction = actionId);
    AppUtils.vibrate();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => executingAction = null);
    });
  }

  void _emergencyStop() {
    setState(() => isEmergencyStopped = !isEmergencyStopped);
    AppUtils.vibrate(duration: const Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEmergencyStopped ? '已紧急停止' : '已恢复控制',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isEmergencyStopped ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onJoystickMove(double angle, double distance) {
    if (isEmergencyStopped) return;
    debugPrint('Joystick: angle=$angle, distance=$distance');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0E21),
              Color(0xFF151530),
              Color(0xFF1A1035),
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildVideoBackground(),
            // 装饰光球
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primaryBlue.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              left: -60,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accentPink.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildTopStatusBar(),
                  const Spacer(),
                  _buildControlLayer(),
                ],
              ),
            ),
            // 返回按钮
            Positioned(
              top: 50,
              left: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.15)),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ),
            ),
            // 紧急停止按钮
            Positioned(
              top: 100,
              right: 16,
              child: _buildEmergencyButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton() {
    return GestureDetector(
      onTap: _emergencyStop,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isEmergencyStopped ? Colors.orange : Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isEmergencyStopped ? Colors.orange : Colors.red)
                  .withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          isEmergencyStopped ? Icons.play_arrow : Icons.stop,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildVideoBackground() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off,
                size: 64, color: Colors.white.withOpacity(0.12)),
            const SizedBox(height: 16),
            Text(
              'FPV 视频流',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.2), fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '开发模式下显示模拟画面',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.12), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStatusBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatusChip(
            icon: Icons.wifi,
            label: '信号',
            value: '${signalStrength.toInt()}%',
            color: signalStrength > 50
                ? AppColors.successGreen
                : AppColors.warningYellow,
          ),
          _buildStatusChip(
            icon: Icons.timer,
            label: '延迟',
            value: '$latency ms',
            color: latency < 100
                ? AppColors.successGreen
                : AppColors.warningYellow,
          ),
          _buildStatusChip(
            icon: Icons.battery_full,
            label: '电量',
            value: '$batteryLevel%',
            color: AppUtils.getBatteryColor(batteryLevel),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 9)),
                  Text(value,
                      style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlLayer() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 摇杆
          Expanded(
            flex: 2,
            child: JoystickWidget(
              onChange: _onJoystickMove,
              isDisabled: isEmergencyStopped,
            ),
          ),
          const SizedBox(height: 20),
          // 动作按钮
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '动作控制',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: actions.map((action) {
                            return _buildActionButton(
                              icon: action['icon'],
                              label: action['name'],
                              actionId: action['id'],
                              isExecuting:
                                  executingAction == action['id'],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String actionId,
    bool isExecuting = false,
  }) {
    return GestureDetector(
      onTap: () => _executeAction(actionId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isExecuting
              ? AppTheme.primaryBlue.withOpacity(0.25)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExecuting
                ? AppTheme.primaryBlue.withOpacity(0.5)
                : Colors.white.withOpacity(0.08),
          ),
          boxShadow: isExecuting
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isExecuting ? AppTheme.primaryBlue : Colors.white70,
                size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isExecuting ? AppTheme.primaryBlue : Colors.white60,
                fontSize: 11,
                fontWeight:
                    isExecuting ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
