import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/device_model.dart';

/// 蓝牙服务 - 管理设备连接和通信
class BluetoothService extends ChangeNotifier {
  BluetoothConnection? _connection;
  DeviceModel? _connectedDevice;
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  final StreamController<BluetoothConnectionState> _stateController = StreamController.broadcast();
  
  // 获取单例
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  /// 连接状态流
  Stream<BluetoothConnectionState> get connectionStateStream => _stateController.stream;
  BluetoothConnectionState get connectionState => _connectionState;
  DeviceModel? get connectedDevice => _connectedDevice;
  bool get isConnected => _connectionState == BluetoothConnectionState.connected;

  /// 扫描附近的蓝牙设备
  Stream<BluetoothDevice> scanDevices() async* {
    try {
      final discoveryStream = FlutterBluetoothSerial.instance.startDiscovery();
      await for (BluetoothDiscoveryResult result in discoveryStream) {
        yield result.device;
      }
    } catch (e) {
      debugPrint('扫描设备失败：$e');
      rethrow;
    }
  }

  /// 连接到指定设备
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      _connectionState = BluetoothConnectionState.connecting;
      _stateController.add(_connectionState);
      notifyListeners();

      _connection = await BluetoothConnection.toAddress(device.address);
      
      _connection!.input!.listen((data) {
        _handleIncomingData(data);
      }).onDone(() {
        _handleConnectionLost();
      });

      _connectedDevice = DeviceModel(
        id: device.address,
        name: device.name ?? 'Unknown Device',
        macAddress: device.address,
        firmwareVersion: 'v1.0.0',
        isOnline: true,
      );

      _connectionState = BluetoothConnectionState.connected;
      _stateController.add(_connectionState);
      notifyListeners();
      
      return true;
    } catch (e) {
      debugPrint('连接失败：$e');
      _connectionState = BluetoothConnectionState.disconnected;
      _stateController.add(_connectionState);
      notifyListeners();
      return false;
    }
  }

  /// 断开连接
  Future<void> disconnect() async {
    try {
      if (_connection != null) {
        await _connection!.finish();
        _connection = null;
      }
      _connectedDevice = null;
      _connectionState = BluetoothConnectionState.disconnected;
      _stateController.add(_connectionState);
      notifyListeners();
    } catch (e) {
      debugPrint('断开连接失败：$e');
    }
  }

  /// 发送数据到设备
  Future<bool> sendData(String data) async {
    final connection = _connection;
    if (connection == null) {
      return false;
    }

    try {
      connection.output.add(Uint8List.fromList(utf8.encode(data)));
      await connection.output.allSent;
      return true;
    } catch (e) {
      debugPrint('发送数据失败：$e');
      return false;
    }
  }

  /// 发送控制命令
  Future<bool> sendCommand(String command, {Map<String, dynamic>? params}) async {
    final jsonData = {
      'cmd': command,
      'params': params ?? {},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    return sendData(jsonEncode(jsonData));
  }

  /// 处理接收到的数据
  void _handleIncomingData(Uint8List data) {
    try {
      final String received = utf8.decode(data);
      debugPrint('收到数据：$received');
      // TODO: 解析并处理接收到的数据
    } catch (e) {
      debugPrint('解析数据失败：$e');
    }
  }

  /// 处理连接丢失
  void _handleConnectionLost() {
    _connectionState = BluetoothConnectionState.disconnected;
    _stateController.add(_connectionState);
    _connectedDevice = null;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    _stateController.close();
    super.dispose();
  }
}

/// 蓝牙连接状态枚举
enum BluetoothConnectionState {
  disconnected,      // 已断开
  connecting,        // 连接中
  connected,         // 已连接
  disconnecting,     // 断开中
  error,             // 错误
}

extension BluetoothConnectionStateExtension on BluetoothConnectionState {
  String get displayName {
    switch (this) {
      case BluetoothConnectionState.disconnected:
        return '已断开';
      case BluetoothConnectionState.connecting:
        return '连接中';
      case BluetoothConnectionState.connected:
        return '已连接';
      case BluetoothConnectionState.disconnecting:
        return '断开中';
      case BluetoothConnectionState.error:
        return '错误';
    }
  }
}
