import 'package:flutter/material.dart';
import '../models/bonding_model.dart';
import '../widgets/bonding_progress_bar.dart';
import '../widgets/daily_task_card.dart';
import '../widgets/glass_container.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';

class BondingScreen extends StatefulWidget {
  const BondingScreen({super.key});

  @override
  State<BondingScreen> createState() => _BondingScreenState();
}

class _BondingScreenState extends State<BondingScreen> {
  int currentBondingValue = 1250;

  final List<DailyTask> dailyTasks = [
    DailyTask(
      id: '1',
      title: '互动 5 分钟',
      description: '与机器狗互动至少 5 分钟',
      rewardPoints: 50,
      iconName: 'pets',
      targetProgress: 300,
      isCompleted: true,
    ),
    DailyTask(
      id: '2',
      title: '完成一次握手',
      description: '在互动台让机器狗完成握手动作',
      rewardPoints: 30,
      iconName: 'fitness_center',
      targetProgress: 1,
      isCompleted: true,
    ),
    DailyTask(
      id: '3',
      title: '虚拟喂食',
      description: '给机器狗喂食一次',
      rewardPoints: 20,
      iconName: 'restaurant',
      targetProgress: 1,
      isCompleted: false,
    ),
    DailyTask(
      id: '4',
      title: '完成一次巡逻',
      description: '让机器狗完成一次巡逻任务',
      rewardPoints: 40,
      iconName: 'security',
      targetProgress: 1,
      isCompleted: false,
    ),
  ];

  void _claimReward(DailyTask task) {
    if (task.isCompleted) {
      setState(() => currentBondingValue += task.rewardPoints);
      AppUtils.showSuccess(context, '获得 ${task.rewardPoints} 羁绊值！');
      AppUtils.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = BondingLevel.getLevelForPoints(currentBondingValue);
    final progress = BondingLevel.getProgressToNextLevel(currentBondingValue);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
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
                      borderColor: AppColors.accentPink.withOpacity(0.3),
                      child: const Icon(Icons.favorite_rounded,
                          color: AppColors.accentPink, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '羁绊养成',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '建立与机器狗的深厚情感连接',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 羁绊等级卡片
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassContainer(
                  padding: const EdgeInsets.all(24),
                  color: isDark
                      ? AppTheme.primaryBlue.withOpacity(0.12)
                      : AppTheme.primaryBlue.withOpacity(0.15),
                  borderColor: AppTheme.primaryBlue.withOpacity(0.3),
                  child: Column(
                    children: [
                      // 等级标签
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.emoji_events_rounded,
                                color: AppColors.primaryBlue, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              level.name,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 羁绊值
                      Text(
                        '$currentBondingValue',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        '当前羁绊值',
                        style: TextStyle(
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 进度条
                      BondingProgressBar(
                        progress: progress,
                        color: AppTheme.primaryBlue,
                        backgroundColor:
                            AppTheme.primaryBlue.withOpacity(0.2),
                        height: 10,
                        showLabel: true,
                        labelText:
                            '进度：${(progress * 100).toStringAsFixed(1)}%',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 每日任务标题
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.task_alt_rounded,
                            color: AppColors.primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          '每日任务',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${dailyTasks.where((t) => t.isCompleted).length}/${dailyTasks.length} 完成',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 任务列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 6),
                  child: DailyTaskCard(
                    task: dailyTasks[index],
                    onClaim: () => _claimReward(dailyTasks[index]),
                  ),
                ),
                childCount: dailyTasks.length,
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}
