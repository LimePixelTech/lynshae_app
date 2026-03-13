import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';

/// 智能页面 - 米家风格场景与自动化
class SmartScreen extends StatefulWidget {
  const SmartScreen({super.key});

  @override
  State<SmartScreen> createState() => _SmartScreenState();
}

class _SmartScreenState extends State<SmartScreen> {
  // 智能场景数据
  final List<Map<String, dynamic>> scenes = [
    {
      'name': '起床模式',
      'icon': Icons.wb_sunny_rounded,
      'devices': ['窗帘', '灯光'],
    },
    {
      'name': '睡眠模式',
      'icon': Icons.bedtime_rounded,
      'devices': ['灯光', '机器狗'],
    },
    {
      'name': '离家模式',
      'icon': Icons.home_outlined,
      'devices': ['全部设备'],
    },
    {
      'name': '回家模式',
      'icon': Icons.door_front_door_outlined,
      'devices': ['灯光', '空调'],
    },
  ];

  // 自动化数据
  final List<Map<String, dynamic>> automations = [
    {
      'name': '有人开灯',
      'trigger': '人体感应',
      'action': '开启挂灯',
      'enabled': true,
      'icon': Icons.lightbulb_outline,
    },
    {
      'name': '无人关灯',
      'trigger': '5 分钟无人',
      'action': '关闭挂灯',
      'enabled': true,
      'icon': Icons.lightbulb,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // 顶部标题
              _buildHeader(),
              const SizedBox(height: 20),
              // 场景网格
              _buildSceneGrid(),
              const SizedBox(height: 24),
              // 自动化列表
              _buildAutomationSection(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '智能',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            _buildHeaderIcon(Icons.notifications_outlined),
            const SizedBox(width: 12),
            _buildHeaderIcon(Icons.add_rounded),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: Colors.white70,
        size: 22,
      ),
    );
  }

  Widget _buildSceneGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '我的智能',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.filter_list_outlined,
              color: Colors.white54,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: scenes.length,
          itemBuilder: (context, index) {
            final scene = scenes[index];
            return _buildSceneCard(scene);
          },
        ),
      ],
    );
  }

  Widget _buildSceneCard(Map<String, dynamic> scene) {
    return GestureDetector(
      onTap: () {
        AppUtils.vibrate();
        AppUtils.showSuccess(context, '${scene['name']} 已激活');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                scene['icon'] as IconData,
                color: Colors.white,
                size: 22,
              ),
            ),
            const Spacer(),
            Text(
              scene['name'] as String,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              (scene['devices'] as List<String>).join(' · '),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutomationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '自动化',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: automations.asMap().entries.map((entry) {
              final index = entry.key;
              final auto = entry.value;
              return Column(
                children: [
                  _buildAutomationItem(auto),
                  if (index < automations.length - 1)
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
        ),
      ],
    );
  }

  Widget _buildAutomationItem(Map<String, dynamic> auto) {
    final enabled = auto['enabled'] as bool;

    return Container(
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
              auto['icon'] as IconData,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auto['name'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${auto['trigger']} → ${auto['action']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            onChanged: (v) {},
            activeTrackColor: AppTheme.successGreen.withAlpha(100),
            activeThumbColor: AppTheme.successGreen,
          ),
        ],
      ),
    );
  }
}
