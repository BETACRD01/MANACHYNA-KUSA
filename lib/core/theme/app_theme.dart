import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF101820),
    );

    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.green,
      primaryColor: AppColors.primary,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAF8),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF101820),
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF101820),
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF101820)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF66717C)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF101820),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardColor: Colors.white,
      canvasColor: Colors.white,
      dividerColor: const Color(0xFFE3E9E5),
      shadowColor: const Color(0x18000000),
      iconTheme: const IconThemeData(color: Color(0xFF101820)),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withValues(alpha: 0.13),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : const Color(0xFF29313A),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE1E5E8)),
        ),
      ),
    );
  }

  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF7AD083),
      onPrimary: Color(0xFF06240C),
      secondary: Color(0xFF83B9FF),
      onSecondary: Color(0xFF071827),
      error: Color(0xFFFF8A80),
      onError: Color(0xFF2B0505),
      surface: Color(0xFF171B18),
      onSurface: Color(0xFFEAF2EA),
    );

    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.green,
      primaryColor: colorScheme.primary,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0E120F),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFEAF2EA),
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFEAF2EA),
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFEAF2EA)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFAEB9AF)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF171B18),
        foregroundColor: Color(0xFFEAF2EA),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardColor: const Color(0xFF171B18),
      canvasColor: const Color(0xFF171B18),
      dividerColor: const Color(0xFF2B332D),
      shadowColor: Colors.black,
      iconTheme: const IconThemeData(color: Color(0xFFEAF2EA)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF171B18),
        selectedItemColor: Color(0xFF7AD083),
        unselectedItemColor: Color(0xFFAEB9AF),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF171B18),
        indicatorColor: colorScheme.primary.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? colorScheme.primary
                : const Color(0xFFAEB9AF),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF171B18),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF111612),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2B332D)),
        ),
      ),
    );
  }
}
