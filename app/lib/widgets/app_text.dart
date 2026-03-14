import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 文字样式规范 - 统一排版系统
///
/// 提供统一的文字大小、字重和颜色，确保整个应用的排版一致性。
/// 所有样式自动适配当前主题（浅色/深色模式）。
///
/// 排版层级：
/// - Display: 页面大标题 (32-34号)
/// - Headline: 区块标题 (18-22号)
/// - Title: 卡片/列表标题 (15-17号)
/// - Body: 正文内容 (13-16号)
/// - Caption: 辅助说明 (11-12号)
///
/// 使用示例：
/// ```dart
/// // 直接获取样式
/// Text('标题', style: AppText.headline(context))
///
/// // 使用快捷组件
/// AppTextHeadline('区块标题')
/// AppTextBody('正文内容')
/// ```
class AppText {
  // === 大号标题 (Display) ===
  // 用于页面顶部大标题、欢迎语等重要信息

  /// 页面大标题 - 32号字
  ///
  /// 用途：页面顶部主标题、品牌名称
  /// 字重：Bold (700)
  /// 字间距：-0.5（紧凑）
  /// 行高：1.2
  static TextStyle displayLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: color ?? _onSurfaceColor(context),
      letterSpacing: -0.5,
      height: 1.2,
    );
  }

  /// 页面副标题 - 28号字
  ///
  /// 用途：副标题、重要数值展示
  /// 字重：Bold (700)
  static TextStyle displayMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: color ?? _onSurfaceColor(context),
      letterSpacing: -0.5,
      height: 1.3,
    );
  }

  /// 区块大标题 - 22号字
  ///
  /// 用途：区块标题、卡片大标题
  static TextStyle displaySmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: color ?? _onSurfaceColor(context),
      letterSpacing: -0.3,
      height: 1.3,
    );
  }

  // === 中号标题 (Headline & Title) ===
  // 用于区块标题、卡片标题

  /// 区块标题 - 18号字
  ///
  /// 用途：主要区块标题，如"智能场景"、"我的设备"
  /// 字重：SemiBold (600)
  static TextStyle headline(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? _onSurfaceColor(context),
      height: 1.4,
    );
  }

  /// 列表标题 (16-17)
  static TextStyle title(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: color ?? _onSurfaceColor(context),
      height: 1.4,
    );
  }

  /// 卡片标题 (16)
  static TextStyle titleMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? _onSurfaceColor(context),
      height: 1.4,
    );
  }

  /// 小标题 (15)
  static TextStyle titleSmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: color ?? _onSurfaceColor(context),
      height: 1.4,
    );
  }

  // === 正文 ===
  /// 主要正文 (16)
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color ?? _onSurfaceColor(context),
      height: 1.5,
    );
  }

  /// 次要正文 (14)
  static TextStyle body(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color ?? _onSurfaceColor(context),
      height: 1.5,
    );
  }

  /// 小正文 (13)
  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: color ?? _secondaryColor(context),
      height: 1.5,
    );
  }

  // === 辅助文字 ===
  /// 说明文字 (12)
  static TextStyle caption(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color ?? _secondaryColor(context),
      height: 1.5,
    );
  }

  /// 最小文字 (11)
  static TextStyle overline(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: color ?? _tertiaryColor(context),
      height: 1.5,
      letterSpacing: 0.3,
    );
  }

  /// 按钮文字
  static TextStyle button(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      height: 1.3,
    );
  }

  /// 标签文字
  static TextStyle label(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color ?? _secondaryColor(context),
      height: 1.3,
    );
  }

  // === 快捷样式 ===
  /// 品牌色文字
  static TextStyle primary(BuildContext context) {
    return body(context, color: AppTheme.primaryBlue);
  }

  /// 成功色文字
  static TextStyle success(BuildContext context) {
    return body(context, color: AppTheme.successGreen);
  }

  /// 警告色文字
  static TextStyle warning(BuildContext context) {
    return body(context, color: AppTheme.warningYellow);
  }

  /// 错误色文字
  static TextStyle error(BuildContext context) {
    return body(context, color: AppTheme.errorRed);
  }

  // === 私有方法 ===
  static Color _onSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color _secondaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppTheme.darkTextSecondary : AppTheme.gray500;
  }

  static Color _tertiaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppTheme.darkTextSecondary.withAlpha(150) : AppTheme.gray400;
  }
}

/// 便捷文字组件
class AppTextDisplayLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextDisplayLarge(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.displayLarge(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextDisplayMedium extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextDisplayMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.displayMedium(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextDisplaySmall extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextDisplaySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.displaySmall(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextHeadline extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextHeadline(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.headline(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextTitle extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextTitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.title(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextTitleMedium extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextTitleMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.titleMedium(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextTitleSmall extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextTitleSmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.titleSmall(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextBodyLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextBodyLarge(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.bodyLarge(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextBody extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextBody(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.body(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextBodySmall extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextBodySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.bodySmall(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextCaption extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextCaption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.caption(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextOverline extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppTextOverline(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.overline(context, color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class AppTextButton extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;

  const AppTextButton(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.button(context, color: color),
      textAlign: textAlign,
    );
  }
}
