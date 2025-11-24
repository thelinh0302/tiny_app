import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Circular savings progress with car icon + label.
/// Extracted from [SavingsGoalsCard] for reuse and clarity.
class SavingsGoalsProgress extends StatelessWidget {
  final double progress;
  final String savingsLabel;

  const SavingsGoalsProgress({
    super.key,
    required this.progress,
    required this.savingsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle & progress
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 3,
                  backgroundColor: AppColors.white,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF007BFF), // Accent blue similar to the mock
                  ),
                ),
              ),
              // Inner white circle with car icon (SVG asset)
              Center(
                child: AppImages.image(
                  AppImages.savingsCar,
                  width: 25,
                  height: 25,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.verticalSpaceSmall,
        Text(
          savingsLabel,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
