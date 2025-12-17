import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:finly_app/core/constants/app_sizes.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/constants/app_images.dart';
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
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionItem({
    super.key,
    required this.title,
    required this.timeLabel,
    required this.dateLabel,
    required this.amount,
    this.isExpense = true,
    this.iconAsset = 'assets/images/food_icon.svg',
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String display =
        '${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(2)}';

    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.44,
        children: [
          CustomSlidableAction(
            onPressed: (_) => onEdit?.call(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.mainGreen,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSpacing.radiusSmall),
                ),
              ),
              child: Center(
                child: AppImages.image(AppImages.edit, width: 24, height: 24),
              ),
            ),
          ),
          CustomSlidableAction(
            onPressed: (_) => onDelete?.call(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.mainGreen,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSpacing.radiusSmall),
                ),
              ),
              child: Center(
                child: AppImages.image(AppImages.delete, width: 23, height: 25),
              ),
            ),
          ),
        ],
      ),
      child: Padding(
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
                color:
                    isExpense ? AppColors.textPrimary : AppColors.successColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
