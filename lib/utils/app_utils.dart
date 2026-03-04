import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 工具函数集合
class AppUtils {
  /// 格式化时间
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// 格式化日期
  static String formatDate(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
  }

  /// 格式化相对时间
  static String formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    return formatDate(time);
  }

  /// 显示加载提示 (毛玻璃风格)
  static void showLoading(BuildContext context, {String message = '加载中...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (context) => Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.15)
                      : Colors.white.withOpacity(0.6),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppTheme.primaryBlue),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 隐藏加载提示
  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// 显示成功提示 (毛玻璃 SnackBar)
  static void showSuccess(BuildContext context, String message) {
    _showGlassSnackBar(context, message, Icons.check_circle_rounded,
        AppTheme.successGreen);
  }

  /// 显示错误提示
  static void showError(BuildContext context, String message) {
    _showGlassSnackBar(
        context, message, Icons.error_rounded, AppTheme.errorRed);
  }

  /// 显示警告提示
  static void showWarning(BuildContext context, String message) {
    _showGlassSnackBar(
        context, message, Icons.warning_rounded, AppTheme.warningYellow);
  }

  /// 显示信息提示
  static void showInfo(BuildContext context, String message) {
    _showGlassSnackBar(
        context, message, Icons.info_rounded, AppTheme.primaryBlue);
  }

  static void _showGlassSnackBar(
      BuildContext context, String message, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
            ),
          ],
        ),
        backgroundColor:
            isDark ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 确认对话框 (毛玻璃风格)
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '确定',
    String cancelText = '取消',
  }) async {
    final theme = Theme.of(context);
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => AlertDialog(
        title: Text(title,
            style: TextStyle(color: theme.colorScheme.onSurface)),
        content: Text(message,
            style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText,
                style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.5))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// 振动反馈
  static void vibrate({Duration duration = const Duration(milliseconds: 50)}) {
    // TODO: 添加 HapticFeedback
  }

  /// 检查电量状态
  static String getBatteryStatus(int level) {
    if (level > 80) return '充足';
    if (level > 50) return '良好';
    if (level > 20) return '一般';
    return '低电量';
  }

  /// 获取电量颜色
  static Color getBatteryColor(int level) {
    if (level > 60) return AppTheme.successGreen;
    if (level > 20) return AppTheme.warningYellow;
    return AppTheme.errorRed;
  }
}
