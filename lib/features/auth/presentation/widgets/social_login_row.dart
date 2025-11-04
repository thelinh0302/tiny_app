import 'package:flutter/material.dart';
import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/features/auth/presentation/widgets/social_circle_button.dart';

class SocialLoginRow extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onFacebookPressed;
  final double buttonSize;
  final double iconSize;

  const SocialLoginRow({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
    this.buttonSize = 56,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialCircleButton(
          onPressed: onGooglePressed,
          size: buttonSize,
          child: AppImages.image(
            AppImages.google,
            width: iconSize,
            height: iconSize,
          ),
        ),
        AppSpacing.horizontalSpaceMedium,
        SocialCircleButton(
          onPressed: onFacebookPressed,
          size: buttonSize,
          child: AppImages.image(
            AppImages.facebook,
            width: iconSize,
            height: iconSize,
          ),
        ),
      ],
    );
  }
}
