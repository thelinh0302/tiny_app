import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/savings_goals_progress.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/savings_goals_metrics.dart';

/// Dashboard card that replicates the "Savings on Goals" widget design.
///
/// Layout:
/// - Left: circular progress with car icon and "Savings On Goals" text
/// - Right: vertical divider + two lines:
///     - Revenue Last Week: \$4,000.00
///     - Food Last Week: -\$100.00 (highlighted in warning color)
class SavingsGoalsCard extends StatelessWidget {
  /// Progress value between 0 and 1 for the circular indicator.
  final double progress;

  /// Main title under the circular progress.
  final String savingsLabel;

  /// Title and amount for the primary metric (top-right).
  final String primaryTitle;
  final String primaryAmount;

  /// Title and amount for the secondary metric (bottom-right).
  final String secondaryTitle;
  final String secondaryAmount;
  final Color secondaryAmountColor;

  const SavingsGoalsCard({
    super.key,
    this.progress = 0.75,
    this.savingsLabel = 'Savings\nOn Goals',
    this.primaryTitle = 'Revenue Last Week',
    this.primaryAmount = '\$4,000.00',
    this.secondaryTitle = 'Food Last Week',
    this.secondaryAmount = '-\$100.00',
    this.secondaryAmountColor = AppColors.warningColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.horizontalMedium,
        vertical: AppSpacing.verticalMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.mainGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SavingsGoalsProgress(progress: progress, savingsLabel: savingsLabel),
          AppSpacing.horizontalSpaceLarge,
          // Vertical divider
          Container(width: 2, height: 120, color: AppColors.white),
          AppSpacing.horizontalSpaceLarge,
          // Right side metrics
          Expanded(
            child: SavingsGoalsMetrics(
              primaryTitle: primaryTitle,
              primaryAmount: primaryAmount,
              secondaryTitle: secondaryTitle,
              secondaryAmount: secondaryAmount,
              secondaryAmountColor: secondaryAmountColor,
            ),
          ),
        ],
      ),
    );
  }
}
