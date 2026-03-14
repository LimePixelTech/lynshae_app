import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../../common/components/app_navbar.dart';
import '../../common/components/settings_tile.dart';

/// 用户信息查看和编辑界面
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // 用户信息
  String _nickname = 'Freakz3z';
  final String _avatarUrl = '';

  // 编辑状态
  bool _isEditing = false;
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: _nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
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
            AppNavbar(
              title: '个人信息',
              showNotification: false,
              trailing: GestureDetector(
                onTap: _toggleEditMode,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.primaryBlue.withAlpha(30) : AppTheme.warmBeige.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _isEditing ? '完成' : '编辑',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
                    ),
                  ),
                ),
              ),
            ),
            // 用户信息内容
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildUserProfile(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 头像
          GestureDetector(
            onTap: _isEditing ? _changeAvatar : null,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.primaryBlue.withAlpha(30) : AppTheme.warmBeige.withAlpha(30),
                borderRadius: BorderRadius.circular(60),
              ),
              child: _avatarUrl.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        _avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person_rounded,
                          color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
                          size: 60,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.person_rounded,
                      color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown,
                      size: 60,
                    ),
            ),
          ),
          if (_isEditing) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _changeAvatar,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withAlpha(15) : AppTheme.warmBeige.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '更换头像',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          // 信息卡片
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.edit_rounded,
                title: '昵称',
                trailing: Text(
                  _nickname,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                  ),
                ),
                onTap: _isEditing ? _editNickname : null,
                showArrow: _isEditing,
              ),
              SettingsTile(
                icon: Icons.phone_outlined,
                title: '手机号',
                trailing: Text(
                  '138****8888',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                  ),
                ),
                showArrow: false,
              ),
              SettingsTile(
                icon: Icons.calendar_today_outlined,
                title: '注册时间',
                trailing: Text(
                  '2024-01-01',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                  ),
                ),
                showArrow: false,
                showDivider: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleEditMode() {
    AppUtils.vibrate();
    if (_isEditing) {
      // 保存修改
      setState(() {
        _nickname = _nicknameController.text;
      });
      AppUtils.showSuccess(context, '保存成功');
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _editNickname() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    AppUtils.vibrate();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          '修改昵称',
          style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary),
        ),
        content: TextField(
          controller: _nicknameController,
          style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary),
          decoration: InputDecoration(
            hintText: '请输入昵称',
            hintStyle: TextStyle(color: isDark ? Colors.white30 : AppTheme.lightTextMuted),
            filled: true,
            fillColor: isDark ? Colors.white.withAlpha(15) : AppTheme.warmBeige.withAlpha(30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(color: isDark ? Colors.white54 : AppTheme.lightTextSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _nickname = _nicknameController.text;
              });
              AppUtils.showSuccess(context, '昵称已修改');
            },
            child: Text(
              '确定',
              style: TextStyle(color: isDark ? AppTheme.primaryBlue : AppTheme.warmBrown),
            ),
          ),
        ],
      ),
    );
  }

  void _changeAvatar() {
    AppUtils.vibrate();
    AppUtils.showInfo(context, '头像更换功能开发中');
  }
}
