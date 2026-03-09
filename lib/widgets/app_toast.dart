import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_text.dart';

/// Toast 类型
enum ToastType {
  success,
  error,
  warning,
  info,
}

/// 全局 Toast 管理
class Toast {
  static OverlayEntry? _currentEntry;
  static bool _isShowing = false;

  /// 显示 Toast
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
    IconData? icon,
    VoidCallback? onDismiss,
  }) {
    // 如果有正在显示的 Toast，先移除
    if (_isShowing) {
      _currentEntry?.remove();
      _currentEntry = null;
    }

    _isShowing = true;

    final overlay = Overlay.of(context);

    _currentEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        type: type,
        icon: icon,
        onDismiss: () {
          _currentEntry?.remove();
          _currentEntry = null;
          _isShowing = false;
          onDismiss?.call();
        },
      ),
    );

    overlay.insert(_currentEntry!);

    // 自动关闭
    Future.delayed(duration, () {
      if (_isShowing && _currentEntry != null) {
        _currentEntry?.remove();
        _currentEntry = null;
        _isShowing = false;
        onDismiss?.call();
      }
    });
  }

  /// 显示成功 Toast
  static void success(BuildContext context, String message, {Duration? duration}) {
    show(
      context,
      message: message,
      type: ToastType.success,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  /// 显示错误 Toast
  static void error(BuildContext context, String message, {Duration? duration}) {
    show(
      context,
      message: message,
      type: ToastType.error,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// 显示警告 Toast
  static void warning(BuildContext context, String message, {Duration? duration}) {
    show(
      context,
      message: message,
      type: ToastType.warning,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  /// 显示信息 Toast
  static void info(BuildContext context, String message, {Duration? duration}) {
    show(
      context,
      message: message,
      type: ToastType.info,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  /// 隐藏当前 Toast
  static void hide() {
    if (_isShowing) {
      _currentEntry?.remove();
      _currentEntry = null;
      _isShowing = false;
    }
  }
}

/// Toast 组件
class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final IconData? icon;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.type,
    this.icon,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData get _defaultIcon {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.error:
        return Icons.error_rounded;
      case ToastType.warning:
        return Icons.warning_rounded;
      case ToastType.info:
        return Icons.info_rounded;
    }
  }

  Color get _iconColor {
    switch (widget.type) {
      case ToastType.success:
        return AppTheme.successGreen;
      case ToastType.error:
        return AppTheme.errorRed;
      case ToastType.warning:
        return AppTheme.warningYellow;
      case ToastType.info:
        return AppTheme.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Center(
            child: GestureDetector(
              onTap: widget.onDismiss,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.darkElevated.withAlpha(230)
                            : Colors.white.withAlpha(240),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withAlpha(20)
                              : Colors.white.withAlpha(150),
                          width: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withAlpha(100)
                                : AppTheme.gray900.withAlpha(30),
                            blurRadius: 30,
                            spreadRadius: -8,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _iconColor.withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              widget.icon ?? _defaultIcon,
                              color: _iconColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: AppTextBody(
                              widget.message,
                              color: isDark
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.gray800,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: widget.onDismiss,
                            child: Icon(
                              Icons.close_rounded,
                              color: isDark
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.gray400,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 底部 Toast（Snackbar 风格）
class BottomToast extends StatelessWidget {
  final String message;
  final ToastType type;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const BottomToast({
    super.key,
    required this.message,
    this.type = ToastType.info,
    this.icon,
    this.onAction,
    this.actionLabel,
  });

  IconData get _defaultIcon {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.error:
        return Icons.error_rounded;
      case ToastType.warning:
        return Icons.warning_rounded;
      case ToastType.info:
        return Icons.info_rounded;
    }
  }

  Color get _iconColor {
    switch (type) {
      case ToastType.success:
        return AppTheme.successGreen;
      case ToastType.error:
        return AppTheme.errorRed;
      case ToastType.warning:
        return AppTheme.warningYellow;
      case ToastType.info:
        return AppTheme.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkElevated.withAlpha(230)
                  : Colors.white.withAlpha(240),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withAlpha(20)
                    : Colors.white.withAlpha(150),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha(100)
                      : AppTheme.gray900.withAlpha(30),
                  blurRadius: 30,
                  spreadRadius: -8,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _iconColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon ?? _defaultIcon,
                    color: _iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextBody(
                    message,
                    color: isDark
                        ? AppTheme.darkTextPrimary
                        : AppTheme.gray800,
                  ),
                ),
                if (onAction != null && actionLabel != null)
                  TextButton(
                    onPressed: onAction,
                    child: AppTextButton(
                      actionLabel!,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
