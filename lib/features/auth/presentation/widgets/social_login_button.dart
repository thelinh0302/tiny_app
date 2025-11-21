import 'package:flutter/material.dart';
import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

class SocialLogin extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final double buttonSize;
  final double iconSize;

  const SocialLogin({
    super.key,
    required this.onGooglePressed,
    this.buttonSize = 56,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialCircleButton(
          onPressed: onGooglePressed,
          size: buttonSize,
          child: AppImages.image(
            AppImages.google,
            width: iconSize,
            height: iconSize,
          ),
        ),
        // AppSpacing.horizontalSpaceMedium,
        // _SocialCircleButton(
        //   onPressed: onFacebookPressed,
        //   size: buttonSize,
        //   child: AppImages.image(
        //     AppImages.facebook,
        //     width: iconSize,
        //     height: iconSize,
        //   ),
        // ),
      ],
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  final Widget child;

  const _SocialCircleButton({
    required this.onPressed,
    required this.size,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: const BorderSide(color: AppColors.borderButtonPrimary),
        padding: EdgeInsets.zero,
        backgroundColor: AppColors.white,
        fixedSize: Size(size, size),
      ),
      child: child,
    );
  }
}
