import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_text.dart';
import 'glass_container.dart';

/// 统一列表项组件
class AppListTile extends StatelessWidget {
  final Widget? leading;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final Color? leadingBackgroundColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final VoidCallback? onTrailingTap;
  final bool showArrow;
  final bool isGlass;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppListTile({
    super.key,
    this.leading,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingBackgroundColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.trailingIcon,
    this.onTap,
    this.onTrailingTap,
    this.showArrow = true,
    this.isGlass = true,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget content = Container(
      margin: margin ?? const EdgeInsets.only(bottom: 8),
      padding: padding ?? const EdgeInsets.all(12),
      decoration: isGlass
          ? null
          : BoxDecoration(
              color: isDark
                  ? AppTheme.darkCard
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha(40)
                      : AppTheme.gray900.withAlpha(10),
                  blurRadius: 16,
                  spreadRadius: -4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
      child: Row(
        children: [
          // 左侧图标
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ] else if (leadingIcon != null) ...[
            _buildLeadingIcon(context),
            const SizedBox(width: 12),
          ],
          // 中间内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTitleSmall(
                  title,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.gray800,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  AppTextCaption(
                    subtitle!,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.gray500,
                  ),
                ],
              ],
            ),
          ),
          // 右侧内容
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ] else if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onTrailingTap,
              child: Icon(
                trailingIcon,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.gray400,
                size: 20,
              ),
            ),
          ] else if (showArrow && onTap != null) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.gray400,
              size: 20,
            ),
          ],
        ],
      ),
    );

    // 包装玻璃容器
    if (isGlass) {
      content = GlassContainer(
        margin: margin ?? const EdgeInsets.only(bottom: 8),
        padding: padding ?? const EdgeInsets.all(12),
        child: content,
      );
    }

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }

  Widget _buildLeadingIcon(BuildContext context) {
    final effectiveColor = leadingIconColor ?? AppTheme.primaryBlue;
    final effectiveBgColor = leadingBackgroundColor ?? effectiveColor.withAlpha(20);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          leadingIcon,
          color: effectiveColor,
          size: 22,
        ),
      ),
    );
  }
}

/// 设置项列表项
class AppSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showArrow;

  const AppSettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leadingIcon: icon,
      leadingIconColor: AppTheme.primaryBlue,
      leadingBackgroundColor: AppTheme.primaryBlue.withAlpha(15),
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: trailing,
      showArrow: showArrow && trailing == null,
    );
  }
}

/// 开关设置项
class AppSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  const AppSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leadingIcon: icon,
      leadingIconColor: value
          ? (activeColor ?? AppTheme.primaryBlue)
          : (Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkTextSecondary
              : AppTheme.gray400),
      leadingBackgroundColor: (activeColor ?? AppTheme.primaryBlue).withAlpha(value ? 20 : 10),
      title: title,
      subtitle: subtitle,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: (activeColor ?? AppTheme.primaryBlue).withAlpha(100),
        activeThumbColor: activeColor ?? AppTheme.primaryBlue,
      ),
      showArrow: false,
    );
  }
}

/// 滑块设置项
class AppSliderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String? suffix;

  const AppSliderTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.min = 0,
    this.max = 100,
    required this.onChanged,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withAlpha(15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextTitleSmall(
                  title,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.gray800,
                ),
              ),
              AppTextCaption(
                suffix != null ? '${value.round()}$suffix' : '${value.round()}',
                color: AppTheme.primaryBlue,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// 选项设置项
class AppOptionTile<T> extends StatelessWidget {
  final IconData icon;
  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  const AppOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: GlassContainer(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        borderColor: isSelected
            ? AppTheme.primaryBlue.withAlpha(100)
            : null,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue.withAlpha(20)
                    : AppTheme.primaryBlue.withAlpha(10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppTheme.primaryBlue
                    : (Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.gray400),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextTitleSmall(
                title,
                color: isSelected
                    ? AppTheme.primaryBlue
                    : (Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkTextPrimary
                        : AppTheme.gray800),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppTheme.primaryBlue,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

/// 分节标题
class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTextHeadline(
            title,
            color: isDark
                ? AppTheme.darkTextPrimary
                : AppTheme.gray800,
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onAction,
              child: AppTextBody(
                actionText!,
                color: AppTheme.primaryBlue,
              ),
            ),
        ],
      ),
    );
  }
}

/// 分组列表
class AppGroupedList extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const AppGroupedList({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          AppSectionHeader(title: title!),
        ...children,
      ],
    );
  }
}
