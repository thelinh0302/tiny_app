import 'package:flutter/material.dart';

/// Application size constants
/// Centralized size values for consistent UI
class AppSizes {
  // Icon sizes
  static const double iconTiny = 16.0;
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  static const double iconXXLarge = 64.0;

  // Font sizes
  static const double fontTiny = 10.0;
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontLarge = 16.0;
  static const double fontXLarge = 20.0;
  static const double fontXXLarge = 24.0;
  static const double fontXXXLarge = 32.0;

  // Button heights
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  // Button minimum widths
  static const double buttonMinWidth = 120.0;
  static const double buttonMinWidthSmall = 80.0;

  // AppBar height
  static const double appBarHeight = 56.0;

  // Bottom navigation bar height
  static const double bottomNavBarHeight = 60.0;

  // Card dimensions
  static const double cardElevation = 2.0;
  static const double cardMinHeight = 100.0;

  // Avatar sizes
  static const double avatarSmall = 32.0;
  static const double avatarMedium = 48.0;
  static const double avatarLarge = 64.0;
  static const double avatarXLarge = 96.0;

  // Image sizes
  static const double imageSmall = 80.0;
  static const double imageMedium = 120.0;
  static const double imageLarge = 200.0;
  static const double imageXLarge = 300.0;

  // Loading indicator sizes
  static const double loadingSmall = 20.0;
  static const double loadingMedium = 40.0;
  static const double loadingLarge = 60.0;

  // Divider height
  static const double dividerHeight = 1.0;

  // Input field dimensions
  static const double inputHeightSmall = 40.0;
  static const double inputHeightMedium = 48.0;
  static const double inputHeightLarge = 56.0;

  // Dialog sizes
  static const double dialogMaxWidth = 400.0;
  static const double dialogMaxHeight = 600.0;

  // Bottom sheet sizes
  static const double bottomSheetMaxHeight = 0.9; // 90% of screen height

  // Screen breakpoints
  static const double screenSmall = 600.0;
  static const double screenMedium = 900.0;
  static const double screenLarge = 1200.0;

  // List tile height
  static const double listTileHeight = 72.0;
  static const double listTileHeightSmall = 56.0;

  // Chip dimensions
  static const double chipHeight = 32.0;

  // Badge dimensions
  static const double badgeSize = 20.0;
  static const double badgeSizeSmall = 16.0;

  // Border width
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;

  // Size helpers
  static Size get buttonSizeSmall =>
      const Size(double.infinity, buttonHeightSmall);
  static Size get buttonSizeMedium =>
      const Size(double.infinity, buttonHeightMedium);
  static Size get buttonSizeLarge =>
      const Size(double.infinity, buttonHeightLarge);

  // Responsive breakpoint checker
  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < screenSmall;

  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= screenSmall &&
      MediaQuery.of(context).size.width < screenMedium;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= screenMedium;

  // Get responsive value based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isLargeScreen(context) && desktop != null) {
      return desktop;
    }
    if (isMediumScreen(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }
}
