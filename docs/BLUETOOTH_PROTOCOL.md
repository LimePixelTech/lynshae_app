# 🔌 蓝牙通信协议

> 详细的蓝牙通信协议规范

---

## 📡 协议概述

### 通信模型

```
┌─────────────┐         ┌─────────────┐
│   Mobile    │         │   Device    │
│    App      │         │   (Dog)     │
└──────┬──────┘         └──────┬──────┘
       │                       │
       │   Command (JSON)      │
       │ ────────────────────> │
       │                       │
       │   Response (JSON)     │
       │ <──────────────────── │
       │                       │
       │   Status Update       │
       │ <──────────────────── │
       │                       │
```

### 通信特性

- **协议类型**: 基于 JSON 的文本协议
- **编码格式**: UTF-8
- **传输方式**: Bluetooth SPP (Serial Port Profile)
- **字节序**: 大端序 (Big Endian)
- **超时时间**: 30 秒
- **重试次数**: 3 次

---

## 📦 数据包格式

### 基本结构

```
┌──────────────┬──────────────┬──────────────┬──────────────┐
│    Header    │    Length    │    Payload   │   Checksum   │
│   (2 bytes)  │   (2 bytes)  │   (N bytes)  │   (2 bytes)  │
└──────────────┴──────────────┴──────────────┴──────────────┘
```

### 字段说明

**Header (2 bytes)**
- Magic Number: `0xAA 0x55`
- 用于标识数据包起始

**Length (2 bytes)**
- Payload 长度（大端序）
- 范围：0 - 65535

**Payload (N bytes)**
- JSON 格式的指令或数据
- UTF-8 编码

**Checksum (2 bytes)**
- CRC16 校验和
- 计算范围：Length + Payload

---

## 🎯 指令格式

### 命令结构

```json
{
  "cmd": "command_name",
  "seq": 12345,
  "ts": 1678123456789,
  "params": {
    "key": "value"
  }
}
```

**字段说明**
- `cmd`: 命令名称
- `seq`: 序列号（递增，用于去重）
- `ts`: 时间戳（毫秒）
- `params`: 命令参数

### 响应结构

```json
{
  "success": true,
  "seq": 12345,
  "ts": 1678123456890,
  "data": {
    "key": "value"
  },
  "error": null
}
```

**字段说明**
- `success`: 是否成功
- `seq`: 对应的请求序列号
- `ts`: 响应时间戳
- `data`: 返回数据
- `error`: 错误信息（失败时）

---

## 📋 指令列表

### 1. 设备控制指令

#### 移动控制 (move)

**请求**
```json
{
  "cmd": "move",
  "seq": 1,
  "ts": 1678123456789,
  "params": {
    "direction": "forward",
    "speed": 50,
    "duration": 1000
  }
}
```

**参数说明**
- `direction`: 方向
  - `forward` - 前进
  - `backward` - 后退
  - `left` - 左转
  - `right` - 右转
  - `stop` - 停止
- `speed`: 速度 (0-100)
- `duration`: 持续时间（毫秒），0 表示持续执行

**响应**
```json
{
  "success": true,
  "seq": 1,
  "ts": 1678123456890,
  "data": {
    "status": "executing"
  },
  "error": null
}
```

---

#### 动作执行 (action)

**请求**
```json
{
  "cmd": "action",
  "seq": 2,
  "ts": 1678123456789,
  "params": {
    "action": "shake",
    "repeat": 1
  }
}
```

**参数说明**
- `action`: 动作名称
  - `shake` - 握手
  - `sit` - 坐下
  - `rollover` - 打滚
  - `jump` - 跳跃
  - `bark` - 吠叫
  - `dance` - 跳舞
  - `beg` - 乞讨
  - `spin` - 转圈
  - `lie_down` - 躺下
  - `stay` - 等待
- `repeat`: 重复次数 (1-10)

**响应**
```json
{
  "success": true,
  "seq": 2,
  "ts": 1678123456890,
  "data": {
    "action": "shake",
    "completed": true
  },
  "error": null
}
```

---

#### 模式切换 (mode)

**请求**
```json
{
  "cmd": "mode",
  "seq": 3,
  "ts": 1678123456789,
  "params": {
    "mode": "companion"
  }
}
```

**参数说明**
- `mode`: 模式名称
  - `companion` - 陪伴模式
  - `patrol` - 巡逻模式
  - `follow` - 跟随模式
  - `sleep` - 休眠模式

