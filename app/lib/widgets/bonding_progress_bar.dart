import 'package:flutter/material.dart';

/// 羁绊进度条组件 - 玻璃质感
class BondingProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double height;
  final bool showLabel;
  final String? labelText;

  const BondingProgressBar({
    super.key,
    required this.progress,
    this.color = const Color(0xFF00D4FF),
    this.backgroundColor = const Color(0xFF2A2A3E),
    this.height = 8,
    this.showLabel = false,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            children: [
              // 进度
              ClipRRect(
                borderRadius: BorderRadius.circular(height / 2),
                child: FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          Color.lerp(color, Colors.white, 0.3) ?? color,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 光泽效果
              if (progress > 0 && progress < 1.0)
                Positioned(
                  left: (progress * 100) - 20,
                  top: 0,
                  bottom: 0,
                  width: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 8),
          Text(
            labelText ?? '${(progress * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
