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

/// Small value object representing the analytics date range (ISO yyyy-MM-dd)
class AnalyticsDateRange {
  final String? startDate;
  final String? endDate;

  const AnalyticsDateRange({this.startDate, this.endDate});
}

/// Compute the analytics startDate/endDate based on the user's selection.
/// - If a quick filter is chosen (today/thisWeek/thisMonth), we derive dates.
/// - If a manual range is used, reuse the values from [result].
AnalyticsDateRange buildAnalyticsDateRange(
  DateRangeFilter res,
  FilterApplyResult result,
) {
  // Manual range: reuse
  if (!res.isQuick) {
    return AnalyticsDateRange(
      startDate: result.dateStart,
      endDate: result.dateEnd,
    );
  }

  final now = DateTime.now();
  late DateTime start;
  late DateTime end;

  switch (res.quickType) {
    case FilterQuickType.today:
      start = DateTime(now.year, now.month, now.day);
      end = DateTime(now.year, now.month, now.day);
      break;
    case FilterQuickType.thisWeek:
      // Assume week starts on Monday
      final int weekday = now.weekday; // Mon=1 ... Sun=7
      start = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: weekday - 1));
      end = start.add(const Duration(days: 6));
      break;
    case FilterQuickType.thisMonth:
      start = DateTime(now.year, now.month, 1);
      final nextMonth =
          (now.month == 12)
              ? DateTime(now.year + 1, 1, 1)
              : DateTime(now.year, now.month + 1, 1);
      end = nextMonth.subtract(const Duration(days: 1));
      break;
    default:
      start = DateTime(now.year, now.month, now.day);
      end = DateTime(now.year, now.month, now.day);
  }

  return AnalyticsDateRange(
    startDate: _formatYmd(start),
    endDate: _formatYmd(end),
  );
}

String _formatYmd(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return "$y-$m-$day";
}
