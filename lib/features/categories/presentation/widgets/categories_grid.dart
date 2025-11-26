import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/categories/presentation/widgets/add_category_card.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';

const List<CategoryData> kCategories = <CategoryData>[
  CategoryData(
    title: 'Food',
    iconAsset: AppImages.food,
    backgroundColor: AppColors.mainGreen,
  ),
  CategoryData(
    title: 'Car',
    iconAsset: AppImages.savingsCar,
    backgroundColor: AppColors.mainGreen,
  ),
  CategoryData(
    title: 'Salary',
    iconAsset: AppImages.salary,
    backgroundColor: AppColors.mainGreen,
  ),
];

/// Grid displaying all categories plus a trailing "Add" tile.
class CategoriesGrid extends StatelessWidget {
  final ValueChanged<CategoryData>? onCategoryTap;

  const CategoriesGrid({super.key, this.onCategoryTap});

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
      itemCount: kCategories.length + 1,
      itemBuilder: (context, index) {
        if (index == kCategories.length) {
          // Last tile is always the "add" card.
          return const AddCategoryCard();
        }
        final category = kCategories[index];
        return CategoryCard(
          category: category,
          onTap: () => onCategoryTap?.call(category),
        );
      },
    );
  }
}
