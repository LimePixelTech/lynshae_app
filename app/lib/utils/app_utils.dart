import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_alert.dart';

/// 工具函数集合
///
/// 提供应用中常用的工具函数，包括：
/// - 时间日期格式化
/// - 加载提示显示
/// - Toast 消息提示
/// - 振动反馈
/// - 电量状态判断
///
/// 使用示例：
/// ```dart
/// // 显示加载中
/// AppUtils.showLoading(context);
///
/// // 显示成功提示
/// AppUtils.showSuccess(context, '操作成功');
///
/// // 振动反馈
/// AppUtils.vibrate();
/// ```
class AppUtils {
  // === 时间格式化 ===

  /// 格式化时间为 HH:mm 格式
  ///
  /// 示例：14:30
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// 格式化日期为 yyyy-MM-dd 格式
  ///
  /// 示例：2026-03-09
  static String formatDate(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
  }

  /// 格式化相对时间
  ///
  /// 返回：刚刚、5分钟前、2小时前、3天前等
  static String formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    return formatDate(time);
  }

  // === 加载提示 ===

  /// 显示加载提示 (毛玻璃风格)
  ///
  /// 显示一个居中的加载动画，背景为毛玻璃效果
  /// 需要手动调用 [hideLoading] 关闭
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
                    ? AppTheme.darkElevated.withAlpha(200)
                    : Colors.white.withAlpha(220),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withAlpha(15)
                      : Colors.white.withAlpha(150),
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

  // === Toast 提示 ===

  /// 显示成功提示
  static void showSuccess(BuildContext context, String message) {
    Toast.success(context, message);
  }

  /// 显示错误提示
  static void showError(BuildContext context, String message) {
    Toast.error(context, message);
  }

  /// 显示警告提示
  static void showWarning(BuildContext context, String message) {
    Toast.warning(context, message);
  }

  /// 显示信息提示
  static void showInfo(BuildContext context, String message) {
    Toast.info(context, message);
  }

  // === 对话框 ===

  /// 显示确认对话框
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '确定',
    String cancelText = '取消',
  }) async {
    return await AppAlert.confirm(
      context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
    );
  }

  // === 振动反馈 ===

  /// 轻振动反馈
  ///
  /// 适用于：按钮点击、切换开关等轻交互
  static void vibrate({Duration duration = const Duration(milliseconds: 50)}) {
    HapticFeedback.lightImpact();
  }

  /// 强烈振动反馈
  ///
  /// 适用于：错误提示、重要操作确认
  static void vibrateStrong() {
    HapticFeedback.heavyImpact();
  }

  /// 选择振动反馈
  ///
  /// 适用于：列表选择、滑动等
  static void vibrateSelection() {
    HapticFeedback.selectionClick();
  }

  // === 电量相关 ===

  /// 检查电量状态
  ///
  /// 返回：充足、良好、一般、低电量
  static String getBatteryStatus(int level) {
    if (level > 80) return '充足';
    if (level > 50) return '良好';
    if (level > 20) return '一般';
    return '低电量';
  }

  /// 获取电量颜色
  ///
  /// 根据电量返回对应颜色：
  /// - >60%：successGreen (绿色)
  /// - 20-60%：warningYellow (黄色)
  /// - <20%：errorRed (红色)
  static Color getBatteryColor(int level) {
    if (level > 60) return AppTheme.successGreen;
    if (level > 20) return AppTheme.warningYellow;
    return AppTheme.errorRed;
  }
}
