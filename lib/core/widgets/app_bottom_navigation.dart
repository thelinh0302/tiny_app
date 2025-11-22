import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';

import '../constants/app_images.dart';
import '../theme/app_colors.dart';

/// Reusable bottom navigation bar widget based on `CircleNavBar`
/// Keeps the same API (`currentIndex`, `onTap`) as the previous
/// `BottomNavigationBar` implementation.
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildIcon({
      required String asset,
      required Color color,
      required bool isActive,
    }) {
      // CircleNavBar tends to make the central circle feel large.
      // We counter this by scaling the icon down so it looks lighter.
      final double baseSize = isActive ? 40 : 35;
      final double scale = isActive ? 0.48 : 0.5;

      return Transform.scale(
        scale: scale,
        child: AppImages.image(
          asset,
          color: color,
          width: baseSize,
          height: baseSize,
        ),
      );
    }

    return CircleNavBar(
      activeIndex: currentIndex,
      onTap: onTap,
      activeIcons: [
        buildIcon(
          asset: AppImages.navHome,
          color: AppColors.white,
          isActive: true,
        ),
        buildIcon(
          asset: AppImages.navAnalytics,
          color: AppColors.white,
          isActive: true,
        ),
        buildIcon(
          asset: AppImages.navTransactions,
          color: AppColors.white,
          isActive: true,
        ),
        buildIcon(
          asset: AppImages.navCategory,
          color: AppColors.white,
          isActive: true,
        ),
        buildIcon(
          asset: AppImages.navSetting,
          color: AppColors.white,
          isActive: true,
        ),
        buildIcon(
          asset: AppImages.navProfile,
          color: AppColors.white,
          isActive: true,
        ),
      ],
      inactiveIcons: [
        buildIcon(
          asset: AppImages.navHome,
          color: AppColors.white,
          isActive: true,
        ),
        buildIcon(
          asset: AppImages.navAnalytics,
          color: AppColors.white,
          isActive: true,
        ),
        buildIcon(
          asset: AppImages.navTransactions,
          color: AppColors.white,
          isActive: true,
        ),
        buildIcon(
          asset: AppImages.navCategory,
          color: AppColors.white,
          isActive: true,
        ),
        buildIcon(
          asset: AppImages.navSetting,
          color: AppColors.white,
          isActive: true,
        ),
        buildIcon(
          asset: AppImages.navProfile,
          color: AppColors.white,
          isActive: true,
        ),
      ],
      circleColor: AppColors.mainGreen,
      color: AppColors.mainGreen,
      elevation: 6,
      height: 84,
      circleWidth: 62,
      shadowColor: Colors.black12,
      circleShadowColor: Colors.black26,
    );
  }
}
