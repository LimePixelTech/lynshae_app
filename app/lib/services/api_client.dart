import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// HTTP 响应包装类
class ApiResponse<T> {
  final String code;
  final String? message;
  final T? data;
  final bool success;

  ApiResponse({
    required this.code,
    this.message,
    this.data,
    required this.success,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    // 支持两种响应格式：
    // 1. 新格式：{success: true, message: '', data: {}}
    // 2. 旧格式：{code: 'SUCCESS', message: '', data: {}}
    final bool isSuccess = json['success'] == true || json['code'] == 'SUCCESS';
    final String code = json['code'] ?? (isSuccess ? 'SUCCESS' : 'INTERNAL_ERROR');
    
    return ApiResponse(
      code: code,
      message: json['message'],
      data: fromJson != null && json['data'] != null 
          ? fromJson(json['data']) 
          : json['data'] as T?,
      success: isSuccess,
    );
  }
}

/// API 客户端 - 封装所有 HTTP 请求
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final String _baseUrl = ApiConfig.baseUrl;
  String? _accessToken;

  /// 设置 Access Token
  void setAccessToken(String? token) {
    _accessToken = token;
  }

  /// 获取 Access Token
  String? getAccessToken() {
    return _accessToken;
  }

  /// 获取请求头
  Map<String, String> _getHeaders({bool requiresAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (requiresAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  /// GET 请求
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    bool requiresAuth = false,
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );
      final response = await http.get(
        uri,
        headers: _getHeaders(requiresAuth: requiresAuth),
      ).timeout(Duration(milliseconds: ApiConfig.connectTimeout));

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        code: 'NETWORK_ERROR',
        message: '网络请求失败：${e.toString()}',
        data: null,
        success: false,
      );
    }
  }

  /// POST 请求
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getHeaders(requiresAuth: requiresAuth),
        body: body != null ? json.encode(body) : null,
      ).timeout(Duration(milliseconds: ApiConfig.connectTimeout));

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        code: 'NETWORK_ERROR',
        message: '网络请求失败：${e.toString()}',
        data: null,
        success: false,
      );
    }
  }

  /// PUT 请求
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getHeaders(requiresAuth: requiresAuth),
        body: body != null ? json.encode(body) : null,
      ).timeout(Duration(milliseconds: ApiConfig.connectTimeout));

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        code: 'NETWORK_ERROR',
        message: '网络请求失败：${e.toString()}',
        data: null,
        success: false,
      );
    }
  }

  /// DELETE 请求
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    bool requiresAuth = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getHeaders(requiresAuth: requiresAuth),
      ).timeout(Duration(milliseconds: ApiConfig.connectTimeout));

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse(
        code: 'NETWORK_ERROR',
        message: '网络请求失败：${e.toString()}',
        data: null,
        success: false,
      );
    }
  }

  /// 处理响应
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse<T>.fromJson(json, fromJson);
    } catch (e) {
      return ApiResponse(
        code: 'PARSE_ERROR',
        message: '响应解析失败：${e.toString()}',
        data: null,
        success: false,
      );
    }
  }
}
