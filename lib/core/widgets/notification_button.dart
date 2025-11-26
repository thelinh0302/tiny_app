import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Reusable circular notification button used in AppBars.
class NotificationButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NotificationButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AppImages.image(
              AppImages.notification,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }
}
