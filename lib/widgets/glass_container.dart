import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 玻璃质感容器 - 毛玻璃效果核心组件
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blur = 20,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderColor,
    this.borderWidth = 0.5,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ??
        (isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.65));
    final effectiveBorder = borderColor ??
        (isDark
            ? Colors.white.withOpacity(0.12)
            : Colors.white.withOpacity(0.5));

    return Container(
      margin: margin,
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: effectiveColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: effectiveBorder,
                width: borderWidth,
              ),
              boxShadow: boxShadow,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 渐变背景 + 装饰光球
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient(context),
      ),
      child: Stack(
        children: [
          // 装饰光球 1 - 右上蓝色
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryBlue.withOpacity(isDark ? 0.15 : 0.12),
                    AppTheme.primaryBlue.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          // 装饰光球 2 - 左下粉色
          Positioned(
            bottom: 120,
            left: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentPink.withOpacity(isDark ? 0.1 : 0.08),
                    AppTheme.accentPink.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          // 装饰光球 3 - 右中橙色
          Positioned(
            top: 350,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentOrange.withOpacity(isDark ? 0.06 : 0.06),
                    AppTheme.accentOrange.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
