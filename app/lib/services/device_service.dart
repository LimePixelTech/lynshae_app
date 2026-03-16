import '../models/device_model.dart';
import 'api_client.dart';

/// 设备服务 - 处理设备相关 API
class DeviceService {
  static final ApiClient _apiClient = ApiClient();

  /// 获取设备列表
  static Future<List<DeviceModel>> getDevices() async {
    final response = await _apiClient.get('/devices', requiresAuth: true);

    if (response.success && response.data != null) {
      final devicesData = response.data! as List;
      return devicesData
          .map((item) => DeviceModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  /// 获取设备详情
  static Future<DeviceModel?> getDeviceDetail(String deviceId) async {
    final response = await _apiClient.get('/devices/$deviceId', requiresAuth: true);

    if (response.success && response.data != null) {
      return DeviceModel.fromJson(response.data!);
    }

    return null;
  }

  /// 绑定设备
  static Future<bool> bindDevice(String deviceId, String bindCode) async {
    final response = await _apiClient.post(
      '/devices/$deviceId/bind',
      body: {'bindCode': bindCode},
      requiresAuth: true,
    );

    return response.success;
  }

  /// 控制设备
  static Future<bool> controlDevice(
    String deviceId,
    String action,
    Map<String, dynamic> params,
  ) async {
    final response = await _apiClient.post(
      '/devices/$deviceId/control',
      body: {
        'action': action,
        'params': params,
      },
      requiresAuth: true,
    );

    return response.success;
  }
}
