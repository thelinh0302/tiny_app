import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/home_progress_bar.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/total_card.dart';

/// Reusable summary section showing:
/// - Total Balance card
/// - Total Expense card
/// - Progress bar with amount
/// - Subtitle text
///
/// Originally part of the dashboard home header, but moved to `core/widgets`
/// so it can be reused across multiple screens.
class DashboardTotalsOverview extends StatelessWidget {
  final String totalBalanceTitle;
  final String totalBalanceAmount;
  final String totalExpenseTitle;
  final String totalExpenseAmount;
  final double progress;
  final String progressAmountText;
  final String subtitleText;

  const DashboardTotalsOverview({
    super.key,
    this.totalBalanceTitle = 'Total Balance',
    this.totalBalanceAmount = '0.000',
    this.totalExpenseTitle = 'Total Expense',
    this.totalExpenseAmount = '0.000',
    this.progress = 0,
    this.progressAmountText = '0',
    this.subtitleText = '30% of your expenses, looks good.',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.verticalSmall,
        horizontal: AppSpacing.horizontalSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Total Balance & Total Expense row
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: TotalCard(
                    title: totalBalanceTitle,
                    amount: totalBalanceAmount,
                    icon: AppImages.image(
                      AppImages.income,
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
                VerticalDivider(
                  color: AppColors.white,
                  thickness: 1,
                  width: AppSpacing.horizontalMedium,
                  indent: AppSpacing.verticalMedium,
                  endIndent: AppSpacing.verticalMedium,
                ),
                Expanded(
                  child: TotalCard(
                    title: totalExpenseTitle,
                    amount: totalExpenseAmount,
                    icon: AppImages.image(
                      AppImages.expense,
                      width: 15,
                      height: 15,
                    ),
                    amountColor: AppColors.warningColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.verticalMedium,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: HomeProgressBar(
                progress: progress,
                amountText: progressAmountText,
              ),
            ),
          ),
          Text(
            subtitleText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
