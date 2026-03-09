import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_text.dart';
import 'glass_container.dart';

/// Alert 类型
enum AlertType {
  confirm,
  info,
  warning,
  error,
  input,
}

/// 全局 Alert 管理
class AppAlert {
  /// 显示确认对话框
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    String confirmText = '确认',
    String cancelText = '取消',
    AlertType type = AlertType.confirm,
    bool isDanger = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AlertDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        type: type,
        isDanger: isDanger,
      ),
    );
    return result ?? false;
  }

  /// 显示信息对话框
  static Future<void> info(
    BuildContext context, {
    required String title,
    String? message,
    String confirmText = '知道了',
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => _AlertDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        showCancel: false,
        type: AlertType.info,
      ),
    );
  }

  /// 显示输入对话框
  static Future<String?> input(
    BuildContext context, {
    required String title,
    String? hint,
    String? initialValue,
    String confirmText = '确认',
    String cancelText = '取消',
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _InputAlertDialog(
        title: title,
        hint: hint,
        initialValue: initialValue,
        confirmText: confirmText,
        cancelText: cancelText,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
    return result;
  }

  /// 显示选择对话框
  static Future<int?> select<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required String Function(T) itemBuilder,
    int? selectedIndex,
  }) async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => _SelectAlertDialog<T>(
        title: title,
        items: items,
        itemBuilder: itemBuilder,
        selectedIndex: selectedIndex,
      ),
    );
    return result;
  }

  /// 显示底部弹窗
  static Future<T?> sheet<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = false,
  }) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(100),
      builder: (context) => _BottomSheetWrapper(child: child),
    );
    return result;
  }

  /// 显示操作菜单
  static Future<int?> actionSheet(
    BuildContext context, {
    required String title,
    required List<String> actions,
    String? cancelText,
  }) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(100),
      builder: (context) => _ActionSheet(
        title: title,
        actions: actions,
        cancelText: cancelText ?? '取消',
      ),
    );
    return result;
  }
}

