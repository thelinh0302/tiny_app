import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/constants/app_sizes.dart';
import 'package:finly_app/core/theme/app_colors.dart';

class CategoryTransactionsListSkeleton extends StatelessWidget {
  final int itemCount;

  const CategoryTransactionsListSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        duration: const Duration(milliseconds: 1100),
      ),
      enabled: true,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) => _row(context),
      ),
    );
  }

  Widget _row(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: AppSizes.avatarLarge,
            width: AppSizes.avatarLarge,
            decoration: BoxDecoration(
              color: AppColors.mainGreen.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
          AppSpacing.horizontalSpaceMedium,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.mainGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 160,
                  decoration: BoxDecoration(
                    color: AppColors.mainGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 16,
            width: 80,
            decoration: BoxDecoration(
              color: AppColors.mainGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}
