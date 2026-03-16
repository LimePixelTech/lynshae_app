import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 通用章节标题组件
/// 用于显示 section 标题
class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final bool showDivider;

  const SectionTitle({
    super.key,
    required this.title,
    this.trailing,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (trailing != null) ...[
              const Spacer(),
              trailing!,
            ],
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 12),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.outline.withAlpha(76),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ] else ...[
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

/// 简易章节标题（不带分割线）
class SimpleSectionTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;

  const SimpleSectionTitle({
    super.key,
    required this.title,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// 带图标的章节标题
class IconSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;

  const IconSectionTitle({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppTheme.primaryBlue;
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
