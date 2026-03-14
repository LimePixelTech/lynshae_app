import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// 认证服务 - 处理用户登录、注册、登出
class AuthService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';

  /// 获取当前登录用户
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;

    try {
      final Map<String, dynamic> data = json.decode(userJson);
      return UserModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// 检查是否已登录
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// 登录 - 简化版本（实际项目中应连接后端 API）
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    // 简单验证
    if (email.isEmpty || password.isEmpty) {
      return {'success': false, 'error': '请输入邮箱和密码'};
    }

    if (!email.contains('@')) {
      return {'success': false, 'error': '请输入有效的邮箱地址'};
    }

    if (password.length < 6) {
      return {'success': false, 'error': '密码至少需要 6 位'};
    }

    // 模拟登录成功 - 实际项目中应验证后端
    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: email.split('@').first,
      email: email,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    await _saveUser(user);
    await _setLoggedIn(true);

    return {'success': true, 'user': user};
  }

  /// 注册 - 简化版本
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    // 验证
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return {'success': false, 'error': '请填写所有必填项'};
    }

    if (username.length < 2) {
      return {'success': false, 'error': '用户名至少需要 2 位'};
    }

    if (!email.contains('@')) {
      return {'success': false, 'error': '请输入有效的邮箱地址'};
    }

    if (password.length < 6) {
      return {'success': false, 'error': '密码至少需要 6 位'};
    }

    // 模拟注册成功
    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: email,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    await _saveUser(user);
    await _setLoggedIn(true);

    return {'success': true, 'user': user};
  }

  /// 登出
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  /// 保存用户到本地存储
  static Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  /// 设置登录状态
  static Future<void> _setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  /// 更新当前用户信息
  static Future<void> updateUser(UserModel user) async {
    await _saveUser(user);
  }
}
