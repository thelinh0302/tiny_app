import 'package:easy_localization/easy_localization.dart';
import 'package:finly_app/core/widgets/dashboard_totals_overview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finly_app/features/analytics/presentation/bloc/analytics_summary_bloc.dart';
import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Top header for the dashboard home page.
/// Shows welcome title/subtitle on the left and notification icon on the right.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: welcome + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hi, Welcome Back'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.verticalSmall),
                  Text(
                    'Good morning',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            // Right side: notification icon
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppImages.image(
                  'assets/images/noti_icon.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ],
        ),
        BlocProvider<AnalyticsSummaryBloc>(
          create:
              (_) =>
                  Modular.get<AnalyticsSummaryBloc>()
                    ..add(const AnalyticsSummaryRequested()),
          child: BlocBuilder<AnalyticsSummaryBloc, AnalyticsSummaryState>(
            builder: (context, state) {
              if (state is AnalyticsSummaryLoadSuccess) {
                final s = state.summary;
                final balanceText = '\$' + s.balance.toStringAsFixed(2);
                final expenseText = '\$' + s.expenseTotal.toStringAsFixed(2);
                double progress = 0.0;
                final denom = (s.incomeTotal + s.expenseTotal);
                if (denom > 0) progress = (s.expenseTotal / denom).clamp(0, 1);
                final clamped = progress.clamp(0.0, 1.0);
                final percentage = (clamped * 100).round();
                return DashboardTotalsOverview(
                  totalBalanceTitle: 'Total Balance',
                  totalBalanceAmount: balanceText,
                  totalExpenseTitle: 'Total Expense',
                  totalExpenseAmount: expenseText,
                  progress: progress,
                  progressAmountText: expenseText,
                  subtitleText: '$percentage% of your expenses, looks good.',
                );
              }
              // Loading/Failure fallback
              return const DashboardTotalsOverview();
            },
          ),
        ),
      ],
    );
  }
}
