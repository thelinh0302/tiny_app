import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/dashboard_totals_overview.dart';
import 'package:finly_app/features/analytics/presentation/bloc/analytics_summary_bloc.dart';

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
      topChild: BlocProvider<AnalyticsSummaryBloc>(
        create:
            (_) =>
                Modular.get<AnalyticsSummaryBloc>()
                  ..add(const AnalyticsSummaryRequested()),
        child: BlocBuilder<AnalyticsSummaryBloc, AnalyticsSummaryState>(
          builder: (context, state) {
            if (state is AnalyticsSummaryLoadInProgress ||
                state is AnalyticsSummaryInitial) {
              return const DashboardTotalsOverview();
            }
            if (state is AnalyticsSummaryLoadFailure) {
              return const DashboardTotalsOverview();
            }
            if (state is AnalyticsSummaryLoadSuccess) {
              final s = state.summary;
              final balanceText = '\$' + s.balance.toStringAsFixed(2);
              final expenseText = '\$' + s.expenseTotal.toStringAsFixed(2);

              double progress = 0.0;
              final denominator = (s.incomeTotal + s.expenseTotal);
              if (denominator > 0) {
                progress = (s.expenseTotal / denominator).clamp(0, 1);
              }

              return DashboardTotalsOverview(
                totalBalanceTitle: 'Total Balance',
                totalBalanceAmount: balanceText,
                totalExpenseTitle: 'Total Expense',
                totalExpenseAmount: expenseText,
                progress: progress,
                progressAmountText: expenseText,
                subtitleText:
                    'From ${(s.start).toLocal()} to ${(s.end).toLocal()}',
              );
            }
            return const DashboardTotalsOverview();
          },
        ),
      ),
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
