import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/categories/presentation/widgets/helpers/icon_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:finly_app/core/constants/app_images.dart';

class TransactionItemData {
  final String id;
  final String title;
  final String timeAndDate;
  final String category;
  final String amount;
  final bool isIncome;
  final String iconAsset;

  const TransactionItemData({
    required this.id,
    required this.title,
    required this.timeAndDate,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.iconAsset,
  });
}

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.items,
    this.onDelete,
    this.onEdit,
  });

  final List<TransactionItemData> items;
  final ValueChanged<TransactionItemData>? onDelete;
  final ValueChanged<TransactionItemData>? onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.verticalSmall,
            ),
            child: TransactionItem(
              data: item,
              onDelete: onDelete == null ? null : () => onDelete!(item),
              onEdit: onEdit == null ? null : () => onEdit!(item),
            ),
          ),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.data,
    this.onDelete,
    this.onEdit,
  });

  final TransactionItemData data;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon in rounded square (fixed width)
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.mainGreen,
              borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
            ),
            child: Center(
              child: buildCategoryIcon(
                data.iconAsset,
                width: 25,
                height: 25,
                fit: BoxFit.contain,
              ),
            ),
          ),
          AppSpacing.horizontalSpaceSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                AppSpacing.verticalSpaceTiny,
                Text(
                  data.timeAndDate,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.mainGreen,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalSpaceSmall,
          Container(width: 1, height: 40, color: AppColors.mainGreen),
          Expanded(
            child: Center(
              child: Text(
                data.category,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.black),
              ),
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.mainGreen),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                data.amount,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color:
                      data.isIncome ? AppColors.black : AppColors.warningColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
