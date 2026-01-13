import 'package:finly_app/features/analytics/domain/entities/analytics_summary.dart';

class AnalyticsSummaryModel extends AnalyticsSummary {
  const AnalyticsSummaryModel({
    required super.incomeTotal,
    required super.expenseTotal,
    required super.balance,
    required super.start,
    required super.end,
  });

  factory AnalyticsSummaryModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummaryModel(
      incomeTotal: (json['incomeTotal'] as num?)?.toDouble() ?? 0.0,
      expenseTotal: (json['expenseTotal'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );
  }
}
