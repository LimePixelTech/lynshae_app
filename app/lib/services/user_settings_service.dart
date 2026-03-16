import 'package:shared_preferences/shared_preferences.dart';

/// 用户设置服务
class UserSettingsService {
  static const String _usernameKey = 'username';
  static const String _avatarKey = 'avatar_path';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _languageCodeKey = 'language_code';

  // 通知设置相关 keys
  static const String _deviceNotificationsKey = 'device_notifications_enabled';
  static const String _mallNotificationsKey = 'mall_notifications_enabled';
  static const String _dndEnabledKey = 'dnd_enabled';
  static const String _dndStartTimeKey = 'dnd_start_time';
  static const String _dndEndTimeKey = 'dnd_end_time';

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

  // ==================== 通知设置相关方法 ====================

  /// 检查设备通知是否启用
  static Future<bool> isDeviceNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_deviceNotificationsKey) ?? true;
  }

  /// 设置设备通知开关
  static Future<void> setDeviceNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_deviceNotificationsKey, enabled);
  }

  /// 检查商城通知是否启用
  static Future<bool> isMallNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_mallNotificationsKey) ?? true;
  }

  /// 设置商城通知开关
  static Future<void> setMallNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mallNotificationsKey, enabled);
  }

  /// 检查免打扰是否启用
  static Future<bool> isDndEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dndEnabledKey) ?? false;
  }

  /// 设置免打扰开关
  static Future<void> setDndEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dndEnabledKey, enabled);
  }

  /// 获取免打扰开始时间
  static Future<String> getDndStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dndStartTimeKey) ?? '22:00';
  }

  /// 设置免打扰开始时间
  static Future<void> setDndStartTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dndStartTimeKey, time);
  }

  /// 获取免打扰结束时间
  static Future<String> getDndEndTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dndEndTimeKey) ?? '07:00';
  }

  /// 设置免打扰结束时间
  static Future<void> setDndEndTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dndEndTimeKey, time);
  }

  /// 检查当前是否在免打扰时段内
  static Future<bool> isDndActive() async {
    final isEnabled = await isDndEnabled();
    if (!isEnabled) return false;

    final startTime = await getDndStartTime();
    final endTime = await getDndEndTime();

    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    if (startTime == endTime) return false;

    // 处理跨天情况（如 22:00 - 07:00）
    if (startTime.compareTo(endTime) > 0) {
      return currentTime.compareTo(startTime) >= 0 ||
          currentTime.compareTo(endTime) <= 0;
    } else {
      return currentTime.compareTo(startTime) >= 0 &&
          currentTime.compareTo(endTime) <= 0;
    }
  }

  /// 清除所有用户设置
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_avatarKey);
    await prefs.remove(_notificationsEnabledKey);
    await prefs.remove(_languageCodeKey);
    await prefs.remove(_deviceNotificationsKey);
    await prefs.remove(_mallNotificationsKey);
    await prefs.remove(_dndEnabledKey);
    await prefs.remove(_dndStartTimeKey);
    await prefs.remove(_dndEndTimeKey);
  }
}
