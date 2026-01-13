import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Progress + amount pill used in the dashboard header.
///
/// Renders a left pill with the percentage text and a right pill
/// with the monetary amount, similar to the provided design.
class HomeProgressBar extends StatelessWidget {
  const HomeProgressBar({
    super.key,
    required this.progress,
    required this.amountText,
    this.animationDuration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
  });

  /// Overall progress value between 0.0 and 1.0.
  final double progress;

  /// Display text for the monetary amount on the right side.
  final String amountText;

  /// Duration for the progress/percentage animation.
  final Duration animationDuration;

  /// Curve for the progress/percentage animation.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: clamped),
            duration: animationDuration,
            curve: curve,
            builder: (context, animated, _) {
              final percentage = (animated.clamp(0.0, 1.0) * 100).round();
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Background bar
                  Container(
                    height: 25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.mainGreen, width: 2),
                    ),
                  ),

                  // Progress fill (dark area on the left)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: animated <= 0 ? 0.001 : animated,
                      child: Container(
                        height: 25,
                        decoration: BoxDecoration(
                          color: AppColors.black.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),

                  // Text overlay: percentage on the left, amount on the right
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.horizontalMedium,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$percentage%',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          amountText,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