**响应**
```json
{
  "success": true,
  "seq": 3,
  "ts": 1678123456890,
  "data": {
    "mode": "companion",
    "previous_mode": "sleep"
  },
  "error": null
}
```

---

### 2. 状态查询指令

#### 获取状态 (get_status)

**请求**
```json
{
  "cmd": "get_status",
  "seq": 4,
  "ts": 1678123456789,
  "params": {}
}
```

**响应**
```json
{
  "success": true,
  "seq": 4,
  "ts": 1678123456890,
  "data": {
    "status": "idle",
    "mode": "companion",
    "battery": 85,
    "signal": -60,
    "firmware": "1.0.0",
    "uptime": 3600
  },
  "error": null
}
```

**数据字段**
- `status`: 当前状态
- `mode`: 当前模式
- `battery`: 电量百分比
- `signal`: 信号强度 (dBm)
- `firmware`: 固件版本
- `uptime`: 运行时长（秒）

---

#### 获取电量 (get_battery)

**请求**
```json
{
  "cmd": "get_battery",
  "seq": 5,
  "ts": 1678123456789,
  "params": {}
}
```

**响应**
```json
{
  "success": true,
  "seq": 5,
  "ts": 1678123456890,
  "data": {
    "level": 85,
    "voltage": 3.7,
    "current": 0.5,
    "temperature": 25,
    "charging": false,
    "remaining_minutes": 120
  },
  "error": null
}
```

---

### 3. 配置指令

#### 设置配置 (set_config)

**请求**
```json
{
  "cmd": "set_config",
  "seq": 6,
  "ts": 1678123456789,
  "params": {
    "max_speed": 80,
    "auto_reconnect": true,
    "led_brightness": 50
  }
}
```

**参数说明**
- `max_speed`: 最大速度 (0-100)
- `auto_reconnect`: 自动重连
- `led_brightness`: LED 亮度 (0-100)

**响应**
```json
{
  "success": true,
  "seq": 6,
  "ts": 1678123456890,
  "data": {
    "saved": true
  },
  "error": null
}
```

---

#### 获取配置 (get_config)

**请求**
```json
{
  "cmd": "get_config",
  "seq": 7,
  "ts": 1678123456789,
  "params": {}
}
```

**响应**
```json
{
  "success": true,
  "seq": 7,
  "ts": 1678123456890,
  "data": {
    "max_speed": 80,
    "auto_reconnect": true,
    "led_brightness": 50,
    "volume": 70,
    "language": "zh-CN"
  },
  "error": null
}
```

---

### 4. 系统指令

#### 重启设备 (reboot)

**请求**
```json
{
  "cmd": "reboot",
  "seq": 8,
  "ts": 1678123456789,
  "params": {}
}
```

**响应**
```json
{
  "success": true,
  "seq": 8,
  "ts": 1678123456890,
  "data": {
    "rebooting": true
  },
  "error": null
}
```

---

#### 恢复出厂 (reset)

**请求**
```json
{
  "cmd": "reset",
  "seq": 9,
  "ts": 1678123456789,
  "params": {
    "confirm": true
  }
}
```

**参数说明**
- `confirm`: 确认标志（防止误操作）

**响应**
```json
{
  "success": true,
  "seq": 9,
  "ts": 1678123456890,
  "data": {
    "resetting": true
  },
  "error": null
}
```

---

#### 固件升级 (ota_update)

**请求**
```json
{
  "cmd": "ota_update",
  "seq": 10,
  "ts": 1678123456789,
  "params": {
    "version": "1.0.1",
    "url": "https://...",
    "checksum": "abc123..."
  }
}
```

**响应**
```json
{
  "success": true,
  "seq": 10,
  "ts": 1678123456890,
  "data": {
    "downloading": true,
    "progress": 0
  },
  "error": null
}
```

---

## 📤 主动上报

### 状态更新 (status_update)

设备主动推送状态变化：

```json
{
  "type": "status_update",
  "ts": 1678123456789,
  "data": {
    "status": "moving",
    "battery": 84,
    "signal": -62
  }
}
```

### 事件通知 (event)

设备主动推送事件：

```json
{
  "type": "event",
  "ts": 1678123456789,
  "data": {
    "event": "obstacle_detected",
    "level": "warning",
    "message": "前方检测到障碍物"
  }
}
```

### 电量告警 (battery_alert)

低电量主动推送：

