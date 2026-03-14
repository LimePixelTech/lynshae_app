import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import 'about_screen.dart';
import 'user_profile_screen.dart';
import 'permissions_screen.dart';
import 'notification_settings_screen.dart';
import 'check_update_screen.dart';
import '../services/cache_service.dart';
import '../services/update_service.dart';
import '../services/auth_service.dart';
import '../main.dart';

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
              // 设置列表
              _buildSettingsCard(context),
              const SizedBox(height: 16),
              // 关于
              _buildAboutSection(context),
              const SizedBox(height: 16),
              // 退出登录（独立放在最底部）
              _buildLogoutSection(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildHeaderIcon(Icons.notifications_outlined, isDark),
        const SizedBox(width: 12),
        _buildHeaderIcon(Icons.qr_code_scanner_rounded, isDark, isScan: true, onTap: () {
          AppUtils.vibrate();
          AppUtils.showInfo(context, '扫描二维码 功能开发中');
        }),
      ],
    );
  }

  Widget _buildHeaderIcon(IconData icon, bool isDark, {bool isScan = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withAlpha(20)
              : AppTheme.warmBeige.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppTheme.primaryBlue.withAlpha(80),
                          AppTheme.primaryBlue.withAlpha(40),
                        ]
                      : [
                          AppTheme.warmBeige.withAlpha(80),
                          AppTheme.warmBeige.withAlpha(40),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.person_rounded,
                color: isDark ? AppTheme.primaryBlue : AppTheme.warmBeige,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Freakz3z',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '点击编辑个人信息',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white30 : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // 主题切换
          _buildThemeSwitchItem(context),
          _buildDivider(isDark),
          // 通知设置
          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: '通知设置',
            subtitle: '系统通知、应用通知',
            onTap: () {
              AppUtils.vibrate();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
              );
            },
          ),
          _buildDivider(isDark),
          // 语言设置
          _buildSettingsItem(
            icon: Icons.language_outlined,
            title: '语言设置',
            subtitle: '简体中文',
            onTap: () => AppUtils.showSuccess(context, '语言设置 功能开发中'),
          ),
          _buildDivider(isDark),
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
          _buildDivider(isDark),
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
                      color: isDark ? Colors.white54 : AppTheme.lightTextMuted,
                    ),
                  ),
            onTap: _showClearCacheDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSwitchItem(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: LynshaeApp.themeNotifier,
      builder: (context, themeMode, child) {
        final isDarkMode = themeMode == ThemeMode.dark;

        return GestureDetector(
          onTap: () {
            AppUtils.vibrate();
            LynshaeApp.themeNotifier.value =
                isDarkMode ? ThemeMode.light : ThemeMode.dark;
            AppUtils.showInfo(
              context,
              isDarkMode ? '已切换为浅色模式' : '已切换为深色模式'
            );
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
                    color: isDarkMode
                        ? AppTheme.primaryBlue.withAlpha(30)
                        : AppTheme.warmBeige.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    color: isDarkMode ? AppTheme.primaryBlue : AppTheme.warmBrown,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '主题模式',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isDarkMode ? '深色模式' : '浅色模式',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white30 : AppTheme.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    AppUtils.vibrate();
                    LynshaeApp.themeNotifier.value =
                        value ? ThemeMode.dark : ThemeMode.light;
                  },
                  activeThumbColor: AppTheme.primaryBlue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showArrow = true,
    bool isDestructive = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                color: isDestructive
                    ? Colors.red.withAlpha(20)
                    : (isDark ? Colors.white.withAlpha(15) : AppTheme.warmBeige.withAlpha(20)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? Colors.red
                    : (isDark ? Colors.white : AppTheme.warmBrown),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive
                          ? Colors.red
                          : (isDark ? Colors.white : AppTheme.lightTextPrimary),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDestructive
                          ? Colors.red.withAlpha(180)
                          : (isDark ? Colors.white30 : AppTheme.lightTextSecondary),
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
                color: isDark ? Colors.white30 : AppTheme.lightTextMuted,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 68,
      endIndent: 16,
      color: isDark ? Colors.white.withAlpha(10) : AppTheme.warmBeige.withAlpha(20),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 0.5,
        ),
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
          _buildDivider(isDark),
          // 检查更新
          _buildSettingsItem(
            icon: Icons.system_update_outlined,
            title: '检查更新',
            subtitle: 'APP 版本、设备固件',
            onTap: () {
              AppUtils.vibrate();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckUpdateScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 0.5,
        ),
      ),
      child: _buildSettingsItem(
        icon: Icons.logout_rounded,
        title: '退出登录',
        subtitle: '退出当前账户',
        isDestructive: true,
        showArrow: false,
        onTap: _showLogoutDialog,
      ),
    );
  }

  void _showLogoutDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          '退出登录',
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
          ),
        ),
        content: Text(
          '确定要退出当前账户吗？',
          style: TextStyle(
            color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              '取消',
              style: TextStyle(
                color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _logout();
            },
            child: const Text(
              '退出',
              style: TextStyle(color: AppTheme.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    AppUtils.showSuccess(context, '已退出登录');
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _showClearCacheDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          '清除缓存',
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.lightTextPrimary,
          ),
        ),
        content: Text(
          '确定要清除 $cacheSize 缓存数据吗？',
          style: TextStyle(
            color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(
                color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
              ),
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
}
