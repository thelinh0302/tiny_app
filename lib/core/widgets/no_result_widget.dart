import 'package:flutter/material.dart';

import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/constants/app_sizes.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Common reusable widget to display a "No Result" empty state
///
/// Defaults:
/// - Illustration: assets/images/no_result.svg
/// - Title: "No Result"
/// - Subtitle: "Sorry, there are no results for this search. Please try create another one"
///
/// You can optionally override title, subtitle, provide a custom action button,
/// or change illustration/size/padding as needed.
class NoResultWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String illustrationAsset;
  final double imageWidth;
  final double imageHeight;
  final EdgeInsetsGeometry padding;
  final Widget? action; // e.g., a button to create a new item or refresh
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const NoResultWidget({
    super.key,
    this.title = 'No Result',
    this.subtitle =
        'Sorry, there are no results for this search. Please try create another one',
    this.illustrationAsset = AppImages.noResult,
    this.imageWidth = AppSizes.imageLarge,
    this.imageHeight = AppSizes.imageLarge,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0),
    this.action,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            // Illustration
            AppImages.image(
              illustrationAsset,
              width: imageWidth,
              height: imageHeight,
              semanticsLabel: 'No Results Illustration',
            ),
            AppSpacing.verticalSpaceLarge,

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
            AppSpacing.verticalSpaceSmall,

            // Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
            ),

            // Optional action
            if (action != null) ...[AppSpacing.verticalSpaceLarge, action!],
          ],
        ),
      ),
    );
  }
}
