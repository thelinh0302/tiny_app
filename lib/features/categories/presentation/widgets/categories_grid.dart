import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/features/categories/presentation/widgets/add_category_card.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';

/// Grid displaying all categories plus a trailing "Add" tile.
class CategoriesGrid extends StatelessWidget {
  final List<CategoryData> categories;
  final ValueChanged<CategoryData>? onCategoryTap;

  const CategoriesGrid({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
          return const AddCategoryCard();
        }
        final category = categories[index];
        return CategoryCard(
          category: category,
          onTap: () => onCategoryTap?.call(category),
        );
      },
    );
  }
}
