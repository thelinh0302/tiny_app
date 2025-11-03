import 'package:flutter/material.dart';

/// Application color constants
/// Centralized color definitions for consistent theming
class AppColors {
  // Primary Colors
  static const Color mainGreen = Color(0xFF00B0B2);
  static const Color textPrimary = Color(0xFF00B0B2);

  // Secondary Colors
  static const Color textSecondary = Color(0xFFFFFFFF);
  static const Color lettersAndIcons = Color(0xFFFFFFFF);

  // Background Colors
  static const Color backgroundGreenWhite = Color(0xFFFFFFFF);

  // Button Colors
  static const Color borderButtonPrimary = Color(0xFF00B0B2);

  // Status Colors
  static const Color warningColor = Color(0xFFF87B1B);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF424242);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [mainGreen, Color(0xFF008B8D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Opacity variations
  static Color mainGreenWithOpacity(double opacity) =>
      mainGreen.withOpacity(opacity);

  static Color warningWithOpacity(double opacity) =>
      warningColor.withOpacity(opacity);
}
