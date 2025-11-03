import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/swipe_button.dart';
import '../../../../core/constants/app_images.dart';

/// Onboarding - Page B (CTA to login)
class OnboardingPageB extends StatelessWidget {
  final VoidCallback onGetStarted;

  const OnboardingPageB({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mainGreen.withOpacity(0.2),
                ),
              ),
              AppImages.image(AppImages.onboarding2, height: 320),
            ],
          ),
        ),
        AppSpacing.verticalSpaceXLarge,
        Align(
          alignment: Alignment.center,
          child: SwipeToActionButton(
            text: 'onboarding.getStarted'.tr(),
            onComplete: onGetStarted,
            width: MediaQuery.of(context).size.width * 0.5,
            knobColor: AppColors.mainGreen,
            backgroundColor: AppColors.white,
            borderColor: AppColors.borderButtonPrimary,
            textColor: AppColors.mainGreen,
            borderRadius: 30,
            padding: EdgeInsets.all(10),
          ),
        ),
      ],
    );
  }
}
