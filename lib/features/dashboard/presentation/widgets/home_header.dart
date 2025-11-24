import 'package:easy_localization/easy_localization.dart';
import 'package:finly_app/core/widgets/dashboard_totals_overview.dart';
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
        const DashboardTotalsOverview(),
      ],
    );
  }
}
