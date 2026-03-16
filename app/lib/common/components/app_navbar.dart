import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_utils.dart';

/// 二级界面通用导航栏组件
///
/// 用于所有二级页面的顶部导航栏，保持统一的视觉风格
///
/// 使用示例：
/// ```dart
/// AppNavbar(
///   title: '页面标题',
///   showScan: true,
///   onScanPressed: () => print('扫描'),
///   trailing: Text('编辑'),
/// )
/// ```
class AppNavbar extends StatelessWidget {
  /// 页面标题
  final String title;

  /// 是否显示扫描二维码按钮（可选）
  final bool showScan;

  /// 是否显示通知按钮（可选）
  final bool showNotification;

  /// 扫描按钮点击回调（可选）
  final VoidCallback? onScanPressed;

  /// 通知按钮点击回调（可选）
  final VoidCallback? onNotificationPressed;

  /// 右侧自定义组件（可选，如编辑按钮）
  final Widget? trailing;

  const AppNavbar({
    super.key,
    required this.title,
    this.showScan = false,
    this.showNotification = true,
    this.onScanPressed,
    this.onNotificationPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 返回按钮
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark 
                    ? Colors.white.withAlpha(15) 
                    : AppTheme.warmBeige.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 标题
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.lightTextPrimary,
            ),
          ),
          const Spacer(),
          // 右侧自定义组件（如编辑按钮）
          if (trailing != null) trailing!,
          // 扫描二维码按钮（可选）
          if (showScan) ...[
            GestureDetector(
              onTap: onScanPressed ?? () {
                AppUtils.vibrate();
                AppUtils.showInfo(context, '扫描二维码 功能开发中');
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.white.withAlpha(15) 
                      : AppTheme.warmBeige.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          // 通知按钮
          if (showNotification)
            GestureDetector(
              onTap: onNotificationPressed ?? () {
                AppUtils.vibrate();
                AppUtils.showInfo(context, '通知 功能开发中');
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.white.withAlpha(15) 
                      : AppTheme.warmBeige.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                  size: 22,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
