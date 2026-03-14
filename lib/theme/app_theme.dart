import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 米家风格主题配置
/// 主背景：蓝青渐变
/// 卡片：圆角大卡片，深浅搭配
/// 强调色：绿色开关、蓝色选中
class AppTheme {
  // === 品牌色 ===
  static const Color primaryBlue = Color(0xFF3B7CFF);
  static const Color primaryBlueDark = Color(0xFF2A5FCC);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentPink = Color(0xFFFF4081);
  static const Color accentCyan = Color(0xFF00C6FF);
  static const Color accentTeal = Color(0xFF00D4AA);
  static const Color successGreen = Color(0xFF34D399);
  static const Color warningYellow = Color(0xFFFBBF24);
  static const Color errorRed = Color(0xFFEF4444);

  // === 米家风格背景色 ===
  static const Color miBgTop = Color(0xFF1A3A5C);
  static const Color miBgMiddle = Color(0xFF2D5A7C);
  static const Color miBgBottom = Color(0xFF4A7C9B);
  static const Color miBgLight = Color(0xFFE8F4F8);

  // === 卡片色（深色模式） ===
  static const Color cardDark = Color(0xFF1E3A4D);
  static const Color cardDarkElevated = Color(0xFF2A4A5E);
  static const Color cardDarkHighlight = Color(0xFF3A5A6E);

  // === 卡片色（浅色模式） ===
  static const Color cardLight = Colors.white;
  static const Color cardLightGray = Color(0xFFF5F7FA);
  static const Color cardLightBlue = Color(0xFFE8F4FC);

  // === 文字色 ===
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF9FB3C8);
  static const Color textPrimaryLight = Color(0xFF1F2937);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  // === 灰度色阶 ===
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

  // === 深色模式专属色 ===
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkElevated = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF475569);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // === 玻璃质感配色 ===
  static const Color glassLight = Color(0x40FFFFFF);
  static const Color glassLightBorder = Color(0x60FFFFFF);
  static const Color glassDark = Color(0x15FFFFFF);
  static const Color glassDarkBorder = Color(0x20FFFFFF);

  // === 灰度色阶别名（已废弃，请使用原始名称） ===
  @Deprecated('使用 gray50 代替')
  static const Color warmGray50 = gray50;
  @Deprecated('使用 gray100 代替')
  static const Color warmGray100 = gray100;
  @Deprecated('使用 gray200 代替')
  static const Color warmGray200 = gray200;
  @Deprecated('使用 gray300 代替')
  static const Color warmGray300 = gray300;
  @Deprecated('使用 gray400 代替')
  static const Color warmGray400 = gray400;
  @Deprecated('使用 gray500 代替')
  static const Color warmGray500 = gray500;
  @Deprecated('使用 gray600 代替')
  static const Color warmGray600 = gray600;
  @Deprecated('使用 gray700 代替')
  static const Color warmGray700 = gray700;
  @Deprecated('使用 gray800 代替')
  static const Color warmGray800 = gray800;
  @Deprecated('使用 gray900 代替')
  static const Color warmGray900 = gray900;

  // === 暖色调品牌色别名（已废弃，请使用原始名称） ===
  @Deprecated('使用 primaryBlue 代替')
  static const Color primaryWarmBeige = primaryBlue;
  @Deprecated('使用 primaryBlueDark 代替')
  static const Color primarySoftBrown = primaryBlueDark;
  @Deprecated('使用 accentOrange 代替')
  static const Color accentCoral = accentOrange;
  @Deprecated('使用 accentCyan 代替')
  static const Color accentWarmGold = accentCyan;
  @Deprecated('使用 accentPink 代替')
  static const Color accentSoftPeach = accentPink;
  @Deprecated('使用 successGreen 代替')
  static const Color successSage = successGreen;
  @Deprecated('使用 warningYellow 代替')
  static const Color warningAmber = warningYellow;
  @Deprecated('使用 errorRed 代替')
  static const Color errorSoftRed = errorRed;
  @Deprecated('使用 glassDark 代替')
  static const Color glassWarmDark = glassDark;
  @Deprecated('使用 glassLight 代替')
  static const Color glassWarmLight = glassLight;
  @Deprecated('使用 glassDarkBorder 代替')
  static const Color glassWarmDarkBorder = glassDarkBorder;
  @Deprecated('使用 glassLightBorder 代替')
  static const Color glassWarmLightBorder = glassLightBorder;

  // === 米家风格渐变 ===
  static const LinearGradient miBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      miBgTop,
      miBgMiddle,
      miBgBottom,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueDark],
  );

  // 浅色背景渐变
  static const LinearGradient lightBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8F4F8),
      Color(0xFFF0F7FA),
      Color(0xFFF5F9FB),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static LinearGradient backgroundGradient(BuildContext context) {
    return miBackgroundGradient;
  }

  // === 浅色主题 ===
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: accentTeal,
        tertiary: accentCyan,
        surface: cardLight,
        surfaceContainer: cardLightGray,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryLight,
        outline: gray200,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimaryLight,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: cardLight,
        shadowColor: gray900.withAlpha(10),
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
        inactiveTrackColor: gray200,
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
          foregroundColor: gray700,
          side: const BorderSide(color: gray200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: gray100,
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
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: gray400, fontSize: 15),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: gray800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: gray200,
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
          return gray200;
        }),
      ),
    );
  }

  // === 深色主题（米家风格） ===
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
        surface: cardDark,
        surfaceContainer: cardDarkElevated,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryDark,
        outline: Color(0xFF3A5A7C),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimaryDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: cardDark,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Color(0xFF7A9BB8),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primaryBlue,
        thumbColor: primaryBlue,
        overlayColor: Color(0x203B7CFF),
        inactiveTrackColor: Color(0xFF3A5A7C),
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
          foregroundColor: textPrimaryDark,
          side: const BorderSide(color: Color(0xFF3A5A7C)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDarkElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3A5A7C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3A5A7C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: textSecondaryDark, fontSize: 15),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardDarkElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: const TextStyle(color: textPrimaryDark, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A5A7C),
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return successGreen;
          return textSecondaryDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return successGreen.withAlpha(50);
          return cardDarkElevated;
        }),
      ),
    );
  }
}
