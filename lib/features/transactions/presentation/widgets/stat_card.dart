import 'package:flutter/material.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Reusable statistic card for the Transactions feature (Income/Expense).
class StatCard extends StatelessWidget {
  final Widget? iconWidget;
  final String label;
  final String amount;
  final VoidCallback? onTap;
  final bool selected;

  const StatCard({
    super.key,
    this.iconWidget,
    required this.label,
    required this.amount,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(AppSpacing.paddingMedium),
        decoration: BoxDecoration(
          color:
              selected
                  ? AppColors.brandBlue
                  : AppColors.white.withValues(alpha: 0.9),
          borderRadius: AppSpacing.borderRadiusXLarge,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: AnimatedScale(
          scale: selected ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingSmall),
                decoration: BoxDecoration(
                  borderRadius: AppSpacing.borderRadiusMedium,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: KeyedSubtree(
                    key: ValueKey<bool>(selected),
                    child: iconWidget ?? const SizedBox.shrink(),
                  ),
                ),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                style:
                    (textTheme.bodyMedium?.copyWith(
                      color: selected ? AppColors.white : AppColors.darkGrey,
                      fontWeight: FontWeight.w600,
                    )) ??
                    const TextStyle(),
                child: Text(label),
              ),
              AppSpacing.verticalSpaceSmall,
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                style:
                    (textTheme.titleLarge?.copyWith(
                      color: selected ? AppColors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    )) ??
                    const TextStyle(),
                child: Text(amount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
