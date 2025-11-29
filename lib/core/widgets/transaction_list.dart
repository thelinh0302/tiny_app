import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

class TransactionItemData {
  final String title;
  final String timeAndDate;
  final String category;
  final String amount;
  final bool isIncome;
  final String iconAsset;

  const TransactionItemData({
    required this.title,
    required this.timeAndDate,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.iconAsset,
  });
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.items});

  final List<TransactionItemData> items;

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
            child: TransactionItem(data: item),
          ),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.data});

  final TransactionItemData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
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
            child: AppImages.image(
              data.iconAsset,
              width: 25,
              height: 25,
              color: AppColors.white,
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
                color: data.isIncome ? AppColors.black : AppColors.warningColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
