import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/bonding_model.dart';
import '../theme/app_theme.dart';

/// 羁绊等级进度组件 (大版本，用于详情页)
class BondingLevelProgress extends StatelessWidget {
  final BondingState bonding;

  const BondingLevelProgress({
    super.key,
    required this.bonding,
  });

  @override
  Widget build(BuildContext context) {
    final progress = bonding.progressToNextLevel;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bonding.currentLevel.name,
              style: const TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${bonding.totalPoints}/${bonding.currentLevel.minPoints + (bonding.pointsToNextLevel > 0 ? bonding.pointsToNextLevel + (bonding.totalPoints - bonding.currentLevel.minPoints) : 0)}',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  height: 20,
                  width:
                      MediaQuery.of(context).size.width * 0.85 * progress,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryBlue, Color(0xFF0099CC)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 等级徽章组件
class LevelBadge extends StatelessWidget {
  final BondingLevel level;

  const LevelBadge({
    super.key,
    required this.level,
  });

  Color get _levelColor {
    if (level.minPoints >= 1500) return const Color(0xFFF472B6);
    if (level.minPoints >= 500) return const Color(0xFFFBBF24);
    if (level.minPoints >= 100) return AppTheme.primaryBlue;
    return const Color(0xFF9CA3AF);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: _levelColor.withOpacity(isDark ? 0.15 : 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _levelColor.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events_rounded,
                  color: _levelColor, size: 28),
              const SizedBox(width: 12),
              Text(
                level.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 每日任务卡片 (bonding_widgets 版本)
class DailyQuestCard extends StatelessWidget {
  final DailyTask quest;
  final VoidCallback onClaim;

  const DailyQuestCard({
    super.key,
    required this.quest,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final accentColor =
        quest.isCompleted ? AppTheme.successGreen : AppTheme.primaryBlue;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.07)
                : Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: quest.isCompleted
                  ? AppTheme.successGreen.withOpacity(0.25)
                  : (isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.4)),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconFromTask(quest.iconName),
                  color: accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      quest.description,
                      style: TextStyle(
                        color:
                            theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (quest.isCompleted)
                GestureDetector(
                  onTap: onClaim,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryBlue, Color(0xFF0099CC)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      '领取',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${quest.rewardPoints}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconFromTask(String iconName) {
    switch (iconName) {
      case 'pets':
        return Icons.pets_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'security':
        return Icons.security_rounded;
      default:
        return Icons.task_alt_rounded;
    }
  }
}
