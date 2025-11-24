import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/filter_segmented_control.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/savings_goals_card.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/transaction_list.dart';

/// Center section of the home dashboard.
/// Shows the custom "Savings on Goals" widget card and time filter.
class HomeOverviewSection extends StatefulWidget {
  const HomeOverviewSection({super.key});

  @override
  State<HomeOverviewSection> createState() => _HomeOverviewSectionState();
}

class _HomeOverviewSectionState extends State<HomeOverviewSection> {
  String _selectedFilter = 'Daily';

  List<TransactionItemData> get _demoTransactions => const [
    TransactionItemData(
      title: 'Salary',
      timeAndDate: '18:27 - April 30',
      category: 'Monthly',
      amount: '4.000,00',
      isIncome: true,
      iconAsset: AppImages.salary,
    ),
    TransactionItemData(
      title: 'Groceries',
      timeAndDate: '17:00 - April 24',
      category: 'Pantry',
      amount: '-100,00',
      isIncome: false,
      iconAsset: AppImages.food,
    ),
    TransactionItemData(
      title: 'Rent',
      timeAndDate: '8:30 - April 15',
      category: 'Rent',
      amount: '-674,40',
      isIncome: false,
      iconAsset: AppImages.income,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.horizontalSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SavingsGoalsCard(),
          AppSpacing.verticalSpaceMedium,
          Center(
            // Time-range filter: Daily / Weekly / Monthly
            child: FilterSegmentedControl<String>(
              options: const ['Daily', 'Weekly', 'Monthly'],
              value: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value;
                });
              },
            ),
          ),
          AppSpacing.verticalSpaceLarge,
          TransactionList(items: _demoTransactions),
        ],
      ),
    );
  }
}
