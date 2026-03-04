import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 动作按钮组件 - 玻璃质感
class ActionButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isExecuting;

  const ActionButton({
    super.key,
    required this.name,
    required this.icon,
    this.color = AppTheme.primaryBlue,
    required this.onTap,
    this.isExecuting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isExecuting ? null : onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 80,
            height: 90,
            decoration: BoxDecoration(
              gradient: isExecuting
                  ? LinearGradient(
                      colors: [
                        color.withOpacity(0.3),
                        color.withOpacity(0.15),
                      ],
                    )
                  : null,
              color: isExecuting
                  ? null
                  : (isDark
                      ? Colors.white.withOpacity(0.06)
                      : Colors.white.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isExecuting
                    ? color.withOpacity(0.5)
                    : (isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.4)),
                width: isExecuting ? 1.5 : 0.5,
              ),
              boxShadow: isExecuting
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: -3,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isExecuting
                        ? Colors.white.withOpacity(0.2)
                        : color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: isExecuting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(icon, color: color, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(
                    color: isExecuting
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                    fontSize: 12,
                    fontWeight:
                        isExecuting ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 急停按钮 - 保持醒目设计
class EmergencyStopButton extends StatelessWidget {
  final VoidCallback onTap;

  const EmergencyStopButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF4444).withOpacity(0.5),
              blurRadius: 18,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.stop_rounded, color: Colors.white, size: 28),
            Text(
              '急停',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
