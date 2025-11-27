import 'package:flutter/material.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/features/categories/presentation/models/category_transaction.dart';
import 'package:finly_app/features/categories/presentation/widgets/section_header.dart';
import 'package:finly_app/features/categories/presentation/widgets/transaction_item.dart';

/// Renders grouped category transactions by month-year, and the "Add Expenses"
/// button. Accepts a flat list of CategoryTransaction and groups internally.
class CategoryTransactionsList extends StatelessWidget {
  final List<CategoryTransaction> transactions;
  final VoidCallback onAddExpense;

  const CategoryTransactionsList({
    super.key,
    required this.transactions,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    // Sort by most recent first
    final List<CategoryTransaction> sorted = [...transactions]
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    // Group by month-year in order of appearance (already sorted desc)
    final List<_MonthGroup> groups = [];
    for (final tx in sorted) {
      if (groups.isEmpty ||
          groups.last.month != tx.dateTime.month ||
          groups.last.year != tx.dateTime.year) {
        groups.add(_MonthGroup(tx.dateTime.year, tx.dateTime.month, []));
      }
      groups.last.items.add(tx);
    }

    // Build UI children: header + items per group, separated by space
    final List<Widget> children = [];
    for (int i = 0; i < groups.length; i++) {
      final g = groups[i];
      children.add(SectionHeader(label: _monthName(g.month)));
      children.addAll(
        g.items.map(
          (t) => TransactionItem(
            title: t.title,
            timeLabel: _formatTime(t.dateTime),
            dateLabel: _formatDate(t.dateTime),
            amount: t.amount,
            isExpense: t.isExpense,
            iconAsset: t.iconAsset,
          ),
        ),
      );
      if (i != groups.length - 1) {
        children.add(AppSpacing.verticalSpaceLarge);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...children,
        const SizedBox(height: AppSpacing.verticalLarge),
        SafeArea(
          top: false,
          child: PrimaryButton(text: 'Add Expenses', onPressed: onAddExpense),
        ),
      ],
    );
  }

  static String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
    // Example: "18:27"
  }

  static String _formatDate(DateTime dt) {
    // Example: "April 08"
    final day = dt.day.toString().padLeft(2, '0');
    return '${_monthName(dt.month)} $day';
  }

  static String _monthName(int month) {
    const months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[(month - 1).clamp(0, 11)];
  }
}

class _MonthGroup {
  final int year;
  final int month;
  final List<CategoryTransaction> items;

  _MonthGroup(this.year, this.month, this.items);
}
