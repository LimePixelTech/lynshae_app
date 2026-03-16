// API 配置 - 管理不同环境的 API 地址
import 'dart:io' show Platform;

class ApiConfig {
  // 开发环境
  // Android 模拟器中使用 10.0.2.2 访问主机，iOS 模拟器使用 localhost
  static const String androidDevBaseUrl = 'http://10.0.2.2:3005/api/v1';
  static const String iosDevBaseUrl = 'http://localhost:3005/api/v1';
  
  // 生产环境
  static const String prodBaseUrl = 'https://api.lynshae.com/api/v1';
  
  // 当前环境
  static const String currentEnv = 'development'; // 或 'production'
  
  // 获取当前环境的 Base URL
  static String get baseUrl {
    if (currentEnv == 'production') {
      return prodBaseUrl;
    }
    // 根据平台返回不同的开发环境地址
    if (Platform.isIOS) {
      return iosDevBaseUrl;
    }
    return androidDevBaseUrl;
  }
  
  // 连接超时时间（毫秒）
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  
  // 健康检查接口
  static const String healthEndpoint = '/health';
  
  // API 版本
  static const String version = '1.0.0';
}