/// Alert 对话框组件
class _AlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String confirmText;
  final String cancelText;
  final AlertType type;
  final bool isDanger;
  final bool showCancel;

  const _AlertDialog({
    required this.title,
    this.message,
    required this.confirmText,
    this.cancelText = '取消',
    this.type = AlertType.confirm,
    this.isDanger = false,
    this.showCancel = true,
  });

  IconData get _icon {
    switch (type) {
      case AlertType.confirm:
        return Icons.help_outline_rounded;
      case AlertType.info:
        return Icons.info_outline_rounded;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.error:
        return Icons.error_outline_rounded;
      case AlertType.input:
        return Icons.edit_outlined;
    }
  }

  Color get _iconColor {
    if (isDanger) return AppTheme.errorRed;
    switch (type) {
      case AlertType.confirm:
        return AppTheme.primaryBlue;
      case AlertType.info:
        return AppTheme.primaryBlue;
      case AlertType.warning:
        return AppTheme.warningYellow;
      case AlertType.error:
        return AppTheme.errorRed;
      case AlertType.input:
        return AppTheme.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkCard.withAlpha(250)
                  : Colors.white.withAlpha(250),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? Colors.white.withAlpha(15)
                    : Colors.white.withAlpha(150),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha(150)
                      : AppTheme.gray900.withAlpha(40),
                  blurRadius: 40,
                  spreadRadius: -10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _iconColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _icon,
                    color: _iconColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 20),
                // 标题
                AppTextHeadline(
                  title,
                  textAlign: TextAlign.center,
                ),
                // 消息
                if (message != null) ...[
                  const SizedBox(height: 12),
                  AppTextBody(
                    message!,
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.gray500,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                // 按钮
                Row(
                  children: [
                    if (showCancel)
                      Expanded(
                        child: _AlertButton(
                          text: cancelText,
                          isPrimary: false,
                          onTap: () => Navigator.of(context).pop(false),
                        ),
                      ),
                    if (showCancel) const SizedBox(width: 12),
                    Expanded(
                      child: _AlertButton(
                        text: confirmText,
                        isPrimary: true,
                        isDanger: isDanger,
                        onTap: () => Navigator.of(context).pop(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 输入对话框
class _InputAlertDialog extends StatefulWidget {
  final String title;
  final String? hint;
  final String? initialValue;
  final String confirmText;
  final String cancelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _InputAlertDialog({
    required this.title,
    this.hint,
    this.initialValue,
    required this.confirmText,
    required this.cancelText,
    required this.keyboardType,
    this.validator,
  });

  @override
  State<_InputAlertDialog> createState() => _InputAlertDialogState();
}

class _InputAlertDialogState extends State<_InputAlertDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkCard.withAlpha(250)
                  : Colors.white.withAlpha(250),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? Colors.white.withAlpha(15)
                    : Colors.white.withAlpha(150),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha(150)
                      : AppTheme.gray900.withAlpha(40),
                  blurRadius: 40,
                  spreadRadius: -10,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 标题
                  AppTextHeadline(
                    widget.title,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // 输入框
                  GlassInput(
                    controller: _controller,
                    hintText: widget.hint,
                    keyboardType: widget.keyboardType,
                  ),
                  const SizedBox(height: 24),
                  // 按钮
                  Row(
                    children: [
                      Expanded(
                        child: _AlertButton(
                          text: widget.cancelText,
                          isPrimary: false,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AlertButton(
                          text: widget.confirmText,
                          isPrimary: true,
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? true) {
                              Navigator.of(context).pop(_controller.text);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 选择对话框
class _SelectAlertDialog<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemBuilder;
  final int? selectedIndex;

  const _SelectAlertDialog({
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkCard.withAlpha(250)
                  : Colors.white.withAlpha(250),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? Colors.white.withAlpha(15)
                    : Colors.white.withAlpha(150),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha(150)
                      : AppTheme.gray900.withAlpha(40),
                  blurRadius: 40,
                  spreadRadius: -10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: AppTextHeadline(
                    title,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(height: 1),
                // 列表
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = index == selectedIndex;

                      return ListTile(
                        onTap: () => Navigator.of(context).pop(index),
                        leading: Icon(
                          isSelected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : (isDark
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.gray400),
                        ),
                        title: AppTextBody(
                          itemBuilder(item),
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : (isDark
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.gray800),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                color: AppTheme.primaryBlue,
                                size: 20,
                              )
                            : null,
                      );
                    },
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

/// 底部弹窗包装器
class _BottomSheetWrapper extends StatelessWidget {
  final Widget child;

  const _BottomSheetWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppTheme.darkCard.withAlpha(250)
                : Colors.white.withAlpha(250),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withAlpha(15)
                    : Colors.white.withAlpha(150),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 拖拽指示器
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.darkTextSecondary.withAlpha(100)
                        : AppTheme.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 操作菜单
class _ActionSheet extends StatelessWidget {
  final String title;
  final List<String> actions;
  final String cancelText;

  const _ActionSheet({
    required this.title,
    required this.actions,
    required this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题和操作列表
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.darkElevated.withAlpha(230)
                        : Colors.white.withAlpha(230),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 标题
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: AppTextCaption(
                          title,
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.gray500,
                        ),
                      ),
                      const Divider(height: 1),
                      // 操作项
                      ...List.generate(actions.length, (index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () => Navigator.of(context).pop(index),
                              title: Center(
                                child: AppTextTitle(
                                  actions[index],
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ),
                            if (index < actions.length - 1)
                              const Divider(height: 1, indent: 16, endIndent: 16),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 取消按钮
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.darkElevated.withAlpha(230)
                          : Colors.white.withAlpha(230),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: AppTextTitle(
                        cancelText,
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.gray800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Alert 按钮
class _AlertButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final bool isDanger;
  final VoidCallback onTap;

  const _AlertButton({
    required this.text,
    required this.isPrimary,
    this.isDanger = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isPrimary
        ? (isDanger ? AppTheme.errorRed : AppTheme.primaryBlue)
        : (isDark
            ? AppTheme.darkElevated.withAlpha(150)
            : AppTheme.gray100);

    final textColor = isPrimary
        ? Colors.white
        : (isDark
            ? AppTheme.darkTextPrimary
            : AppTheme.gray700);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: isPrimary
              ? null
              : Border.all(
                  color: isDark
                      ? Colors.white.withAlpha(15)
                      : AppTheme.gray200,
                ),
        ),
        child: Center(
          child: AppTextButton(
            text,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
