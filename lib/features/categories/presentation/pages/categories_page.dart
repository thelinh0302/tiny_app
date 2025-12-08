import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/dashboard_totals_overview.dart';
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
        topChild: const DashboardTotalsOverview(),
        enableContentScroll: true,
        topHeightRatio: 0.60,
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
