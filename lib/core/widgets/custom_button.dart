import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

/// Custom primary button
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.mainGreen,
        foregroundColor: AppColors.lettersAndIcons,
        minimumSize: AppSizes.buttonSizeMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
        ),
      ),
      child:
          isLoading
              ? SizedBox(
                height: AppSizes.loadingSmall,
                width: AppSizes.loadingSmall,
                child: const CircularProgressIndicator(
                  strokeWidth: AppSizes.borderWidthMedium,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
              : icon != null
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  AppSpacing.horizontalSpaceSmall,
                  Text(
                    text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
              : Text(
                text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }
}

/// Custom outline button
class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;

  const OutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.mainGreen,
        side: const BorderSide(
          color: AppColors.borderButtonPrimary,
          width: AppSizes.borderWidthThin,
        ),
        minimumSize: AppSizes.buttonSizeMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
        ),
      ),
      child:
          isLoading
              ? SizedBox(
                height: AppSizes.loadingSmall,
                width: AppSizes.loadingSmall,
                child: const CircularProgressIndicator(
                  strokeWidth: AppSizes.borderWidthMedium,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.mainGreen,
                  ),
                ),
              )
              : icon != null
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  AppSpacing.horizontalSpaceSmall,
                  Text(
                    text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
              : Text(
                text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }
}

/// Custom link button (text-style)
class LinkButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;

  const LinkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = AppColors.mainGreen;
    final TextStyle? labelStyle = Theme.of(context).textTheme.titleMedium
        ?.copyWith(color: activeColor, fontWeight: FontWeight.bold);

    return TextButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        // Link-like appearance: minimal padding and compact tap target
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: activeColor,
      ).copyWith(
        // Dim the color when disabled
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Theme.of(context).disabledColor;
          }
          return activeColor;
        }),
      ),
      child:
          isLoading
              ? SizedBox(
                height: AppSizes.loadingSmall,
                width: AppSizes.loadingSmall,
                child: const CircularProgressIndicator(
                  strokeWidth: AppSizes.borderWidthMedium,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.mainGreen,
                  ),
                ),
              )
              : icon != null
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon),
                  AppSpacing.horizontalSpaceSmall,
                  Text(text, style: labelStyle),
                ],
              )
              : Text(text, style: labelStyle),
    );
  }
}
