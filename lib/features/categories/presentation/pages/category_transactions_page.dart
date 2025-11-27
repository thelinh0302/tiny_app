import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/widgets/dashboard_totals_overview.dart';
import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_card.dart';
import 'package:finly_app/features/categories/presentation/models/category_transaction.dart';
import 'package:finly_app/features/categories/presentation/widgets/category_transactions_list.dart';

/// Transactions screen for a selected Category.
/// Uses MainLayout and the reusable TransactionItem widget.
class CategoryTransactionsPage extends StatelessWidget {
  final CategoryData category;

  const CategoryTransactionsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Mock: single flat list simulating API response (one list instead of separate April/March)
    final List<CategoryTransaction> txs = [
      CategoryTransaction(
        title: 'Dinner',
        dateTime: DateTime(DateTime.now().year, 4, 30, 18, 27),
        amount: 26.00,
        isExpense: true,
        iconAsset: category.iconAsset,
      ),
      CategoryTransaction(
        title: 'Delivery Pizza',
        dateTime: DateTime(DateTime.now().year, 4, 24, 15, 00),
        amount: 18.35,
        isExpense: true,
        iconAsset: category.iconAsset,
      ),
      CategoryTransaction(
        title: 'Lunch',
        dateTime: DateTime(DateTime.now().year, 4, 15, 12, 30),
        amount: 15.40,
        isExpense: true,
        iconAsset: category.iconAsset,
      ),
      CategoryTransaction(
        title: 'Brunch',
        dateTime: DateTime(DateTime.now().year, 4, 8, 9, 30),
        amount: 12.13,
        isExpense: true,
        iconAsset: category.iconAsset,
      ),
      CategoryTransaction(
        title: 'Brunch',
        dateTime: DateTime(DateTime.now().year, 4, 8, 9, 30),
        amount: 12.13,
        isExpense: true,
        iconAsset: category.iconAsset,
      ),
      CategoryTransaction(
        title: 'Dinner',
        dateTime: DateTime(DateTime.now().year, 3, 31, 20, 50),
        amount: 27.20,
        isExpense: true,
        iconAsset: category.iconAsset,
      ),
    ];

    return MainLayout(
      appBar: MainAppBar(titleKey: category.title),
      topChild: const DashboardTotalsOverview(
        totalBalanceAmount: '5,200.00',
        totalExpenseAmount: '1,250.00',
        progress: 0.35,
        progressAmountText: '7,783.00',
        subtitleText: '35% of your expenses, looks good.',
      ),
      topHeightRatio: 0.58,
      enableContentScroll: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.horizontalMedium,
          vertical: AppSpacing.verticalSmall,
        ),
        child: CategoryTransactionsList(
          transactions: txs,
          onAddExpense: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add expense flow not implemented yet'),
              ),
            );
          },
        ),
      ),
    );
  }
}
