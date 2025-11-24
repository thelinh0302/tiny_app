import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Custom curved bottom navigation bar with a centered circular action button,
/// inspired by the provided design image.
///
/// API is kept compatible with the previous implementation:
/// - [currentIndex] controls the selected tab
/// - [onTap] is called with the tapped index
///
/// Optionally, you can provide [onCenterTap] for the big center action button.
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onCenterTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 166, // increased height for taller bottom navigation
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Curved background bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _CurvedBackgroundBar(),
          ),

          // Navigation icons row
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 92,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _NavItem(
                            index: 0,
                            iconAsset: AppImages.navHome,
                            currentIndex: currentIndex,
                            onTap: onTap,
                          ),
                          _NavItem(
                            index: 1,
                            iconAsset: AppImages.navAnalytics,
                            currentIndex: currentIndex,
                            onTap: onTap,
                          ),
                          _NavItem(
                            index: 2,
                            iconAsset: AppImages.navTransactions,
                            currentIndex: currentIndex,
                            onTap: onTap,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 88),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _NavItem(
                            index: 3,
                            iconAsset: AppImages.navCategory,
                            currentIndex: currentIndex,
                            onTap: onTap,
                          ),
                          _NavItem(
                            index: 4,
                            iconAsset: AppImages.navProfile,
                            currentIndex: currentIndex,
                            onTap: onTap,
                          ),
                          _NavItem(
                            index: 5,
                            iconAsset: AppImages.navSetting,
                            currentIndex: currentIndex,
                            onTap: onTap,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Center circular action button
          Positioned(
            left: 0,
            right: 0,
            bottom: 42,
            child: Center(
              child: GestureDetector(
                onTap: onCenterTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    border: Border.all(color: AppColors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.28),
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 32,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final String iconAsset;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.iconAsset,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: isActive ? 1.1 : 0.95,
          child: AppImages.image(
            iconAsset,
            width: 28,
            height: 28,
            color: AppColors.white.withValues(alpha: isActive ? 1.0 : 0.7),
          ),
        ),
      ),
    );
  }
}

/// Painted teal bar with a smooth concave curve at the top center, so the
/// circular button appears to sit inside a "wave" like in the reference image.
class _CurvedBackgroundBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      clipper: _CurvedNavBarClipper(),
      color: AppColors.mainGreen,
      elevation: 6,
      shadowColor: Colors.black12,
      child: const SizedBox(height: 86, width: double.infinity),
    );
  }
}

class _CurvedNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;
    const double radius = 24.0; // top corner radius
    const double depth = 56.0; // valley depth

    final Path path = Path();

    // Start at bottom-left
    path.moveTo(0, h);
    // Left side up with rounded top-left corner
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    // Flat top before the valley
    final double leftFlat = w * 0.33;
    final double rightFlat = w * 0.67;
    path.lineTo(leftFlat, 0);

    // Smooth symmetric valley with eased sides and a round bottom
    final double cx = w * 0.50;
    final double half = (rightFlat - leftFlat) / 2;
    final double kStart = half * 0.50; // smooth entry near the flat top
    final double kBottom = half * 0.60; // round bottom arc
    path.cubicTo(leftFlat + kStart, 0, cx - kBottom, depth, cx, depth);
    path.cubicTo(cx + kBottom, depth, rightFlat - kStart, 0, rightFlat, 0);

    // Top-right corner and right side
    path.lineTo(w - radius, 0);
    path.quadraticBezierTo(w, 0, w, radius);

    // Down right side to bottom-right, then back to start
    path.lineTo(w, h);
    path.lineTo(0, h);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
