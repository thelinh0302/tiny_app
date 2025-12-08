import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Reusable error + retry widget
/// Usage:
/// ErrorRetry(message: state.message, onRetry: () { /* dispatch event */ })
class ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String retryLabel;
  final MainAxisAlignment alignment;

  const ErrorRetry({
    super.key,
    required this.message,
    required this.onRetry,
    this.retryLabel = 'Retry',
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.errorColor),
        ),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: onRetry, child: Text(retryLabel)),
        AppSpacing.verticalSpaceSmall,
      ],
    );
  }
}
