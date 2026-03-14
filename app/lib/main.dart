import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const LynshaeApp());
}

class LynshaeApp extends StatefulWidget {
  const LynshaeApp({super.key});

  /// 全局主题模式通知器，可从任意位置切换主题
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);

  @override
  State<LynshaeApp> createState() => _LynshaeAppState();
}

class _LynshaeAppState extends State<LynshaeApp> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    LynshaeApp.themeNotifier.addListener(_onThemeChanged);
    _checkLoginStatus();
  }

  @override
  void dispose() {
    LynshaeApp.themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    // 模拟加载时间
    await Future.delayed(const Duration(milliseconds: 500));
    final isLoggedIn = await AuthService.isLoggedIn();
    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
    }
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LyShae',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: LynshaeApp.themeNotifier.value,
      home: _isLoading
          ? _buildSplashScreen()
          : (_isLoggedIn ? const MainScreen() : const LoginScreen()),
      routes: {
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }

  Widget _buildSplashScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.darkBackgroundGradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF3B7CFF),
                    Color(0xFF2A5FCC),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x503B7CFF),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: const Icon(
                Icons.pets_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'LyShae',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
