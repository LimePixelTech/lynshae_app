import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_utils.dart';
import '../../common/components/app_navbar.dart';
import '../../common/components/settings_tile.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

/// 用户信息查看和编辑界面 - 使用真实 API 数据
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // 用户信息
  UserModel? _user;
  bool _isLoading = true;

  // 编辑状态
  bool _isEditing = false;
  late TextEditingController _nicknameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await AuthService.getCurrentUser();
      if (user != null && mounted) {
        setState(() {
          _user = user;
          _nicknameController.text = user.nickname ?? user.username;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败：${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightBgTop,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
          ),
        ),
      );
    }

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
              child: RefreshIndicator(
                onRefresh: _loadUserInfo,
                color: AppTheme.primaryBlue,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = _user;
    final avatarUrl = user?.avatar;
    
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
              child: avatarUrl != null && avatarUrl.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        avatarUrl,
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
                  user?.nickname ?? user?.username ?? '未设置',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                  ),
                ),
                onTap: _isEditing ? _editNickname : null,
                showArrow: _isEditing,
              ),
              SettingsTile(
                icon: Icons.email_outlined,
                title: '邮箱',
                trailing: Text(
                  user?.email ?? '未设置',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                  ),
                ),
                showArrow: false,
              ),
              SettingsTile(
                icon: Icons.phone_outlined,
                title: '手机号',
                trailing: Text(
                  _formatPhone(user?.phone),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : AppTheme.lightTextSecondary,
                  ),
                ),
                onTap: _isEditing ? _editPhone : null,
                showArrow: _isEditing,
              ),
              SettingsTile(
                icon: Icons.calendar_today_outlined,
                title: '注册时间',
                trailing: Text(
                  _formatDate(user?.createdAt),
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

  String _formatPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '未绑定';
    // 隐藏中间 4 位
    if (phone.length >= 7) {
      return '${phone.substring(0, 3)}****${phone.substring(phone.length - 4)}';
    }
    return '****';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '未知';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _toggleEditMode() {
    AppUtils.vibrate();
    if (_isEditing) {
      // 保存修改
      _saveUserInfo();
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveUserInfo() async {
    try {
      // TODO: 调用后端 API 更新用户信息
      // await UserService.updateProfile({
      //   'nickname': _nicknameController.text,
      //   'phone': _phoneController.text,
      // });
      
      // 更新本地用户信息
      if (_user != null) {
        final updatedUser = _user!.copyWith(
          nickname: _nicknameController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        );
        await AuthService.updateUser(updatedUser);
        
        if (mounted) {
          setState(() {
            _user = updatedUser;
          });
          AppUtils.showSuccess(context, '保存成功');
        }
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showError(context, '保存失败：${e.toString()}');
      }
    }
  }

  void _editNickname() {
    if (!mounted) return;
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
          maxLength: 20,
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
                // 昵称会在保存时更新
              });
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

  void _editPhone() {
    if (!mounted) return;
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
          '修改手机号',
          style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary),
        ),
        content: TextField(
          controller: _phoneController,
          style: TextStyle(color: isDark ? Colors.white : AppTheme.lightTextPrimary),
          decoration: InputDecoration(
            hintText: '请输入手机号',
            hintStyle: TextStyle(color: isDark ? Colors.white30 : AppTheme.lightTextMuted),
            filled: true,
            fillColor: isDark ? Colors.white.withAlpha(15) : AppTheme.warmBeige.withAlpha(30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixText: '+86 ',
          ),
          autofocus: true,
          maxLength: 11,
          keyboardType: TextInputType.phone,
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
                // 手机号会在保存时更新
              });
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
