import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.honeyGold,
      brightness: Brightness.light,
      primary: AppColors.honeyGold,
      onPrimary: AppColors.onHoneyPrimary,
      secondary: AppColors.honeyAmber,
      onSecondary: AppColors.onHoneyPrimary,
      surface: Colors.white,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.warmCream,
      appBarBackground: AppColors.warmCream,
      cardColor: Colors.white,
      textPrimary: AppColors.textPrimary,
      textSecondary: AppColors.textSecondary,
    );
  }

  static ThemeData dark() {
    const scaffold = Color(0xFF1A1410);
    const card = Color(0xFF2A221C);
    const textPrimary = Color(0xFFF5E6D3);
    const textSecondary = Color(0xFFB8A894);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.honeyGold,
      brightness: Brightness.dark,
      primary: AppColors.honeyGold,
      onPrimary: AppColors.onHoneyPrimary,
      secondary: AppColors.honeyAmber,
      onSecondary: AppColors.onHoneyPrimary,
      surface: card,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: scaffold,
      appBarBackground: scaffold,
      cardColor: card,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required Color appBarBackground,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackground,
        foregroundColor: textPrimary,
        centerTitle: false,
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
        labelLarge: TextStyle(fontSize: 14, color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: colorScheme.brightness == Brightness.dark
                ? const Color(0xFF3D3228)
                : AppColors.hexBorder,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.honeyGold,
        foregroundColor: AppColors.textPrimary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 100,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: selected ? 34 : 32,
            color: selected ? textPrimary : textSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? textPrimary : textSecondary,
          );
        }),
      ),
    );
  }
}
