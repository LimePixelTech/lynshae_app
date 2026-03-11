import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 玻璃质感容器 - 液态毛玻璃效果核心组件
///
/// 特性：
/// - 背景模糊 (BackdropFilter blur) - 透过容器看到模糊的背景内容
/// - 半透明填充 - 营造通透的层级感
/// - 细边框高光 - 0.5px 细线勾勒轮廓
/// - 可选渐变叠加 - 增强质感层次
///
/// 使用示例：
/// ```dart
/// GlassContainer(
///   padding: const EdgeInsets.all(16),
///   borderRadius: 16,
///   child: Text('玻璃质感内容'),
/// )
/// ```
///
/// 主题适配：
/// - 浅色模式：使用 glassLight (半透明白色)
/// - 深色模式：使用 glassDark (半透明深色)
class GlassContainer extends StatelessWidget {
  /// 子组件 - 容器内部显示的内容
  final Widget child;

  /// 圆角半径 - 默认 24，可根据场景调整
  /// 常用值：12(按钮), 16(卡片), 24(容器), 28(底部导航)
  final double borderRadius;

  /// 模糊强度 - 默认 24，值越大越模糊
  /// 范围：10-40，推荐 20-24 获得最佳效果
  final double blur;

  /// 内边距 - 子组件与容器边缘的距离
  final EdgeInsetsGeometry? padding;

  /// 外边距 - 容器与外部的距离
  final EdgeInsetsGeometry? margin;

  /// 宽度 - 容器固定宽度
  final double? width;

  /// 高度 - 容器固定高度
  final double? height;

  /// 背景颜色 - 覆盖默认玻璃色
  /// 如不提供，自动根据主题使用 glassLight/glassDark
  final Color? color;

  /// 边框颜色 - 覆盖默认边框色
  /// 如不提供，自动根据主题使用 glassLightBorder/glassDarkBorder
  final Color? borderColor;

  /// 边框宽度 - 默认 0.5，保持细腻感
  final double borderWidth;

  /// 阴影 - 容器投影效果
  /// 如不提供，自动根据主题生成合适阴影
  final List<BoxShadow>? boxShadow;

  /// 渐变叠加 - 增强质感的渐变层
  final Gradient? gradient;

  /// 使用渐变叠加 - 深色模式下自动添加微妙渐变
  final bool useGradientOverlay;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.blur = 24,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderColor,
    this.borderWidth = 0.5,
    this.boxShadow,
    this.gradient,
    this.useGradientOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 自动计算玻璃颜色
    final effectiveColor = color ?? (isDark
        ? AppTheme.glassDark
        : AppTheme.glassLight);

    // 自动计算边框颜色
    final effectiveBorder = borderColor ?? (isDark
        ? AppTheme.glassDarkBorder
        : AppTheme.glassLightBorder);

    // 自动计算阴影
    final effectiveShadow = boxShadow ?? [
      BoxShadow(
        color: isDark
            ? AppTheme.accentCyan.withAlpha(20)
            : AppTheme.primaryBlue.withAlpha(12),
        blurRadius: isDark ? 24 : 18,
        spreadRadius: -12,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: isDark
            ? AppTheme.primaryBlue.withAlpha(14)
            : AppTheme.accentCyan.withAlpha(8),
        blurRadius: isDark ? 34 : 24,
        spreadRadius: -18,
        offset: const Offset(0, 14),
      ),
    ];

    // 渐变叠加层
    final effectiveGradient = gradient ?? (isDark && useGradientOverlay
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withAlpha(10),
              Colors.white.withAlpha(5),
              Colors.transparent,
            ],
            stops: const [0.0, 0.4, 1.0],
          )
        : (isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.darkElevated.withAlpha(100),
                  AppTheme.darkSurface.withAlpha(150),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withAlpha(180),
                  Colors.white.withAlpha(120),
                ],
              )));

    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: effectiveShadow,
      ),
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
              gradient: effectiveGradient,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 增强玻璃卡片 - 带液态流动感
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool hasShine;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.hasShine = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = GlassContainer(
      margin: margin,
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      useGradientOverlay: true,
      child: Stack(
        children: [
          // 内容
          child,
          // 顶部高光（液态玻璃感）
          if (hasShine)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      isDark
                          ? Colors.white.withAlpha(60)
                          : Colors.white.withAlpha(150),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 150),
          child: card,
        ),
      );
    }

    return card;
  }
}

/// 玻璃按钮
class GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double borderRadius;
  final bool isPrimary;

  const GlassButton({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.borderRadius = 16,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: isPrimary
              ? AppTheme.primaryBlue.withAlpha(isDark ? 230 : 255)
              : (color ?? (isDark
                  ? AppTheme.darkElevated.withAlpha(150)
                  : Colors.white.withAlpha(200))),
          border: isPrimary
              ? null
              : Border.all(
                  color: isDark
                      ? Colors.white.withAlpha(20)
                      : Colors.white.withAlpha(120),
                  width: 0.5,
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withAlpha(60),
                    blurRadius: 20,
                    spreadRadius: -4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withAlpha(60)
                        : AppTheme.gray900.withAlpha(15),
                    blurRadius: 20,
                    spreadRadius: -4,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: child,
      ),
    );
  }
}

/// 玻璃输入框
class GlassInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final int? maxLines;

  const GlassInput({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return GlassContainer(
      borderRadius: 16,
      blur: 12,
      color: isDark
          ? AppTheme.darkElevated.withAlpha(100)
          : Colors.white.withAlpha(180),
      borderColor: isDark
          ? Colors.white.withAlpha(15)
          : Colors.white.withAlpha(100),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: obscureText ? 1 : maxLines,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.gray400,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.gray400,
                  size: 20,
                )
              : null,
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(
                    suffixIcon,
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.gray400,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
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
          // 装饰光球 1 - 右上
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryBlue.withAlpha(isDark ? 40 : 30),
                    AppTheme.primaryBlue.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          // 装饰光球 2 - 左下
          Positioned(
            bottom: 100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentPink.withAlpha(isDark ? 30 : 20),
                    AppTheme.accentPink.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          // 装饰光球 3 - 右中
          Positioned(
            top: 400,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentOrange.withAlpha(isDark ? 20 : 15),
                    AppTheme.accentOrange.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          // 噪点纹理层（深色模式）
          if (isDark)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.darkSurface.withAlpha(50),
                  ],
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}
