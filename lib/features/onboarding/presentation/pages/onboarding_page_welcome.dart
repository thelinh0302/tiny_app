import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_images.dart';

/// Onboarding - Page A (intro)
class OnboardingPageA extends StatelessWidget {
  const OnboardingPageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mainGreen.withOpacity(0.2),
                ),
              ),
              AppImages.image(AppImages.onboarding1, height: 270),
            ],
          ),
        ),

        AppSpacing.verticalSpaceXLarge,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSpacing.horizontalSpaceSmall,
            Text(
              'onboarding.swipeToNext'.tr(),
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: AppColors.mainGreen),
            ),
          ],
        ),
        AppSpacing.verticalSpaceXLarge,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: index == 0 ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    index == 0
                        ? AppColors.mainGreen
                        : AppColors.lightGrey.withOpacity(0.5),
                borderRadius: AppSpacing.borderRadiusSmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
