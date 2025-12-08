import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Skeleton grid shown while categories are loading from API.
class CategoriesGridSkeleton extends StatelessWidget {
  final int itemCount;

  const CategoriesGridSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    // Compute a deterministic height so the grid has visible space
    const crossAxisCount = 3;
    const childAspectRatio = 1.05;
    final screenWidth = MediaQuery.of(context).size.width;
    // Account roughly for the page horizontal padding
    final contentWidth = screenWidth - (AppSpacing.horizontalMedium * 2);
    final tileWidth =
        (contentWidth - (AppSpacing.horizontalMedium * (crossAxisCount - 1))) /
        crossAxisCount;
    final tileHeight = tileWidth / childAspectRatio;
    final rows = (itemCount / crossAxisCount).ceil();
    final height =
        (rows * tileHeight) + ((rows - 1) * AppSpacing.verticalMedium);

    return SizedBox(
      height: height,
      child: Skeletonizer(
        effect: ShimmerEffect(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          duration: const Duration(milliseconds: 1100),
        ),
        enabled: true,
        child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.verticalMedium,
            crossAxisSpacing: AppSpacing.horizontalMedium,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.mainGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(AppSpacing.horizontalSmall),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.mainGreen.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
