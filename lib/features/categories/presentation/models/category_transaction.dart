import 'package:flutter/foundation.dart';

/// Simple UI model representing a category transaction item.
/// Contains enough data to render TransactionItem and to group by month-year.
@immutable
class CategoryTransaction {
  final String title;
  final DateTime dateTime;
  final double amount;
  final bool isExpense;
  final String iconAsset;

  const CategoryTransaction({
    required this.title,
    required this.dateTime,
    required this.amount,
    required this.isExpense,
    required this.iconAsset,
  });
}
