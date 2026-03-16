import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../utils/app_utils.dart';
import 'main_screen.dart';
import 'package:flutter/services.dart';

/// 登录页面 - 支持登录/注册切换
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _isLogin = true; // true=登录模式，false=注册模式
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    Map<String, dynamic> result;

    if (_isLogin) {
      result = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      result = await AuthService.register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      // 登录成功后，先显示提示
      AppUtils.showSuccess(context, _isLogin ? '登录成功' : '注册成功');
      // 使用 WidgetsBinding 确保在下一帧执行跳转
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            // 使用 Navigator.of(context, rootNavigator: true) 确保使用正确的导航器
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false,
            );
          }
        });
      });
    } else {
      AppUtils.showError(context, result['error'] as String);
    }
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.backgroundGradient(context),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Logo 区域
                      _buildLogo(isDark),
                      const SizedBox(height: 48),
                      // 标题
                      _buildHeader(isDark),
                      const SizedBox(height: 40),
                      // 表单
                      _buildForm(isDark),
                      const SizedBox(height: 32),
                      // 登录/注册按钮
                      _buildSubmitButton(isDark),
                      const SizedBox(height: 24),
                      // 切换登录/注册
                      _buildToggleText(isDark),
                      const SizedBox(height: 24),
                      // 其他登录方式
                      _buildOtherLoginMethods(isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppTheme.primaryBlue.withAlpha(100),
                  AppTheme.primaryBlue.withAlpha(40),
                ]
              : [
                  AppTheme.warmBeige.withAlpha(100),
                  AppTheme.warmGold.withAlpha(60),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppTheme.primaryBlue.withAlpha(80)
                : AppTheme.warmBeige.withAlpha(100),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Icon(
        Icons.pets_rounded,
        color: isDark ? Colors.white : AppTheme.warmBrown,
        size: 60,
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        Text(
          _isLogin ? '欢迎回来' : '创建账户',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isLogin ? '登录以继续使用设备' : '注册并开始使用',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(bool isDark) {
    return Column(
      children: [
        // 用户名（仅注册模式）
        if (!_isLogin) ...[
          _buildTextField(
            controller: _usernameController,
            label: '用户名',
            hint: '请输入用户名',
            icon: Icons.person_outline_rounded,
            isDark: isDark,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '请输入用户名';
              }
              if (value.trim().length < 2) {
                return '用户名至少需要 2 位';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ],
        // 邮箱
        _buildTextField(
          controller: _emailController,
          label: '邮箱',
          hint: '请输入邮箱地址',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          isDark: isDark,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入邮箱';
            }
            if (!value.contains('@')) {
              return '请输入有效的邮箱地址';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        // 密码
        _buildTextField(
          controller: _passwordController,
          label: '密码',
          hint: '请输入密码',
          icon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          isDark: isDark,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
              size: 20,
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入密码';
            }
            if (value.length < 6) {
              return '密码至少需要 6 位';
            }
            return null;
          },
        ),
        // 忘记密码（仅登录模式）
        if (_isLogin)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                AppUtils.showInfo(context, '忘记密码 功能开发中');
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              child: Text(
                '忘记密码？',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    bool? obscureText,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          validator: validator,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withAlpha(15)
                    : AppTheme.warmBeige.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDark ? Colors.white70 : AppTheme.warmBrown,
                size: 20,
              ),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isDark
                ? AppTheme.darkCard.withAlpha(180)
                : Colors.white.withAlpha(200),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? AppTheme.primaryBlue : AppTheme.warmBeige,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.errorRed),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppTheme.primaryBlue : AppTheme.warmBeige,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                _isLogin ? '登录' : '注册',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildToggleText(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? '还没有账户？' : '已有账户？',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
          ),
        ),
        TextButton(
          onPressed: _toggleMode,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            foregroundColor: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
          ),
          child: Text(
            _isLogin ? '立即注册' : '立即登录',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherLoginMethods(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDark ? Colors.white.withAlpha(20) : AppTheme.beige300,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '其他登录方式',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark ? Colors.white.withAlpha(20) : AppTheme.beige300,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: Icons.g_mobiledata_rounded,
              label: 'Google',
              isDark: isDark,
              onTap: () => AppUtils.showInfo(context, 'Google 登录 功能开发中'),
            ),
            const SizedBox(width: 24),
            _buildSocialButton(
              icon: Icons.apple_rounded,
              label: 'Apple',
              isDark: isDark,
              onTap: () => AppUtils.showInfo(context, 'Apple 登录 功能开发中'),
            ),
            const SizedBox(width: 24),
            _buildSocialButton(
              icon: Icons.chat_bubble_outline_rounded,
              label: '微信',
              isDark: isDark,
              onTap: () => AppUtils.showInfo(context, '微信登录 功能开发中'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withAlpha(20)
                  : AppTheme.warmBeige.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white.withAlpha(30) : AppTheme.beige400.withAlpha(50),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.white70 : AppTheme.lightTextPrimary,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
