import 'package:flutter/material.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Reusable section header for transaction/category group labels.
class SectionHeader extends StatelessWidget {
  final String label;

  const SectionHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.verticalSmall),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.grey.withOpacity(0.6),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
