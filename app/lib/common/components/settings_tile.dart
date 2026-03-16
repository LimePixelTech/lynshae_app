import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 通用设置项组件
///
/// 用于构建设置列表中的单个项目，支持图标、标题、副标题、右箭头、Switch 等
///
/// 使用示例：
/// ```dart
/// SettingsTile(
///   icon: Icons.info_outline,
///   title: '检查更新',
///   subtitle: '当前版本 v1.0.0',
///   onTap: () => _checkForUpdate(),
/// )
/// ```
class SettingsTile extends StatelessWidget {
  /// 左侧图标
  final IconData icon;

  /// 图标背景颜色（可选，默认使用半透明主色）
  final Color? iconBackgroundColor;

  /// 图标颜色（可选，默认白色）
  final Color? iconColor;

  /// 图标尺寸（可选，默认 22）
  final double? iconSize;

  /// 图标容器尺寸（可选，默认 40）
  final double? iconContainerSize;

  /// 主标题
  final String title;

  /// 副标题（可选）
  final String? subtitle;

  /// 右侧自定义内容（可选，如 Switch、Text 等）
  final Widget? trailing;

  /// 是否显示 Switch（可选）
  final bool showSwitch;

  /// Switch 初始值（可选）
  final bool? switchValue;

  /// Switch 变化回调（可选）
  final Function(bool)? onSwitchChanged;

  /// 是否显示右箭头（默认 true，当有 onTap 时）
  final bool showArrow;

  /// 点击回调
  final VoidCallback? onTap;

  /// 是否显示分割线（默认 true）
  final bool showDivider;

  /// 分割线缩进（默认 68）
  final double? dividerIndent;

  /// 垂直内边距（默认 16）
  final double? verticalPadding;

  const SettingsTile({
    super.key,
    required this.icon,
    this.iconBackgroundColor,
    this.iconColor,
    this.iconSize,
    this.iconContainerSize,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
    this.showArrow = true,
    this.onTap,
    this.showDivider = true,
    this.dividerIndent,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: verticalPadding ?? 16,
            ),
            child: Row(
              children: [
                // 左侧图标容器
                Container(
                  width: iconContainerSize ?? 40,
                  height: iconContainerSize ?? 40,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor ?? (isDark 
                        ? Colors.white.withAlpha(15) 
                        : AppTheme.warmBeige.withAlpha(20)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? (isDark ? Colors.white : AppTheme.lightTextPrimary),
                    size: iconSize ?? 22,
                  ),
                ),
                const SizedBox(width: 16),
                // 标题和副标题
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white30 : AppTheme.lightTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // 右侧自定义内容
                if (trailing != null) trailing!,
                // Switch
                if (showSwitch && onSwitchChanged != null)
                  _buildSwitch(switchValue ?? false, onSwitchChanged!, isDark),
                // 右箭头
                if (showArrow &&
                    onTap != null &&
                    trailing == null &&
                    !showSwitch)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        // 分割线
        if (showDivider)
          Divider(
            height: 1,
            indent: dividerIndent ?? 68,
            endIndent: 16,
            color: isDark ? Colors.white.withAlpha(10) : AppTheme.warmBeige.withAlpha(15),
          ),
      ],
    );
  }

  Widget _buildSwitch(bool value, Function(bool) onChanged, bool isDark) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 52,
        height: 32,
        decoration: BoxDecoration(
          color: value
              ? AppTheme.successGreen.withAlpha(80)
              : (isDark ? Colors.white.withAlpha(20) : AppTheme.warmBeige.withAlpha(30)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? 24 : 4,
              top: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: value ? AppTheme.successGreen : (isDark ? Colors.white : AppTheme.warmBrown),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 设置卡片容器
///
/// 用于包裹多个 SettingsTile，提供统一的背景和圆角
///
/// 使用示例：
/// ```dart
/// SettingsCard(
///   children: [
///     SettingsTile(...),
///     SettingsTile(...),
///   ],
/// )
/// ```
class SettingsCard extends StatelessWidget {
  /// 子组件列表
  final List<Widget> children;

  /// 卡片边距（默认 16）
  final double padding;

  const SettingsCard({
    super.key,
    required this.children,
    this.padding = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // 移除最后一个孩子的分割线
    final processedChildren = children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      final isLast = index == children.length - 1;

      if (isLast && child is SettingsTile) {
        // 如果是最后一个，移除分割线但保留所有其他属性
        return SettingsTile(
          icon: child.icon,
          title: child.title,
          subtitle: child.subtitle,
          trailing: child.trailing,
          showArrow: child.showArrow,
          onTap: child.onTap,
          showDivider: false,
          showSwitch: child.showSwitch,
          switchValue: child.switchValue,
          onSwitchChanged: child.onSwitchChanged,
          dividerIndent: child.dividerIndent,
          iconBackgroundColor: child.iconBackgroundColor,
          iconColor: child.iconColor,
          iconSize: child.iconSize,
          iconContainerSize: child.iconContainerSize,
          verticalPadding: child.verticalPadding,
        );
      }
      return child;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 0.5,
        ),
      ),
      child: Column(children: processedChildren),
    );
  }
}
