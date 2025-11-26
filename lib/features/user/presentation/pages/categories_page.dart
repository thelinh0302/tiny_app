import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/dashboard_totals_overview.dart';

/// Categories page using MainLayout with app bar and a reusable
/// DashboardTotalsOverview section at the top.
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: AppBar(
        title: Text(
          'Categories'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.mainGreen,
        elevation: 0,
      ),
      topChild: const DashboardTotalsOverview(),
      enableContentScroll: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.horizontalMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories'.tr(),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.verticalSpaceMedium,
            Text(
              'Coming soon...'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            // TODO: Replace with real categories list / grid.
          ],
        ),
      ),
    );
  }
}
