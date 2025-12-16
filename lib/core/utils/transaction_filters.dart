import 'package:finly_app/core/widgets/filter_bottom_sheet.dart'
    show DateRangeFilter, FilterQuickType;

/// Result of applying a date range filter.
class FilterApplyResult {
  final String period; // '', 'daily', 'week', 'month'
  final String? dateStart; // yyyy-MM-dd when manual range used
  final String? dateEnd; // yyyy-MM-dd when manual range used
  final FilterQuickType? lastQuick; // persist quick selection
  final DateTime? lastFrom; // persist manual from
  final DateTime? lastTo; // persist manual to

  const FilterApplyResult({
    required this.period,
    required this.dateStart,
    required this.dateEnd,
    required this.lastQuick,
    required this.lastFrom,
    required this.lastTo,
  });
}

/// Build filter parameters and persisted selection values from a DateRangeFilter.
///
/// This extracts UI logic from the page so it can be reused and tested.
FilterApplyResult buildFilterApplyResult(DateRangeFilter res) {
  String period = '';
  String? dateStart;
  String? dateEnd;
  FilterQuickType? lastQuick;
  DateTime? lastFrom;
  DateTime? lastTo;

  if (res.isQuick) {
    // Persist quick selection and clear manual range
    lastQuick = res.quickType;
    lastFrom = null;
    lastTo = null;

    switch (res.quickType) {
      case FilterQuickType.today:
        period = 'daily';
        break;
      case FilterQuickType.thisWeek:
        period = 'week';
        break;
      case FilterQuickType.thisMonth:
        period = 'month';
        break;
      default:
        period = '';
    }
  } else {
    // Persist manual range and clear quick selection
    lastQuick = null;
    lastFrom = res.from;
    lastTo = res.to;

    if (res.from != null && res.to != null) {
      dateStart = _formatYmd(res.from!);
      dateEnd = _formatYmd(res.to!);
      period = '';
    } else {
      period = '';
    }
  }

  return FilterApplyResult(
    period: period,
    dateStart: dateStart,
    dateEnd: dateEnd,
    lastQuick: lastQuick,
    lastFrom: lastFrom,
    lastTo: lastTo,
  );
}

String _formatYmd(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return "$y-$m-$day";
}
