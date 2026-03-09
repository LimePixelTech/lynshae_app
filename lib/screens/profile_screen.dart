import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = true;
  bool notificationsEnabled = true;
  bool autoUpdate = true;

  @override
  void initState() {
    super.initState();
    isDarkMode = SmartDogApp.themeNotifier.value == ThemeMode.dark;
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
      SmartDogApp.themeNotifier.value =
          isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
    AppUtils.vibrate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTextDisplayMedium('我的'),
              const SizedBox(height: 24),
              _buildUserCard(),
              const SizedBox(height: 24),
              AppGroupedList(
                title: '设置',
                children: [
                  AppSwitchTile(
                    icon: Icons.dark_mode_rounded,
                    title: '深色模式',
                    value: isDarkMode,
                    onChanged: (value) => _toggleTheme(),
                  ),
                  AppSwitchTile(
                    icon: Icons.notifications_rounded,
                    title: '消息通知',
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() => notificationsEnabled = value);
                      AppUtils.vibrate();
                    },
                  ),
                  AppSwitchTile(
                    icon: Icons.update_rounded,
                    title: '自动更新',
                    value: autoUpdate,
                    onChanged: (value) {
                      setState(() => autoUpdate = value);
                      AppUtils.vibrate();
                    },
                  ),
                  AppSettingTile(
                    icon: Icons.language_rounded,
                    title: '语言',
                    subtitle: '简体中文',
                    onTap: () => Toast.info(context, '语言设置开发中'),
                  ),
                  AppSettingTile(
                    icon: Icons.security_rounded,
                    title: '账号与安全',
                    onTap: () => Toast.info(context, '账号安全开发中'),
                  ),
                ],
              ),
              AppGroupedList(
                title: '关于',
                children: [
                  AppSettingTile(
                    icon: Icons.help_outline_rounded,
                    title: '帮助与反馈',
                    onTap: () => Toast.info(context, '帮助中心开发中'),
                  ),
                  AppSettingTile(
                    icon: Icons.description_outlined,
                    title: '用户协议',
                    onTap: () => Toast.info(context, '用户协议开发中'),
                  ),
                  AppSettingTile(
                    icon: Icons.privacy_tip_outlined,
                    title: '隐私政策',
                    onTap: () => Toast.info(context, '隐私政策开发中'),
                  ),
                  AppListTile(
                    leadingIcon: Icons.info_outline_rounded,
                    leadingIconColor: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.gray500,
                    title: '版本',
                    trailing: AppTextCaption('v1.0.0'),
                    showArrow: false,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Toast.info(context, '退出登录'),
                child: GlassContainer(
                  borderColor: AppTheme.errorRed.withAlpha(80),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout_rounded,
                      color: AppTheme.errorRed,
                    ),
                    title: AppTextTitle(
                      '退出登录',
                      color: AppTheme.errorRed,
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.errorRed.withAlpha(120),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                  ),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withAlpha(80),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextTitle(
                      'Freakz3z',
                      color: isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.gray800,
                    ),
                    const SizedBox(height: 4),
                    AppTextBodySmall(
                      '高级会员',
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(height: 4),
                    AppTextOverline(
                      'ID: 3020517046',
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.gray500,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit_outlined,
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.gray500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('设备', '4'),
              _buildStatItem('场景', '4'),
              _buildStatItem('自动化', '2'),
              _buildStatItem('消息', '12'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        AppTextTitleMedium(
          value,
          color: isDark
              ? AppTheme.darkTextPrimary
              : AppTheme.gray800,
        ),
        const SizedBox(height: 4),
        AppTextOverline(
          label,
          color: isDark
              ? AppTheme.darkTextSecondary
              : AppTheme.gray500,
        ),
      ],
    );
  }
}
