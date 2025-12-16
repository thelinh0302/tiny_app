import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Centralized image asset definitions and helper to render PNG/SVG uniformly.
class AppImages {
  // Base path
  static const String _base = 'assets/images';

  // Onboarding
  static const String onboarding1 = '$_base/onboarding1.png';
  static const String onboarding2 = '$_base/onboarding2.png';
  static const String primaryLogo = '$_base/finlyLogoPrimary.png';

  // Auth
  static const String faceId = '$_base/faceId.png';
  static const String google = '$_base/google.png';
  static const String facebook = '$_base/facebook.png';

  // Bottom navigation icons (SVG)
  static const String navHome = '$_base/home_icon.svg';
  static const String navTransactions = '$_base/vector_icon.svg';
  static const String navCategory = '$_base/category_icon.svg';
  static const String navAnalytics = '$_base/analysis_icon.svg';
  static const String navSetting = '$_base/setting_icon.svg';
  static const String navProfile = '$_base/profile_icon.svg';

  // Dashboard icons
  static const String income = '$_base/income.svg';
  static const String expense = '$_base/expense.svg';

  // Savings card icons
  static const String savingsCar = '$_base/car_icon.svg';
  static const String salary = '$_base/salary_icon.svg';
  static const String food = '$_base/food_icon.svg';

  // UI icons
  static const String notification = '$_base/noti_icon.svg';
  static const String filter = '$_base/filter_icon.svg';

  // Illustrations
  static const String noResult = '$_base/no_result.svg';

  // Example placeholders (add your PNGs/SVGs here)
  // static const String logoPng = '$_base/logo.png';
  // static const String iconSvg = '$_base/icon.svg';

  /// Renders an asset image. Automatically chooses SvgPicture for .svg and
  /// Image.asset for other formats (e.g., .png, .jpg).
  static Widget image(
    String asset, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    String? semanticsLabel,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final lower = asset.toLowerCase();
    if (lower.endsWith('.svg')) {
      return SvgPicture.asset(
        asset,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        alignment: alignment,
        semanticsLabel: semanticsLabel,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
    }
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      semanticLabel: semanticsLabel,
      color: color,
    );
  }
}
