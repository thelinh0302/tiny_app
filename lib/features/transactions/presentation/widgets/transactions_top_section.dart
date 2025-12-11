import 'package:flutter/material.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/features/transactions/presentation/widgets/stat_card.dart';

/// Top section for the Transactions feature.
class TransactionsTopSection extends StatelessWidget {
  final VoidCallback? onFilterIncome;
  final VoidCallback? onFilterExpense;
  final String? selectedType; // 'income', 'expense', or null

  const TransactionsTopSection({
    super.key,
    this.onFilterIncome,
    this.onFilterExpense,
    this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Total Balance card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.paddingLarge,
            horizontal: AppSpacing.paddingMedium,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppSpacing.borderRadiusLarge,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Total Balance',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.verticalSpaceSmall,
              Text(
                '\$7,783.00',
                style: textTheme.displaySmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        AppSpacing.verticalSpaceMedium,

        // Income / Expense cards
        Row(
          children: [
            Expanded(
              child: StatCard(
                iconWidget: AppImages.image(
                  AppImages.income,
                  width: 20,
                  height: 20,
                  color:
                      selectedType == 'income'
                          ? AppColors.white
                          : AppColors.textPrimary,
                ),
                label: 'Income',
                amount: '\$4,120.00',
                onTap: onFilterIncome,
                selected: selectedType == 'income',
              ),
            ),
            AppSpacing.horizontalSpaceMedium,
            Expanded(
              child: StatCard(
                iconWidget: AppImages.image(
                  AppImages.expense,
                  width: 20,
                  height: 20,
                  color:
                      selectedType == 'expense'
                          ? AppColors.white
                          : AppColors.textPrimary,
                ),
                label: 'Expense',
                amount: '\$1,187.40',
                onTap: onFilterExpense,
                selected: selectedType == 'expense',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
