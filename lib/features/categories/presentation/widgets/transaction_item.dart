import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:finly_app/core/constants/app_sizes.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/categories/presentation/widgets/helpers/icon_widget.dart';

/// Reusable transaction list item used in the Category Transactions screen.
/// Matches the design: leading circular icon, title, time-date subtitle,
/// and a right-aligned amount (negative for expenses).
class TransactionItem extends StatelessWidget {
  final String title;
  final String timeLabel; // e.g. "18:27"
  final String dateLabel; // e.g. "April 30"
  final double amount;
  final bool isExpense;
  final String iconAsset;

  const TransactionItem({
    super.key,
    required this.title,
    required this.timeLabel,
    required this.dateLabel,
    required this.amount,
    this.isExpense = true,
    this.iconAsset = 'assets/images/food_icon.svg',
  });

  @override
  Widget build(BuildContext context) {
    final String display =
        '${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(2)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading circular icon
          Container(
            height: AppSizes.avatarLarge,
            width: AppSizes.avatarLarge,
            decoration: BoxDecoration(
              color: AppColors.mainGreenWithOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                height: AppSizes.iconXLarge,
                width: AppSizes.iconXLarge,
                decoration: BoxDecoration(
                  color: AppColors.mainGreenWithOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: buildCategoryIcon(iconAsset),
                ),
              ),
            ),
          ),
          AppSpacing.horizontalSpaceMedium,
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.verticalSpaceTiny,
                Text(
                  '$timeLabel - $dateLabel',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            display,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isExpense ? AppColors.textPrimary : AppColors.successColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
