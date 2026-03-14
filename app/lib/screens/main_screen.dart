import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'smart_screen.dart';
import 'mall_screen.dart';
import 'profile_screen.dart';

/// 主屏幕 - 玻璃质感底部导航
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SmartScreen(),
    const MallScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient(context),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            // 底部导航栏
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: _buildGlassNavBarContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassNavBarContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: isDark 
                ? const Color(0xCC1E293B) 
                : const Color(0xCCFFF8F3),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark 
                  ? const Color(0xFF334155) 
                  : AppTheme.lightBorder,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.black.withAlpha(80) 
                    : AppTheme.warmBrown.withAlpha(20),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                  0, Icons.home_outlined, Icons.home_rounded, '首页'),
              _buildNavItem(
                  1, Icons.auto_awesome_outlined, Icons.auto_awesome_rounded, '智能'),
              _buildNavItem(
                  2, Icons.shopping_bag_outlined, Icons.shopping_bag_rounded, '商城'),
              _buildNavItem(
                  3, Icons.person_outline, Icons.person_rounded, '我的'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected
        ? (isDark ? AppTheme.primaryBlue : AppTheme.warmBeige)
        : (isDark ? AppTheme.gray400 : AppTheme.gray600);

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark 
                        ? AppTheme.primaryBlue.withAlpha(40) 
                        : AppTheme.warmBeige.withAlpha(30))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
