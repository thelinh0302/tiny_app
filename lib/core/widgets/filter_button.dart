import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/filter_bottom_sheet.dart';

/// A reusable circular filter icon button that opens the Filter Bottom Sheet.
///
/// You can pass optional initialFrom/initialTo and an onApply callback to
/// receive the selected DateRangeFilter immediately when the user taps Apply.
class FilterButton extends StatelessWidget {
  final DateTime? initialFrom;
  final DateTime? initialTo;
  final FilterQuickType? initialQuickType;
  final ValueChanged<DateRangeFilter>? onApply;

  const FilterButton({
    super.key,
    this.initialFrom,
    this.initialTo,
    this.initialQuickType,
    this.onApply,
  });

  Future<void> _openSheet(BuildContext context) async {
    await showFilterBottomSheet(
      context,
      initialFrom: initialFrom,
      initialTo: initialTo,
      initialQuickType: initialQuickType,
      onApply: onApply,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _openSheet(context),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.mainGreen.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: AppImages.image(AppImages.filter, width: 28, height: 28),
          ),
        ),
      ),
    );
  }
}
