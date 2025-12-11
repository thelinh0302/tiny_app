import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

class TransactionListSkeleton extends StatelessWidget {
  final int itemCount;
  const TransactionListSkeleton({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(itemCount, (index) => _row(context)),
      ),
    );
  }

  Widget _row(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.verticalSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon placeholder
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.mainGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          AppSpacing.horizontalSpaceSmall,
          // Title and time placeholders
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
                  width: 140,
                  decoration: BoxDecoration(
                    color: AppColors.mainGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalSpaceSmall,
          Container(
            width: 1,
            height: 40,
            color: AppColors.mainGreen.withValues(alpha: 0.4),
          ),
          // Category placeholder
          Expanded(
            child: Center(
              child: Container(
                height: 14,
                width: 80,
                decoration: BoxDecoration(
                  color: AppColors.mainGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.mainGreen.withValues(alpha: 0.4),
          ),
          // Amount placeholder
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 16,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.mainGreen.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
