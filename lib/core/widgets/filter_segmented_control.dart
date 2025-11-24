import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

/// A segmented filter control like: [ Daily ] [ Weekly ] [ Monthly ]
///
/// Usage:
/// ```dart
/// FilterSegmentedControl<String>(
///   options: const ['Daily', 'Weekly', 'Monthly'],
///   value: selectedFilter,
///   onChanged: (v) => setState(() => selectedFilter = v),
/// )
/// ```
class FilterSegmentedControl<T> extends StatelessWidget {
  final List<T> options;
  final T value;
  final ValueChanged<T> onChanged;
  final EdgeInsetsGeometry padding;

  const FilterSegmentedControl({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.padding = const EdgeInsets.all(AppSpacing.paddingSmall),
  }) : assert(options.length > 1, 'At least two options are required');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
        border: Border.all(
          color: AppColors.mainGreen,
          width: AppSizes.borderWidthThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          for (final option in options)
            Expanded(
              child: _FilterSegmentItem<T>(
                label: option.toString(),
                isSelected: option == value,
                onTap: () => onChanged(option),
                theme: theme,
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterSegmentItem<T> extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _FilterSegmentItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = theme.textTheme.titleMedium?.copyWith(
      color: isSelected ? AppColors.textSecondary : AppColors.textPrimary,
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.horizontalSmall,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          // Slightly smaller padding so the text fits comfortably
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingMedium,
            vertical: AppSpacing.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.mainGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(
              color: AppColors.mainGreen,
              width: AppSizes.borderWidthThin,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