```json
{
  "type": "battery_alert",
  "ts": 1678123456789,
  "data": {
    "level": 15,
    "action": "return_to_charge"
  }
}
```

---

## 🔐 错误码

### 通用错误

| 错误码 | 说明 |
|--------|------|
| 1001 | 无效命令 |
| 1002 | 参数错误 |
| 1003 | 序列号错误 |
| 1004 | 校验和错误 |
| 1005 | 超时错误 |

### 设备错误

| 错误码 | 说明 |
|--------|------|
| 2001 | 设备忙 |
| 2002 | 设备未就绪 |
| 2003 | 电量不足 |
| 2004 | 传感器异常 |
| 2005 | 电机异常 |

### 通信错误

| 错误码 | 说明 |
|--------|------|
| 3001 | 连接断开 |
| 3002 | 信号太弱 |
| 3003 | 干扰严重 |
| 3004 | 配对失败 |

### 错误响应示例

```json
{
  "success": false,
  "seq": 1,
  "ts": 1678123456890,
  "data": null,
  "error": {
    "code": 2003,
    "message": "电量不足，请充电后重试"
  }
}
```

---

## 🔧 实现示例

### Flutter 实现

```dart
class BluetoothProtocol {
  static const List<int> header = [0xAA, 0x55];
  
  /// 编码数据包
  List<int> encodePacket(String payload) {
    final payloadBytes = utf8.encode(payload);
    final length = payloadBytes.length;
    
    // 构建数据包
    final packet = <int>[
      ...header,
      (length >> 8) & 0xFF,  // Length High
      length & 0xFF,         // Length Low
      ...payloadBytes,
    ];
    
    // 计算校验和
    final checksum = calculateCRC16(packet.sublist(2));
    packet.add((checksum >> 8) & 0xFF);
    packet.add(checksum & 0xFF);
    
    return packet;
  }
  
  /// 解码数据包
  String? decodePacket(List<int> packet) {
    // 验证头部
    if (packet[0] != 0xAA || packet[1] != 0x55) {
      return null;
    }
    
    // 读取长度
    final length = (packet[2] << 8) | packet[3];
    
    // 验证长度
    if (packet.length != 4 + length + 2) {
      return null;
    }
    
    // 验证校验和
    final receivedChecksum = (packet[packet.length - 2] << 8) |
        packet[packet.length - 1];
    final calculatedChecksum = calculateCRC16(packet.sublist(2, packet.length - 2));
    
    if (receivedChecksum != calculatedChecksum) {
      return null;
    }
    
    // 提取 payload
    final payloadBytes = packet.sublist(4, 4 + length);
    return utf8.decode(payloadBytes);
  }
  
  /// 计算 CRC16
  int calculateCRC16(List<int> data) {
    int crc = 0xFFFF;
    for (final byte in data) {
      crc ^= byte;
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x0001) != 0) {
          crc = (crc >> 1) ^ 0xA001;
        } else {
          crc = crc >> 1;
        }
      }
    }
    return crc;
  }
  
  /// 创建命令
  String createCommand({
    required String cmd,
    required int seq,
    Map<String, dynamic>? params,
  }) {
    return jsonEncode({
      'cmd': cmd,
      'seq': seq,
      'ts': DateTime.now().millisecondsSinceEpoch,
      'params': params ?? {},
    });
  }
}

// 使用示例
final protocol = BluetoothProtocol();

// 发送移动命令
final command = protocol.createCommand(
  cmd: 'move',
  seq: 1,
  params: {
    'direction': 'forward',
    'speed': 50,
  },
);

final packet = protocol.encodePacket(command);
await bluetoothConnection.write(packet);
```

---

## 📊 性能指标

### 延迟要求

- **命令响应**: < 100ms
- **状态更新**: < 50ms
- **紧急停止**: < 50ms

### 吞吐量

- **最大带宽**: 115200 bps
- **实际吞吐**: ~10KB/s
- **包大小**: 建议 < 1KB

### 可靠性

- **丢包率**: < 1%
- **错误率**: < 0.1%
- **重传率**: < 5%

---

## 📚 相关文档

- [项目概述](./PROJECT_OVERVIEW.md)
- [架构设计](./ARCHITECTURE.md)
- [开发指南](./DEVELOPMENT_GUIDE.md)
- [数据模型](./DATA_MODELS.md)

---

*Last Updated: 2026-03-04 18:45*
