import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import 'custom_button.dart';
import 'date_text_field.dart';

/// Result model returned by the filter bottom sheet
class DateRangeFilter {
  final DateTime? from;
  final DateTime? to;
  final FilterQuickType? quickType;

  const DateRangeFilter({this.from, this.to, this.quickType});

  bool get isQuick => quickType != null;
  bool get isEmpty => quickType == null && from == null && to == null;
}

/// Quick preset options for date range
enum FilterQuickType { today, thisWeek, thisMonth }

/// Public helper to show the filter bottom sheet
///
/// Returns a [DateRangeFilter] when user taps "Apply Filter",
/// or null if dismissed.
Future<DateRangeFilter?> showFilterBottomSheet(
  BuildContext context, {
  DateTime? initialFrom,
  DateTime? initialTo,
  FilterQuickType? initialQuickType,
  ValueChanged<DateRangeFilter>? onApply,
}) async {
  return showModalBottomSheet<DateRangeFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXLarge),
      ),
    ),
    builder: (ctx) {
      return FractionallySizedBox(
        heightFactor: 0.5,
        child: _FilterBottomSheetContent(
          initialFrom: initialFrom,
          initialTo: initialTo,
          initialQuickType: initialQuickType,
          onApply: onApply,
        ),
      );
    },
  );
}

class _FilterBottomSheetContent extends StatefulWidget {
  final DateTime? initialFrom;
  final DateTime? initialTo;
  final FilterQuickType? initialQuickType;
  final ValueChanged<DateRangeFilter>? onApply;

  const _FilterBottomSheetContent({
    required this.initialFrom,
    required this.initialTo,
    this.initialQuickType,
    this.onApply,
  });

  @override
  State<_FilterBottomSheetContent> createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<_FilterBottomSheetContent> {
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();

  DateTime? _from;
  DateTime? _to;
  FilterQuickType? _selectedQuick;

  @override
  void initState() {
    super.initState();
    _from = widget.initialFrom;
    _to = widget.initialTo;

    if (_from != null) _fromCtrl.text = _formatDdMmYyyy(_from!);
    if (_to != null) _toCtrl.text = _formatDdMmYyyy(_to!);

    // Initialize quick type if provided by caller (keeps last selection across opens)
    _selectedQuick = widget.initialQuickType;
    // When a quick type is provided, just highlight it; keep date fields editable and empty.
    // Manual date selection will clear the quick type.
    // Separate modes: do NOT auto-infer quick type from initial dates so that
    // range and quick type remain independent.
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  // dd-MM-yyyy formatter for display in date fields
  String _formatDdMmYyyy(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString().padLeft(4, '0');
    return "$dd-$mm-$yyyy";
  }

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

  DateTime _startOfWeek(DateTime d) {
    final int w = d.weekday; // Monday=1 ... Sunday=7
    final DateTime s = DateTime(
      d.year,
      d.month,
      d.day,
    ).subtract(Duration(days: w - 1));
    return _startOfDay(s);
  }

  DateTime _endOfWeek(DateTime d) {
    final DateTime s = _startOfWeek(d);
    final DateTime e = s.add(const Duration(days: 6));
    return _endOfDay(e);
  }

  DateTime _startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);

  DateTime _endOfMonth(DateTime d) {
    final DateTime firstNextMonth =
        (d.month == 12)
            ? DateTime(d.year + 1, 1, 1)
            : DateTime(d.year, d.month + 1, 1);
    final DateTime lastDay = firstNextMonth.subtract(const Duration(days: 1));
    return _endOfDay(lastDay);
  }

  void _applyQuick(FilterQuickType range) {
    setState(() {
      // Toggle selection: tap again to unselect quick type
      if (_selectedQuick == range) {
        _selectedQuick = null;
      } else {
        _selectedQuick = range;
      }
      // In quick mode, do not auto-fill date fields; keep them empty and editable
      _from = null;
      _to = null;
      _fromCtrl.clear();
      _toCtrl.clear();
    });
  }

  void _onFromChanged(DateTime d) {
    setState(() {
      _from = _startOfDay(d);
      _selectedQuick = null; // manual override clears quick selection
    });
  }

  void _onToChanged(DateTime d) {
    setState(() {
      _to = _endOfDay(d);
      _selectedQuick = null; // manual override clears quick selection
    });
  }

  void _onReset() {
    setState(() {
      _from = null;
      _to = null;
      _fromCtrl.clear();
      _toCtrl.clear();
      _selectedQuick = null;
    });
  }

  void _onApply() {
    // Validate: if both set, from <= to
    if (_from != null && _to != null && _from!.isAfter(_to!)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('filter.errors.fromAfterTo'.tr())));
      return;
    }

