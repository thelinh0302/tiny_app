import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Right side metrics section of the savings goals card.
///
/// Shows:
/// - Primary metric title + amount (e.g. "Revenue Last Week" + "$4,000.00")
/// - Divider
/// - Secondary metric title + amount (e.g. "Food Last Week" + "-$100.00")
class SavingsGoalsMetrics extends StatelessWidget {
  final String primaryTitle;
  final String primaryAmount;
  final String secondaryTitle;
  final String secondaryAmount;
  final Color secondaryAmountColor;

  const SavingsGoalsMetrics({
    super.key,
    required this.primaryTitle,
    required this.primaryAmount,
    required this.secondaryTitle,
    required this.secondaryAmount,
    this.secondaryAmountColor = AppColors.warningColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary metric (with salary icon)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImages.image(
              AppImages.salary,
              width: 35,
              height: 35,
              color: AppColors.white,
            ),
            AppSpacing.horizontalSpaceSmall,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryTitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  primaryAmount,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        AppSpacing.verticalSpaceSmall,
        // Horizontal divider
        Container(height: 2, color: AppColors.white),
        AppSpacing.verticalSpaceSmall,

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImages.image(
              AppImages.food,
              width: 35,
              height: 35,
              color: AppColors.white,
            ),
            AppSpacing.horizontalSpaceSmall,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  secondaryTitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  secondaryAmount,
                  style: textTheme.titleMedium?.copyWith(
                    color: secondaryAmountColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
