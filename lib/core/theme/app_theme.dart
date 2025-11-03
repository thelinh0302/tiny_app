import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application theme configuration
/// Uses AppColors for consistent styling across the app
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Primary color scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.mainGreen,
        secondary: AppColors.mainGreen,
        surface: AppColors.white,
        error: AppColors.errorColor,
        onPrimary: AppColors.lettersAndIcons,
        onSecondary: AppColors.lettersAndIcons,
        onSurface: AppColors.black,
        onError: AppColors.white,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mainGreen,
        foregroundColor: AppColors.lettersAndIcons,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.lettersAndIcons),
        titleTextStyle: const TextStyle(
          color: AppColors.lettersAndIcons,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.black),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.grey),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.grey),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainGreen,
          foregroundColor: AppColors.lettersAndIcons,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.borderButtonPrimary,
          side: const BorderSide(
            color: AppColors.borderButtonPrimary,
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mainGreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.mainGreen,
        foregroundColor: AppColors.lettersAndIcons,
        elevation: 4,
      ),

      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.white,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.mainGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: AppColors.mainGreen),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.mainGreen,
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkGrey,
        contentTextStyle: const TextStyle(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.lightGrey,
        thickness: 1,
      ),
    );
  }
}
