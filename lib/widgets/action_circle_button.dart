import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';

/// 圆形动作按钮组件
/// 用于显示带有图标和标签的圆形动作按钮
class ActionCircleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final double size;

  const ActionCircleButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppUtils.vibrate();
        onTap?.call();
      },
      child: SizedBox(
        width: size,
        child: Column(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color.withAlpha(38),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withAlpha(76),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(204),
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// 方形动作按钮组件（用于遥控器屏幕）
class ActionSquareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isExecuting;

  const ActionSquareButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isExecuting = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isExecuting
              ? AppTheme.primaryBlue.withAlpha(64)
              : Colors.white.withAlpha(15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExecuting
                ? AppTheme.primaryBlue.withAlpha(128)
                : Colors.white.withAlpha(20),
          ),
          boxShadow: isExecuting
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withAlpha(51),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isExecuting ? AppTheme.primaryBlue : Colors.white70,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isExecuting ? AppTheme.primaryBlue : Colors.white60,
                fontSize: 11,
                fontWeight: isExecuting ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 模式选择按钮组件
/// 用于显示可选择的模式选项
class ModeSelectorButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? selectedColor;

  const ModeSelectorButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = selectedColor ?? AppTheme.primaryBlue;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? effectiveColor.withAlpha(isDark ? 64 : 51)
              : (isDark
                  ? Colors.white.withAlpha(15)
                  : Colors.black.withAlpha(10)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? effectiveColor.withAlpha(102)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? effectiveColor
                  : Theme.of(context).colorScheme.onSurface.withAlpha(128),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? effectiveColor
                    : Theme.of(context).colorScheme.onSurface.withAlpha(128),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 场景模式按钮组件
/// 用于显示场景选项（如灯光模式、白噪音等）
class SceneButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const SceneButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          AppUtils.vibrate();
          onTap?.call();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withAlpha(38),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withAlpha(51),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(178),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
