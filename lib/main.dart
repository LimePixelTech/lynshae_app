import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SmartDogApp());
}

class SmartDogApp extends StatefulWidget {
  const SmartDogApp({super.key});

  /// 全局主题模式通知器，可从任意位置切换主题
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);

  @override
  State<SmartDogApp> createState() => _SmartDogAppState();
}

class _SmartDogAppState extends State<SmartDogApp> {
  @override
  void initState() {
    super.initState();
    SmartDogApp.themeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    SmartDogApp.themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智能机器狗',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: SmartDogApp.themeNotifier.value,
      home: const MainScreen(),
    );
  }
}
