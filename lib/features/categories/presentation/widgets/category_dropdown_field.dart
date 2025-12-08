import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';

class CategoryDropdownField extends StatelessWidget {
  final CategoryData? value;
  final String? errorText;
  final ValueChanged<CategoryData?> onChanged;
  final String labelText;
  final List<CategoryData> categories;

  const CategoryDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.categories,
    this.errorText,
    this.labelText = 'Category',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.darkGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<CategoryData>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLarge,
              borderSide: const BorderSide(
                color: AppColors.borderButtonPrimary,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLarge,
              borderSide: const BorderSide(
                color: AppColors.borderButtonPrimary,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLarge,
              borderSide: const BorderSide(
                color: AppColors.errorColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusLarge,
              borderSide: const BorderSide(
                color: AppColors.errorColor,
                width: 2,
              ),
            ),
            errorText: errorText,
          ),
          items:
              categories
                  .map(
                    (c) => DropdownMenuItem<CategoryData>(
                      value: c,
                      child: Text(c.title),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
