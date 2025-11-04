import 'package:flutter/material.dart';
import 'package:finly_app/core/theme/app_colors.dart';

class SocialCircleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;

  const SocialCircleButton({
    super.key,
    required this.onPressed,
    required this.size,
    required this.child,
    this.backgroundColor = AppColors.white,
    this.borderColor = AppColors.borderButtonPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: BorderSide(color: borderColor),
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        fixedSize: Size(size, size),
      ),
      child: child,
    );
  }
}
