import 'package:easy_localization/easy_localization.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/total_card.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/home_progress_bar.dart';
import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Top header for the dashboard home page.
/// Shows welcome title/subtitle on the left and notification icon on the right.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: welcome + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hi, Welcome Back'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.verticalSmall),
                  Text(
                    'Good morning',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            // Right side: notification icon
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppImages.image(
                  'assets/images/noti_icon.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ],
        ),
        Padding(
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
                        title: 'Total Balance',
                        amount: '0.000',
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
                        title: 'Total Expense',
                        amount: '0.000',
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
                  child: const HomeProgressBar(
                    progress: 0.3,
                    amountText: '\$7,783.00',
                  ),
                ),
              ),
              Text(
                '30% of your expenses, looks good.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
