import 'package:flutter/material.dart';

import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/filter_bottom_sheet.dart'
    show DateRangeFilter, FilterQuickType;
import 'package:finly_app/core/widgets/filter_button.dart';

/// A reusable header widget that shows a section title on the left
/// and a FilterButton on the right. It forwards initial filter values
/// and emits the selected [DateRangeFilter] via [onApply].
class FilterHeader extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final DateTime? initialFrom;
  final DateTime? initialTo;
  final FilterQuickType? initialQuickType;
  final ValueChanged<DateRangeFilter> onApply;

  const FilterHeader({
    super.key,
    required this.title,
    required this.onApply,
    this.titleStyle,
    this.initialFrom,
    this.initialTo,
    this.initialQuickType,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: AppColors.mainGreen,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: titleStyle ?? defaultStyle),
        FilterButton(
          onApply: onApply,
          initialFrom: initialFrom,
          initialTo: initialTo,
          initialQuickType: initialQuickType,
        ),
      ],
    );
  }
}
