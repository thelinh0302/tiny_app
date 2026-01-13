import 'package:equatable/equatable.dart';

class AnalyticsSummary extends Equatable {
  final double incomeTotal;
  final double expenseTotal;
  final double balance;
  final DateTime start;
  final DateTime end;

  const AnalyticsSummary({
    required this.incomeTotal,
    required this.expenseTotal,
    required this.balance,
    required this.start,
    required this.end,
  });

  @override
  List<Object> get props => [incomeTotal, expenseTotal, balance, start, end];
}
