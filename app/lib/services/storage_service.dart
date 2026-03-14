import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储服务
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
  
  SharedPreferences? _prefs;
  
  /// 初始化
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  /// 保存字符串
  Future<bool> setString(String key, String value) async {
    await _ensureInit();
    return await _prefs!.setString(key, value);
  }
  
  /// 获取字符串
  String? getString(String key) {
    if (_prefs == null) return null;
    return _prefs!.getString(key);
  }
  
  /// 保存整数
  Future<bool> setInt(String key, int value) async {
    await _ensureInit();
    return await _prefs!.setInt(key, value);
  }
  
  /// 获取整数
  int? getInt(String key) {
    if (_prefs == null) return null;
    return _prefs!.getInt(key);
  }
  
  /// 保存布尔值
  Future<bool> setBool(String key, bool value) async {
    await _ensureInit();
    return await _prefs!.setBool(key, value);
  }
  
  /// 获取布尔值
  bool? getBool(String key) {
    if (_prefs == null) return null;
    return _prefs!.getBool(key);
  }
  
  /// 保存 JSON 对象
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    await _ensureInit();
    return await _prefs!.setString(key, jsonEncode(value));
  }
  
  /// 获取 JSON 对象
  Map<String, dynamic>? getJson(String key) {
    if (_prefs == null) return null;
    final String? jsonStr = _prefs!.getString(key);
    if (jsonStr == null) return null;
    try {
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('解析 JSON 失败：$e');
      return null;
    }
  }
  
  /// 删除键
  Future<bool> remove(String key) async {
    await _ensureInit();
    return await _prefs!.remove(key);
  }
  
  /// 清空所有
  Future<bool> clear() async {
    await _ensureInit();
    return await _prefs!.clear();
  }
  
  /// 确保初始化
  Future<void> _ensureInit() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}
