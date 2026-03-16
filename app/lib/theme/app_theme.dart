import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 双主题系统配置
/// - 深色模式：科技蓝青风格（当前默认）
/// - 浅色模式：温馨米色风格
class AppTheme {
  // === 深色模式品牌色（科技蓝） ===
  static const Color primaryBlue = Color(0xFF3B7CFF);
  static const Color primaryBlueDark = Color(0xFF2A5FCC);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentPink = Color(0xFFFF4081);
  static const Color accentCyan = Color(0xFF00C6FF);
  static const Color accentTeal = Color(0xFF00D4AA);
  static const Color successGreen = Color(0xFF34D399);
  static const Color warningYellow = Color(0xFFFBBF24);
  static const Color errorRed = Color(0xFFEF4444);

  // === 浅色模式品牌色（温馨米色） ===
  static const Color warmBeige = Color(0xFFD4C4B0);
  static const Color warmBeigeLight = Color(0xFFE8DCD0);
  static const Color warmBeigeDark = Color(0xFFC4B4A0);
  static const Color warmCream = Color(0xFFF5F0EB);
  static const Color warmCreamDark = Color(0xFFEBE5DF);
  static const Color warmSand = Color(0xFFE0D5C9);
  static const Color warmTaupe = Color(0xFFB8A898);
  static const Color warmBrown = Color(0xFF8B7355);
  static const Color warmCoral = Color(0xFFE8A598);
  static const Color warmSage = Color(0xFFA8C4A0);
  static const Color warmGold = Color(0xFFD4B896);

  // === 深色模式背景色 ===
  static const Color darkBgTop = Color(0xFF0F172A);
  static const Color darkBgMiddle = Color(0xFF1E293B);
  static const Color darkBgBottom = Color(0xFF334155);

  // === 浅色模式背景色（米色渐变） ===
  static const Color lightBgTop = Color(0xFFFFFBF7);
  static const Color lightBgMiddle = Color(0xFFFDF8F3);
  static const Color lightBgBottom = Color(0xFFFAF3ED);

  // === 深色模式卡片色 ===
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkCardElevated = Color(0xFF334155);
  static const Color darkCardHighlight = Color(0xFF475569);
  static const Color darkBorder = Color(0xFF475569);
  // 别名（向后兼容）
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkElevated = Color(0xFF334155);

  // === 浅色模式卡片色（米色系） ===
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardWarm = Color(0xFFFFFBF7);
  static const Color lightCardBeige = Color(0xFFFDF8F3);
  static const Color lightBorder = Color(0xFFE8DCD0);

  // === 文字色 ===
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color lightTextPrimary = Color(0xFF4A3F35);
  static const Color lightTextSecondary = Color(0xFF8B7D70);
  static const Color lightTextMuted = Color(0xFFA89F95);

  // === 灰度色阶（深色模式） ===
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // === 米色色阶（浅色模式） ===
  static const Color beige50 = Color(0xFFFFFBF7);
  static const Color beige100 = Color(0xFFFDF8F3);
  static const Color beige200 = Color(0xFFFAF3ED);
  static const Color beige300 = Color(0xFFF5EBE0);
  static const Color beige400 = Color(0xFFE8DCD0);
  static const Color beige500 = Color(0xFFD4C4B0);
  static const Color beige600 = Color(0xFFC4B4A0);
  static const Color beige700 = Color(0xFFB8A898);
  static const Color beige800 = Color(0xFF9C8C7E);
  static const Color beige900 = Color(0xFF7A6B5D);

  // === 玻璃质感配色 ===
  static const Color glassLight = Color(0x60FFFFFF);
  static const Color glassLightBorder = Color(0x80FFFFFF);
  static const Color glassDark = Color(0x15FFFFFF);
  static const Color glassDarkBorder = Color(0x20FFFFFF);
  
  // === 米色玻璃质感（浅色模式） ===
  static const Color glassWarmLight = Color(0x80FFFBF7);
  static const Color glassWarmLightBorder = Color(0x60E8DCD0);
  static const Color glassWarmDark = Color(0x40FDF8F3);
  static const Color glassWarmDarkBorder = Color(0x60E8DCD0);

  // === 深色模式渐变 ===
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      darkBgTop,
      darkBgMiddle,
      darkBgBottom,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // === 浅色模式渐变（温馨米色） ===
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      lightBgTop,
      lightBgMiddle,
      lightBgBottom,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueDark],
  );

  // 米色温暖渐变
  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warmBeige, warmGold],
  );

  /// 根据主题返回背景渐变
  static LinearGradient backgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkBackgroundGradient : lightBackgroundGradient;
  }

  // === 浅色主题（温馨米色风格） ===
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: warmBeige,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.light(
        primary: warmBeige,
        secondary: warmCoral,
        tertiary: warmGold,
        surface: lightCard,
        surfaceContainer: lightCardWarm,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        outline: beige400,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: lightTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: lightCard,
        shadowColor: warmBrown.withAlpha(10),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: warmBeige,
        unselectedItemColor: beige400,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: warmBeige,
        thumbColor: warmBeige,
        overlayColor: Color(0x20D4C4B0),
        inactiveTrackColor: beige300,
        trackHeight: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: warmBeige,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: warmBeige),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightTextPrimary,
          side: const BorderSide(color: beige300),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: beige100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: warmBeige, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: lightTextMuted, fontSize: 15),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: const TextStyle(color: darkTextPrimary, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: beige300,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return successGreen;
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return successGreen.withAlpha(50);
          return beige300;
        }),
      ),
    );
  }

  // === 深色主题（科技蓝风格） ===
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: accentTeal,
        tertiary: accentCyan,
        surface: darkCard,
        surfaceContainer: darkCardElevated,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
        outline: darkBorder,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: darkTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: darkCard,
        shadowColor: Colors.black.withAlpha(40),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: primaryBlue,
        unselectedItemColor: gray400,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primaryBlue,
        thumbColor: primaryBlue,
        overlayColor: Color(0x203B7CFF),
        inactiveTrackColor: darkCardElevated,
        trackHeight: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryBlue),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkTextPrimary,
          side: const BorderSide(color: darkBorder),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: darkTextSecondary, fontSize: 15),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCardElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: const TextStyle(color: darkTextPrimary, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return successGreen;
          return darkTextSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return successGreen.withAlpha(50);
          return darkCardElevated;
        }),
      ),
    );
  }
}
