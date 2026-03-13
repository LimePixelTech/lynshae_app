import 'package:flutter/material.dart';

/// 通用设置项组件
///
/// 用于构建设置列表中的单个项目，支持图标、标题、副标题、右箭头等
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

  /// 主标题
  final String title;

  /// 副标题（可选）
  final String? subtitle;

  /// 右侧自定义内容（可选，如 Switch、Text 等）
  final Widget? trailing;

  /// 是否显示右箭头（默认 true，当有 onTap 时）
  final bool showArrow;

  /// 点击回调
  final VoidCallback? onTap;

  /// 是否显示分割线（默认 true）
  final bool showDivider;

  /// 分割线缩进（默认 68）
  final double? dividerIndent;

  const SettingsTile({
    super.key,
    required this.icon,
    this.iconBackgroundColor,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showArrow = true,
    this.onTap,
    this.showDivider = true,
    this.dividerIndent,
  });

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // 左侧图标容器
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor ?? Colors.white.withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? Colors.white,
                    size: 22,
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white30,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // 右侧自定义内容
                if (trailing != null) trailing!,
                // 右箭头
                if (showArrow && onTap != null && trailing == null)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white30,
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
            color: Colors.white.withAlpha(10),
          ),
      ],
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
    // 移除最后一个孩子的分割线
    final processedChildren = children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      final isLast = index == children.length - 1;

      if (isLast && child is SettingsTile) {
        // 如果是最后一个，移除分割线
        return SettingsTile(
          icon: child.icon,
          title: child.title,
          subtitle: child.subtitle,
          trailing: child.trailing,
          showArrow: child.showArrow,
          onTap: child.onTap,
          showDivider: false,
          dividerIndent: child.dividerIndent,
          iconBackgroundColor: child.iconBackgroundColor,
          iconColor: child.iconColor,
        );
      }
      return child;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: processedChildren),
    );
  }
}
