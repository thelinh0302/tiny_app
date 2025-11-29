import 'package:finly_app/core/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/features/transactions/presentation/widgets/transactions_top_section.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/transaction_list.dart';
import 'package:finly_app/core/constants/app_images.dart';

/// Transactions page defined under the Transactions feature.
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: MainAppBar(titleKey: 'transaction', showBackButton: false),
      topHeightRatio: 0.82,
      topChild: const TransactionsTopSection(),
      enableContentScroll: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.horizontalMedium),
        child: TransactionList(
          items: const [
            TransactionItemData(
              title: 'Salary',
              timeAndDate: '16:04 • 21 Sep 2025',
              category: 'Income',
              amount: '+ \$2,500.00',
              isIncome: true,
              iconAsset: AppImages.salary,
            ),
            TransactionItemData(
              title: 'Groceries',
              timeAndDate: '12:10 • 20 Sep 2025',
              category: 'Food',
              amount: '- \$87.40',
              isIncome: false,
              iconAsset: AppImages.food,
            ),
            TransactionItemData(
              title: 'Car Insurance',
              timeAndDate: '09:05 • 19 Sep 2025',
              category: 'Auto',
              amount: '- \$120.00',
              isIncome: false,
              iconAsset: AppImages.savingsCar,
            ),
            TransactionItemData(
              title: 'Freelance',
              timeAndDate: '18:22 • 17 Sep 2025',
              category: 'Income',
              amount: '+ \$610.00',
              isIncome: true,
              iconAsset: AppImages.income,
            ),
            TransactionItemData(
              title: 'Electricity Bill',
              timeAndDate: '08:10 • 15 Sep 2025',
              category: 'Utilities',
              amount: '- \$54.60',
              isIncome: false,
              iconAsset: AppImages.expense,
            ),
          ],
        ),
      ),
    );
  }
}
