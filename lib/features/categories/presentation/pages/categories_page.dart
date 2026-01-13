import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/dashboard_totals_overview.dart';
import 'package:finly_app/features/analytics/presentation/bloc/analytics_summary_bloc.dart';
import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:finly_app/features/categories/presentation/widgets/categories_grid.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';
import 'package:finly_app/features/categories/presentation/bloc/category_list_bloc.dart';
import 'package:finly_app/features/categories/presentation/widgets/categories_grid_skeleton.dart';
import 'package:finly_app/core/widgets/error_retry.dart';

/// Categories page:
/// - Uses MainLayout with an AppBar
/// - Reuses DashboardTotalsOverview as the topChild
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryListBloc>(
      create:
          (_) =>
              Modular.get<CategoryListBloc>()
                ..add(const CategoryListRequested(page: 1, pageSize: 20)),
      child: MainLayout(
        appBar: const MainAppBar(titleKey: 'Categories'),
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
                // Fallback to zeros; could render an error banner if desired
                return const DashboardTotalsOverview();
              }
              if (state is AnalyticsSummaryLoadSuccess) {
                final s = state.summary;
                // Using intl directly for clarity in display
                final balanceText = '\$' + s.balance.toStringAsFixed(2);
                final expenseText = '\$' + s.expenseTotal.toStringAsFixed(2);

                // Progress bar: expense vs income (avoid divide-by-zero)
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
                );
              }
              return const DashboardTotalsOverview();
            },
          ),
        ),
        enableContentScroll: true,
        useIntrinsicTopHeight: true,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.horizontalMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.verticalSpaceMedium,
              BlocBuilder<CategoryListBloc, CategoryListState>(
                builder: (context, state) {
                  if (state is CategoryListLoadInProgress ||
                      state is CategoryListInitial) {
                    return const CategoriesGridSkeleton();
                  }
                  if (state is CategoryListLoadFailure) {
                    return ErrorRetry(
                      message: state.message,
                      onRetry:
                          () => BlocProvider.of<CategoryListBloc>(context).add(
                            const CategoryListRequested(page: 1, pageSize: 20),
                          ),
                    );
                  }
                  if (state is CategoryListLoadSuccess) {
                    final mapped =
                        state.items
                            .map(
                              (c) => CategoryData(
                                id: c.id,
                                title: c.name,
                                iconAsset: c.iconUrl ?? AppImages.food,
                                backgroundColor: AppColors.mainGreen,
                              ),
                            )
                            .toList();
                    return CategoriesGrid(
                      categories: mapped,
                      onCategoryTap: (category) {
                        Modular.to.pushNamed(
                          '/dashboard/category/transactions',
                          arguments: category,
                        );
                      },
                      onAddCompleted: () {
                        BlocProvider.of<CategoryListBloc>(context).add(
                          const CategoryListRequested(page: 1, pageSize: 20),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
