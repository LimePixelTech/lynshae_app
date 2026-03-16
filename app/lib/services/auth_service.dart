import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_client.dart';

/// 认证服务 - 处理用户登录、注册、登出
class AuthService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _isLoggedInKey = 'is_logged_in';

  /// 登录状态变化通知器
  static final ValueNotifier<bool> loginStateNotifier = ValueNotifier(false);

  static final ApiClient _apiClient = ApiClient();

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

  /// 获取 Access Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// 检查是否已登录
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// 登录 - 连接后端 API
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.success && response.data != null) {
        final userData = response.data!;
        // 适配后端响应格式：admin 或 user，tokens 或直接的 accessToken/refreshToken
        final user = UserModel.fromJson(userData['user'] ?? userData['admin']);
        final tokens = userData['tokens'];
        final accessToken = tokens != null 
            ? tokens['accessToken'] 
            : userData['accessToken'];
        final refreshToken = tokens != null 
            ? tokens['refreshToken'] 
            : userData['refreshToken'];

        // 保存用户信息
        await _saveUser(user);
        // 保存 Token
        await _saveToken(accessToken, refreshToken);
        // 设置登录状态
        await _setLoggedIn(true);

        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'error': response.message ?? '登录失败'};
      }
    } catch (e) {
      return {'success': false, 'error': '网络错误：${e.toString()}'};
    }
  }

  /// 注册 - 连接后端 API
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.success) {
        // 注册成功后自动登录
        return await login(email: email, password: password);
      } else {
        return {'success': false, 'error': response.message ?? '注册失败'};
      }
    } catch (e) {
      return {'success': false, 'error': '网络错误：${e.toString()}'};
    }
  }

  /// 登出
  static Future<void> logout() async {
    try {
      // 调用后端登出接口
      await _apiClient.post('/auth/logout', requiresAuth: true);
    } catch (e) {
      // 忽略登出错误
    } finally {
      // 清除本地数据
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.setBool(_isLoggedInKey, false);
    }
  }

  /// 刷新 Token
  static Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);

      if (refreshToken == null) return false;

      final response = await _apiClient.post(
        '/auth/refresh-token',
        body: {'refreshToken': refreshToken},
      );

      if (response.success && response.data != null) {
        final tokens = response.data!['tokens'];
        await _saveToken(tokens['accessToken'], tokens['refreshToken']);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// 保存用户到本地存储
  static Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  /// 保存 Token
  static Future<void> _saveToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    
    // 更新 API Client 的 Token
    _apiClient.setAccessToken(accessToken);
  }

  /// 设置登录状态
  static Future<void> _setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
    // 通知主应用登录状态已改变
    loginStateNotifier.value = value;
  }

  /// 更新当前用户信息
  static Future<void> updateUser(UserModel user) async {
    await _saveUser(user);
  }
}
