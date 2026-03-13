import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import 'device_list_screen.dart';
import 'about_screen.dart';
import 'user_profile_screen.dart';
import 'permissions_screen.dart';
import '../services/cache_service.dart';
import '../services/update_service.dart';

/// 我的页面 - 用户设置与设备管理
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String cacheSize = '计算中...';
  bool isClearingCache = false;
  String versionInfo = 'v1.0.0';

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
    _loadVersionInfo();
  }

  Future<void> _loadCacheSize() async {
    final size = await CacheService.getCacheSize();
    if (mounted) {
      setState(() {
        cacheSize = CacheService.formatCacheSize(size);
      });
    }
  }

  Future<void> _loadVersionInfo() async {
    final version = await UpdateService.getVersion();
    if (mounted) {
      setState(() {
        versionInfo = 'v$version';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // 顶部导航栏
              _buildNavBar(context),
              const SizedBox(height: 12),
              // 用户信息头部
              _buildUserHeader(),
              const SizedBox(height: 24),
              // 设备列表入口
              _buildDeviceListCard(context),
              const SizedBox(height: 16),
              // 设置列表
              _buildSettingsCard(context),
              const SizedBox(height: 16),
              // 关于/其他
              _buildAboutSection(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '我的',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            _buildHeaderIcon(Icons.notifications_outlined),
            const SizedBox(width: 12),
            _buildHeaderIcon(Icons.qr_code_scanner_rounded),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: Colors.white70,
        size: 22,
      ),
    );
  }

  Widget _buildUserHeader() {
    return GestureDetector(
      onTap: () {
        AppUtils.vibrate();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfileScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBlue.withAlpha(80),
                    AppTheme.primaryBlue.withAlpha(40),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppTheme.primaryBlue,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Freakz3z',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '点击编辑个人信息',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white30,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white30,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceListCard(BuildContext context) {
    final devices = [
      {'name': 'LynShae Pro', 'type': '机器狗', 'status': '在线', 'icon': Icons.pets_rounded},
      {'name': 'MeowBot', 'type': '机器猫', 'status': '在线', 'icon': Icons.smart_toy_rounded},
      {'name': '晨曦闹钟', 'type': '智能时钟', 'status': '离线', 'icon': Icons.access_alarm_rounded},
      {'name': '护眼台灯', 'type': '智能灯具', 'status': '离线', 'icon': Icons.lightbulb_rounded},
    ];

    return GestureDetector(
      onTap: () {
        AppUtils.vibrate();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeviceListScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withAlpha(30),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.devices_rounded,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '设备列表',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '管理已连接的设备',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white30,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${devices.where((d) => d['status'] == '在线').length}/${devices.length}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white30,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // 通知设置
          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: '通知设置',
            subtitle: '系统通知、应用通知',
            onTap: () => AppUtils.showSuccess(context, '通知设置 功能开发中'),
          ),
          _buildDivider(),
          // 语言设置
          _buildSettingsItem(
            icon: Icons.language_outlined,
            title: '语言设置',
            subtitle: '简体中文',
            onTap: () => AppUtils.showSuccess(context, '语言设置 功能开发中'),
          ),
          _buildDivider(),
          // 系统权限管理
          _buildSettingsItem(
            icon: Icons.apps_outlined,
            title: '系统权限管理',
            subtitle: '管理应用权限',
            onTap: () {
              AppUtils.vibrate();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PermissionsScreen()),
              );
            },
          ),
          _buildDivider(),
          // 清除缓存
          _buildSettingsItem(
            icon: Icons.delete_outline_rounded,
            title: '清除缓存',
            subtitle: '释放存储空间',
            trailing: isClearingCache
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                    ),
                  )
                : Text(
                    cacheSize,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
            onTap: _showClearCacheDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return GestureDetector(
      onTap: () {
        AppUtils.vibrate();
        if (onTap != null) onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (trailing != null) trailing,
            if (showArrow && trailing == null)
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white30,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 68,
      endIndent: 16,
      color: Colors.white.withAlpha(10),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // 关于灵羲
          _buildSettingsItem(
            icon: Icons.info_outline_rounded,
            title: '关于灵羲',
            subtitle: '用户协议、隐私政策',
            onTap: () {
              AppUtils.vibrate();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          _buildDivider(),
          // 检查更新
          _buildSettingsItem(
            icon: Icons.system_update_outlined,
            title: '检查更新',
            subtitle: '当前版本 $versionInfo',
            onTap: _checkForUpdate,
            showArrow: true,
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          '清除缓存',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '确定要清除 $cacheSize 缓存数据吗？',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '取消',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearCache();
            },
            child: const Text(
              '确定',
              style: TextStyle(color: AppTheme.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCache() async {
    setState(() => isClearingCache = true);
    final success = await CacheService.clearCache();
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        isClearingCache = false;
      });
      _loadCacheSize();
      if (success) {
        AppUtils.showSuccess(context, '缓存已清除');
      } else {
        AppUtils.showError(context, '清除缓存失败');
      }
    }
  }

  Future<void> _checkForUpdate() async {
    AppUtils.vibrate();
    final result = await UpdateService.checkForUpdate();
    if (mounted) {
      if (result['hasUpdate']) {
        AppUtils.showSuccess(context, '发现新版本：${result['latestVersion']}');
      } else {
        AppUtils.showSuccess(context, '已是最新版本');
      }
    }
  }
}