    final result =
        _selectedQuick != null
            ? DateRangeFilter(quickType: _selectedQuick)
            : DateRangeFilter(from: _from, to: _to);
    widget.onApply?.call(result);

    Navigator.of(context).pop<DateRangeFilter>(result);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: AppSpacing.paddingScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grab handle & title row
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'filter.title'.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.verticalSpaceLarge,

            IgnorePointer(
              ignoring: false,
              child: Opacity(
                opacity: _selectedQuick != null ? 0.5 : 1.0,
                child: Row(
                  children: [
                    Expanded(
                      child: DateTextField(
                        controller: _fromCtrl,
                        labelText: 'filter.from'.tr(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                        initialDate: _from,
                        dateFormatter: (d) {
                          final dd = d.day.toString().padLeft(2, '0');
                          final mm = d.month.toString().padLeft(2, '0');
                          final yyyy = d.year.toString().padLeft(4, '0');
                          return "$dd-$mm-$yyyy";
                        },
                        onDateChanged: _onFromChanged,
                      ),
                    ),
                    AppSpacing.horizontalSpaceMedium,
                    Expanded(
                      child: DateTextField(
                        controller: _toCtrl,
                        labelText: 'filter.to'.tr(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                        initialDate: _to,
                        dateFormatter: (d) {
                          final dd = d.day.toString().padLeft(2, '0');
                          final mm = d.month.toString().padLeft(2, '0');
                          final yyyy = d.year.toString().padLeft(4, '0');
                          return "$dd-$mm-$yyyy";
                        },
                        onDateChanged: _onToChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.verticalSpaceLarge,
            _QuickButtons(
              selected: _selectedQuick,
              onSelected: _applyQuick,
              isDisabled: false,
            ),

            const Spacer(),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    text: 'filter.resetAll'.tr(),
                    onPressed: _onReset,
                  ),
                ),
                AppSpacing.horizontalSpaceMedium,
                Expanded(
                  child: PrimaryButton(
                    text: 'filter.apply'.tr(),
                    onPressed: _onApply,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalSpaceLarge,
          ],
        ),
      ),
    );
  }
}

class _QuickButtons extends StatelessWidget {
  final FilterQuickType? selected;
  final ValueChanged<FilterQuickType> onSelected;
  final bool isDisabled;

  const _QuickButtons({
    required this.selected,
    required this.onSelected,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickButton(
            label: 'filter.quick.today'.tr(),
            isSelected: selected == FilterQuickType.today,
            onTap: () => onSelected(FilterQuickType.today),
            isDisabled: isDisabled,
          ),
        ),
        AppSpacing.horizontalSpaceSmall,
        Expanded(
          child: _QuickButton(
            label: 'filter.quick.thisWeek'.tr(),
            isSelected: selected == FilterQuickType.thisWeek,
            onTap: () => onSelected(FilterQuickType.thisWeek),
            isDisabled: isDisabled,
          ),
        ),
        AppSpacing.horizontalSpaceSmall,
        Expanded(
          child: _QuickButton(
            label: 'filter.quick.thisMonth'.tr(),
            isSelected: selected == FilterQuickType.thisMonth,
            onTap: () => onSelected(FilterQuickType.thisMonth),
            isDisabled: isDisabled,
          ),
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDisabled;

  const _QuickButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: isSelected ? AppColors.textSecondary : AppColors.textPrimary,
      fontWeight: FontWeight.w500,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMedium,
          vertical: AppSpacing.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: isDisabled ? AppColors.lightGrey : AppColors.mainGreen,
            width: AppSizes.borderWidthThin,
          ),
        ),
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Center(child: Text(label, style: textStyle)),
        ),
      ),
    );
  }
}

/*
Usage:

// Option A: await result
final result = await showFilterBottomSheet(
  context,
  initialFrom: state.from,
  initialTo: state.to,
);
if (result != null) {
  if (result.isQuick) {
    // Use result.quickType (FilterQuickType.today/thisWeek/thisMonth)
  } else {
    // Use result.from / result.to
  }
}

// Option B: provide a callback (sheet still returns the same result)
await showFilterBottomSheet(
  context,
  initialFrom: state.from,
  initialTo: state.to,
  onApply: (res) {
    if (res.isQuick) {
      // Handle by quick type
    } else {
      // Handle by from/to dates
    }
  },
);
*/
