import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/savings_goals_card.dart';

/// Center section of the home dashboard.
/// Shows the custom "Savings on Goals" widget card.
class HomeOverviewSection extends StatelessWidget {
  const HomeOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.horizontalSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [SavingsGoalsCard()],
      ),
    );
  }
}
