import 'package:flutter/material.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/constants/app_images.dart';

class FaceIdButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isDisabled;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color borderColor;

  const FaceIdButton({
    super.key,
    required this.onPressed,
    this.isDisabled = false,
    this.size = 56,
    this.iconSize = 38,
    this.backgroundColor = AppColors.white,
    this.borderColor = AppColors.borderButtonPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: BorderSide(color: borderColor),
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        fixedSize: Size(size, size),
      ),
      child: AppImages.image(
        AppImages.faceId,
        width: iconSize,
        height: iconSize,
      ),
    );
  }
}
