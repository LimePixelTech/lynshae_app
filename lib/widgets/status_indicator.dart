import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// 状态指示器组件
class StatusIndicator extends StatelessWidget {
  final bool isOnline;
  final String? customText;
  final double size;

  const StatusIndicator({
    super.key,
    required this.isOnline,
    this.customText,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) {
    final color = isOnline ? AppColors.successGreen : AppColors.errorRed;
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: isOnline
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
        if (customText != null) ...[
          const SizedBox(width: 8),
          Text(
            customText!,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}
