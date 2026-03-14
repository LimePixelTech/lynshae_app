import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_text.dart';

/// 按钮类型
enum ButtonType {
  primary,
  secondary,
  outline,
  ghost,
  danger,
}

/// 按钮尺寸
enum ButtonSize {
  small,
  medium,
  large,
}

/// 统一按钮组件
class AppButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onTap;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;
  final IconData? icon;
  final IconData? suffixIcon;

  const AppButton({
    super.key,
    this.text,
    this.child,
    this.onTap,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.icon,
    this.suffixIcon,
  });

  /// 主要按钮
  const AppButton.primary({
    super.key,
    this.text,
    this.child,
    this.onTap,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.icon,
    this.suffixIcon,
  }) : type = ButtonType.primary;

  /// 次要按钮
  const AppButton.secondary({
    super.key,
    this.text,
    this.child,
    this.onTap,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.icon,
    this.suffixIcon,
  }) : type = ButtonType.secondary;

  /// 边框按钮
  const AppButton.outline({
    super.key,
    this.text,
    this.child,
    this.onTap,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.icon,
    this.suffixIcon,
  }) : type = ButtonType.outline;

  /// 幽灵按钮
  const AppButton.ghost({
    super.key,
    this.text,
    this.child,
    this.onTap,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.icon,
    this.suffixIcon,
  }) : type = ButtonType.ghost;

  /// 危险按钮
  const AppButton.danger({
    super.key,
    this.text,
    this.child,
    this.onTap,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.icon,
    this.suffixIcon,
  }) : type = ButtonType.danger;

  double get _height {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  double get _fontSize {
    switch (size) {
      case ButtonSize.small:
        return 13;
      case ButtonSize.medium:
        return 15;
      case ButtonSize.large:
        return 16;
    }
  }

  double get _iconSize {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 22;
    }
  }

  EdgeInsetsGeometry get _padding {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 计算颜色
    final Color bgColor = _getBackgroundColor(isDark);
    final Color textColor = _getTextColor(isDark);
    final Color borderColor = _getBorderColor(isDark);

    // 内容
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          if (text != null || child != null) const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: _iconSize, color: textColor),
          if (text != null || child != null) const SizedBox(width: 8),
        ],
        if (child != null)
          child!
        else if (text != null)
          Text(
            text!,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        if (suffixIcon != null && !isLoading) ...[
          if (text != null || child != null) const SizedBox(width: 8),
          Icon(suffixIcon, size: _iconSize - 2, color: textColor),
        ],
      ],
    );

    return GestureDetector(
      onTap: isDisabled || isLoading ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _height,
        width: isFullWidth ? double.infinity : null,
        padding: _padding,
        decoration: BoxDecoration(
          color: isDisabled ? bgColor.withAlpha(150) : bgColor,
          borderRadius: BorderRadius.circular(16),
          border: type == ButtonType.outline
              ? Border.all(
                  color: isDisabled ? borderColor.withAlpha(150) : borderColor,
                  width: 1.5,
                )
              : null,
          boxShadow: type == ButtonType.primary
              ? [
                  if (!isDisabled)
                    BoxShadow(
                      color: AppTheme.primaryBlue.withAlpha(80),
                      blurRadius: 20,
                      spreadRadius: -4,
                      offset: const Offset(0, 6),
                    ),
                ]
              : type == ButtonType.danger
                  ? [
                      if (!isDisabled)
                        BoxShadow(
                          color: AppTheme.errorRed.withAlpha(60),
                          blurRadius: 20,
                          spreadRadius: -4,
                          offset: const Offset(0, 6),
                        ),
                    ]
                  : [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withAlpha(60)
                            : AppTheme.gray900.withAlpha(15),
                        blurRadius: 16,
                        spreadRadius: -4,
                        offset: const Offset(0, 4),
                      ),
                    ],
        ),
        child: Center(child: content),
      ),
    );
  }

  Color _getBackgroundColor(bool isDark) {
    switch (type) {
      case ButtonType.primary:
        return AppTheme.primaryBlue;
      case ButtonType.secondary:
        return isDark
            ? AppTheme.darkElevated
            : AppTheme.gray100;
      case ButtonType.outline:
        return isDark
            ? Colors.transparent
            : Colors.white;
      case ButtonType.ghost:
        return Colors.transparent;
      case ButtonType.danger:
        return AppTheme.errorRed;
    }
  }

  Color _getTextColor(bool isDark) {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.danger:
        return Colors.white;
      case ButtonType.secondary:
        return isDark
            ? AppTheme.darkTextPrimary
            : AppTheme.gray800;
      case ButtonType.outline:
      case ButtonType.ghost:
        return isDark
            ? AppTheme.darkTextPrimary
            : AppTheme.gray700;
    }
  }

  Color _getBorderColor(bool isDark) {
    switch (type) {
      case ButtonType.outline:
        return isDark
            ? AppTheme.darkBorder
            : AppTheme.gray200;
      default:
        return Colors.transparent;
    }
  }
}

/// 图标按钮
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final bool isGlass;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 48,
    this.color,
    this.backgroundColor,
    this.isGlass = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ?? (isDark
        ? AppTheme.darkTextPrimary
        : AppTheme.gray700);
    final effectiveBgColor = backgroundColor ?? (isDark
        ? AppTheme.darkElevated.withAlpha(150)
        : Colors.white.withAlpha(200));

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: BorderRadius.circular(size / 4),
          border: isGlass
              ? Border.all(
                  color: isDark
                      ? Colors.white.withAlpha(15)
                      : Colors.white.withAlpha(150),
                  width: 0.5,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withAlpha(60)
                  : AppTheme.gray900.withAlpha(15),
              blurRadius: 16,
              spreadRadius: -4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: effectiveColor,
            size: size * 0.45,
          ),
        ),
      ),
    );
  }
}

/// 浮动操作按钮（玻璃风格）
class AppFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final bool isExtended;
  final String? label;

  const AppFab({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.isExtended = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.primaryBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        padding: isExtended
            ? const EdgeInsets.symmetric(horizontal: 24)
            : const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: effectiveColor.withAlpha(100),
              blurRadius: 24,
              spreadRadius: -4,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            if (isExtended && label != null) ...[
              const SizedBox(width: 12),
              AppTextButton(label!, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}

/// 分段控制器
class AppSegmentedControl<T> extends StatelessWidget {
  final List<T> items;
  final T selectedValue;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;

  const AppSegmentedControl({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkElevated.withAlpha(150)
            : AppTheme.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: items.map((item) {
          final isSelected = item == selectedValue;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? AppTheme.darkSurface.withAlpha(200)
                          : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withAlpha(60)
                                : AppTheme.gray900.withAlpha(15),
                            blurRadius: 8,
                            spreadRadius: -2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    labelBuilder(item),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? (isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.gray800)
                          : (isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.gray500),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
