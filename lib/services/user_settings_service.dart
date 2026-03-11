import 'package:shared_preferences/shared_preferences.dart';

/// 用户设置服务
class UserSettingsService {
  static const String _usernameKey = 'username';
  static const String _avatarKey = 'avatar_path';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _languageCodeKey = 'language_code';

  /// 获取用户名
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? 'Freakz3z';
  }

  /// 设置用户名
  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  /// 获取头像路径
  static Future<String?> getAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarKey);
  }

  /// 设置头像路径
  static Future<void> setAvatarPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarKey, path);
  }

  /// 检查通知是否启用
  static Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  /// 设置通知开关
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  /// 获取语言代码
  static Future<String> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCodeKey) ?? 'zh_CN';
  }

  /// 设置语言代码
  static Future<void> setLanguageCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, code);
  }

  /// 清除所有用户设置
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_avatarKey);
    await prefs.remove(_notificationsEnabledKey);
    await prefs.remove(_languageCodeKey);
  }
}
