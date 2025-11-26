import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/dashboard_totals_overview.dart';
import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:finly_app/features/categories/presentation/widgets/categories_grid.dart';

/// Categories page:
/// - Uses MainLayout with an AppBar
/// - Reuses DashboardTotalsOverview as the topChild
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: const MainAppBar(titleKey: 'Categories'),
      topChild: const DashboardTotalsOverview(),
      enableContentScroll: true,
      topHeightRatio: 0.60,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.horizontalMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [AppSpacing.verticalSpaceMedium, const CategoriesGrid()],
        ),
      ),
    );
  }
}
