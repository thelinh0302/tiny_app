import 'package:flutter/material.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Reusable statistic card for the Transactions feature (Income/Expense).
class StatCard extends StatelessWidget {
  final Widget? iconWidget;
  final String label;
  final String amount;

  const StatCard({
    super.key,
    this.iconWidget,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.9),
        borderRadius: AppSpacing.borderRadiusXLarge,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingSmall),
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusMedium,
            ),
            child: iconWidget,
          ),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalSpaceSmall,
          Text(
            amount,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
