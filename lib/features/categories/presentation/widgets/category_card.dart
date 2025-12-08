import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/categories/presentation/widgets/helpers/icon_widget.dart';

/// Simple model describing a category item.
class CategoryData {
  final String title;
  final String iconAsset;
  final Color backgroundColor;

  const CategoryData({
    required this.title,
    required this.iconAsset,
    required this.backgroundColor,
  });
}

/// Reusable category card widget with tap callback.
class CategoryCard extends StatelessWidget {
  final CategoryData category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainGreen.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.horizontalSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: category.backgroundColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: buildCategoryIcon(
                    category.iconAsset,
                    width: 54,
                    height: 54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
