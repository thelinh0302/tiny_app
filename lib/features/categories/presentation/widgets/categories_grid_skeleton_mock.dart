import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/categories/presentation/widgets/categories_grid.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';

/// Mock-data based skeleton for categories, rendered with shimmer.
/// This uses the real CategoriesGrid and CategoryCard structure so the
/// layout closely matches the final UI while data is loading.
class CategoriesGridSkeletonMock extends StatelessWidget {
  final int itemCount;

  const CategoriesGridSkeletonMock({super.key, this.itemCount = 6});

  List<CategoryData> _buildMockCategories(int count) {
    const icons = [AppImages.food, AppImages.savingsCar, AppImages.salary];
    final List<CategoryData> items = [];
    for (int i = 0; i < count; i++) {
      items.add(
        CategoryData(
          title: '••••',
          iconAsset: icons[i % icons.length],
          backgroundColor: AppColors.mainGreen.withValues(alpha: 0.1),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final mock = _buildMockCategories(itemCount);
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(),
      child: CategoriesGrid(
        categories: mock,
        onCategoryTap: null, // disabled during loading
      ),
    );
  }
}
