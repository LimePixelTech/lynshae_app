import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/bonding_model.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

/// 每日任务卡片 - 玻璃质感
class DailyTaskCard extends StatelessWidget {
  final DailyTask task;
  final VoidCallback onClaim;

  const DailyTaskCard({
    super.key,
    required this.task,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final accentColor =
        isCompleted ? AppColors.successGreen : AppColors.primaryBlue;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: isCompleted ? 0.06 : 0.08)
                : Colors.white.withValues(alpha: isCompleted ? 0.55 : 0.65),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: accentColor.withValues(alpha: isDark ? 0.2 : 0.25),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              // 图标
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _getIconData(task.iconName),
                  color: accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // 任务信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: TextStyle(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // 奖励积分
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (isCompleted
                                    ? AppColors.successGreen
                                    : AppColors.warningYellow)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: isCompleted
                                    ? AppColors.successGreen
                                    : AppColors.warningYellow,
                                size: 14,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '+${task.rewardPoints}',
                                style: TextStyle(
                                  color: isCompleted
                                      ? AppColors.successGreen
                                      : AppColors.warningYellow,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isCompleted) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.successGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: AppColors.successGreen,
                                    size: 13),
                                SizedBox(width: 3),
                                Text(
                                  '已完成',
                                  style: TextStyle(
                                    color: AppColors.successGreen,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // 按钮
              if (!isCompleted)
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onClaim,
                      borderRadius: BorderRadius.circular(14),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Text(
                          '领取',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.successGreen, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'pets':
        return Icons.pets_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'security':
        return Icons.security_rounded;
      case 'star':
        return Icons.star_rounded;
      default:
        return Icons.task_alt_rounded;
    }
  }
}
