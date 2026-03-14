import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../common/components/app_navbar.dart';
import '../../common/components/settings_tile.dart';
import '../services/update_service.dart';

/// 检查更新界面
///
/// 包含 APP 更新检查 和 设备固件更新检查
class CheckUpdateScreen extends StatefulWidget {
  const CheckUpdateScreen({super.key});

  @override
  State<CheckUpdateScreen> createState() => _CheckUpdateScreenState();
}

class _CheckUpdateScreenState extends State<CheckUpdateScreen> {
  // APP 更新相关
  String _appVersion = 'v1.0.0';
  bool _isCheckingAppUpdate = false;
  bool _hasAppUpdate = false;
  String _latestAppVersion = '';
  String _appUpdateNotes = '';

  // 设备固件更新相关
  final List<Map<String, dynamic>> _devices = [
    {'id': '1', 'name': 'LynShae Pro', 'type': '智能设备', 'firmwareVersion': '1.0.0'},
    {'id': '2', 'name': 'MeowBot', 'type': '机器猫', 'firmwareVersion': '1.0.0'},
  ];

  bool _isCheckingFirmware = false;
  final Map<String, bool> _hasFirmwareUpdate = {};
  final Map<String, String> _latestFirmwareVersion = {};

  // 下载状态
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _downloadingDeviceId = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final version = await UpdateService.getVersion();
    if (mounted) {
      setState(() {
        _appVersion = 'v$version';
      });
    }
  }

  /// 检查 APP 更新
  Future<void> _checkAppUpdate() async {
    setState(() {
      _isCheckingAppUpdate = true;
    });

    try {
      final result = await UpdateService.checkForUpdate();
      if (mounted) {
        setState(() {
          _isCheckingAppUpdate = false;
          _hasAppUpdate = result['hasUpdate'] as bool;
          _latestAppVersion = result['latestVersion'] as String? ?? '';
          _appUpdateNotes = result['releaseNotes'] as String? ?? '';
        });

        if (_hasAppUpdate) {
          _showAppUpdateDialog();
        } else {
          AppUtils.showSuccess(context, '已是最新版本');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingAppUpdate = false;
        });
        AppUtils.showError(context, '检查更新失败');
      }
    }
  }

  /// 检查设备固件更新
  Future<void> _checkDeviceFirmwareUpdate(String deviceId, String deviceType) async {
    setState(() {
      _isCheckingFirmware = true;
    });

    try {
      final result = await UpdateService.checkDeviceFirmwareUpdate(
        deviceId: deviceId,
        deviceType: deviceType,
      );

      if (mounted) {
        setState(() {
          _isCheckingFirmware = false;
          _hasFirmwareUpdate[deviceId] = result['hasUpdate'] as bool;
          _latestFirmwareVersion[deviceId] = result['latestVersion'] as String? ?? '';
        });

        if (_hasFirmwareUpdate[deviceId] == true) {
          _showFirmwareUpdateDialog(deviceId, deviceType, result);
        } else {
          AppUtils.showSuccess(context, '已是最新固件版本');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingFirmware = false;
        });
        AppUtils.showError(context, '检查固件更新失败');
      }
    }
  }

  /// 显示 APP 更新对话框
  void _showAppUpdateDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          '发现新版本',
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '最新版本：$_latestAppVersion',
              style: TextStyle(
                color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '更新内容：',
              style: TextStyle(
                color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _appUpdateNotes.isNotEmpty ? _appUpdateNotes : '优化系统性能，修复已知问题',
              style: TextStyle(
                color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '稍后再说',
              style: TextStyle(
                color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AppUtils.showInfo(context, '开始下载更新...');
            },
            child: Text(
              '立即更新',
              style: TextStyle(
                color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示固件更新对话框
  void _showFirmwareUpdateDialog(String deviceId, String deviceType, Map<String, dynamic> result) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          '发现新固件版本',
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '最新版本：${result['latestVersion']}',
              style: TextStyle(
                color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '当前版本：${result['currentVersion']}',
              style: TextStyle(
                color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
                fontSize: 13,
              ),
            ),
            if (result['fileSize'] != null && result['fileSize'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '文件大小：${result['fileSize']}',
                style: TextStyle(
                  color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              '更新内容：',
              style: TextStyle(
                color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result['releaseNotes'] as String? ?? '优化设备性能，提升稳定性',
              style: TextStyle(
                color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
                fontSize: 13,
              ),
            ),
            if (result['forceUpdate'] == true) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark 
                      ? AppTheme.accentOrange.withAlpha(30) 
                      : AppTheme.warmCoral.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark 
                        ? AppTheme.accentOrange.withAlpha(80) 
                        : AppTheme.warmCoral.withAlpha(50),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: isDark ? AppTheme.accentOrange : AppTheme.warmCoral,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '此更新为强制更新，请尽快完成升级',
                        style: TextStyle(
                          color: isDark ? AppTheme.accentOrange : AppTheme.warmCoral,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '稍后再说',
              style: TextStyle(
                color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadFirmware(deviceId);
            },
            child: Text(
              '立即更新',
              style: TextStyle(
                color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 下载固件
  Future<void> _downloadFirmware(String deviceId) async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _downloadingDeviceId = deviceId;
    });

    try {
      await UpdateService.downloadFirmwareUpdate(
        deviceId: deviceId,
        updateUrl: '',
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _downloadProgress = progress;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0.0;
          _downloadingDeviceId = '';
        });
        AppUtils.showSuccess(context, '固件下载完成，请保持设备连接');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0.0;
          _downloadingDeviceId = '';
        });
        AppUtils.showError(context, '下载失败');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightBgTop,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部导航栏
            const AppNavbar(title: '检查更新', showNotification: false),
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    // APP 更新卡片
                    _buildAppUpdateCard(),
                    const SizedBox(height: 16),
                    // 设备固件更新卡片
                    _buildDeviceFirmwareCard(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// APP 更新卡片
  Widget _buildAppUpdateCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SettingsCard(
      children: [
        SettingsTile(
          icon: Icons.system_update_outlined,
          iconBackgroundColor: isDark 
              ? AppTheme.primaryBlue.withAlpha(40) 
              : AppTheme.warmBeige.withAlpha(30),
          iconColor: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
          title: '灵羲 APP',
          subtitle: _hasAppUpdate ? '新版本：$_latestAppVersion' : _appVersion,
          trailing: _isCheckingAppUpdate
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
                    ),
                  ),
                )
              : _hasAppUpdate
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark 
                            ? AppTheme.accentOrange.withAlpha(30) 
                            : AppTheme.warmCoral.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'NEW',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.accentOrange : AppTheme.warmCoral,
                        ),
                      ),
                    )
                  : Text(
                      '最新',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
                      ),
                    ),
          onTap: _checkAppUpdate,
          showArrow: !_isCheckingAppUpdate,
          showDivider: false,
        ),
      ],
    );
  }

  /// 设备固件更新卡片
  Widget _buildDeviceFirmwareCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SettingsCard(
      children: [
        // 卡片标题
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            '设备固件更新',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
            ),
          ),
        ),
        // 设备列表
        ..._devices.map((device) {
          final deviceId = device['id'] as String;
          final hasUpdate = _hasFirmwareUpdate[deviceId] ?? false;

          return SettingsTile(
            icon: Icons.devices_rounded,
            iconBackgroundColor: isDark 
                ? Colors.white.withAlpha(15) 
                : AppTheme.warmBeige.withAlpha(20),
            iconColor: isDark ? Colors.white : AppTheme.lightTextPrimary,
            title: device['name'] as String,
            subtitle: '当前：v${device['firmwareVersion']}',
            trailing: _isCheckingFirmware && _downloadingDeviceId == deviceId
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
                      ),
                    ),
                  )
                : _isDownloading && _downloadingDeviceId == deviceId
                    ? SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${(_downloadProgress * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: _downloadProgress,
                                backgroundColor: isDark ? Colors.white.withAlpha(20) : AppTheme.warmBeige.withAlpha(30),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
                                ),
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ),
                      )
                    : hasUpdate
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark 
                                  ? AppTheme.accentOrange.withAlpha(30) 
                                  : AppTheme.warmCoral.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.accentOrange : AppTheme.warmCoral,
                              ),
                            ),
                          )
                        : Text(
                            '最新',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
                            ),
                          ),
            onTap: () => _checkDeviceFirmwareUpdate(deviceId, device['type'] as String),
            showArrow: !(_isCheckingFirmware && _downloadingDeviceId == deviceId) &&
                !(_isDownloading && _downloadingDeviceId == deviceId),
            showDivider: device != _devices.last,
          );
        }),
      ],
    );
  }
}
