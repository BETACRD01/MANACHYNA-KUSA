import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

extension AppThemeColors on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get appBackground => Theme.of(this).scaffoldBackgroundColor;

  Color get appSurface => Theme.of(this).cardColor;

  Color get appElevatedSurface =>
      isDarkMode ? const Color(0xFF1D241F) : Colors.white;

  Color get appMutedSurface =>
      isDarkMode ? const Color(0xFF111612) : const Color(0xFFF7FAF7);

  Color get appTextPrimary => Theme.of(this).colorScheme.onSurface;

  Color get appTextSecondary =>
      isDarkMode ? const Color(0xFFAEB9AF) : AppColors.textSecondary;

  Color get appBorder =>
      isDarkMode ? const Color(0xFF2B332D) : const Color(0xFFE9EEF2);

  Color get appSoftGreen =>
      isDarkMode ? const Color(0xFF1B3020) : const Color(0xFFEAF6EB);

  Color get appShadow => isDarkMode
      ? Colors.black.withValues(alpha: 0.34)
      : const Color(0x14000000);

  Color get appPrimary =>
      isDarkMode ? Theme.of(this).colorScheme.primary : AppColors.primary;

  List<BoxShadow> get appCardShadow {
    return [
      BoxShadow(
        color: appShadow,
        blurRadius: isDarkMode ? 8 : 20,
        offset: Offset(0, isDarkMode ? 3 : 8),
      ),
    ];
  }
}
