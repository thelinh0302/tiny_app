import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/features/categories/presentation/widgets/add_category_card.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:finly_app/core/widgets/no_result_widget.dart';

/// Grid displaying all categories plus a trailing "Add" tile.
class CategoriesGrid extends StatelessWidget {
  final List<CategoryData> categories;
  final ValueChanged<CategoryData>? onCategoryTap;
  final VoidCallback? onAddCompleted;

  const CategoriesGrid({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.onAddCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final grid = GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.verticalMedium,
        crossAxisSpacing: AppSpacing.horizontalMedium,
        childAspectRatio: 1.05,
      ),
      itemCount: categories.length + 1,
      itemBuilder: (context, index) {
        if (index == categories.length) {
          // Last tile is always the "add" card.
          return AddCategoryCard(onAdded: onAddCompleted);
        }
        final category = categories[index];
        return CategoryCard(
          category: category,
          onTap: () => onCategoryTap?.call(category),
        );
      },
    );

    if (categories.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          NoResultWidget(
            title: 'category.empty.title'.tr(),
            subtitle: 'category.empty.subtitle'.tr(),
          ),
          const SizedBox(height: AppSpacing.verticalLarge),
          grid,
        ],
      );
    }

    return grid;
  }
}
