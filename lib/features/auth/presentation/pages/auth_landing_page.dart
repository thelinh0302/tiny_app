import 'package:easy_localization/easy_localization.dart';
import 'package:finly_app/core/constants/app_images.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthLandingPage extends StatelessWidget {
  const AuthLandingPage({super.key});

  void _goLogin() {
    Modular.to.navigate('/auth/login');
  }

  void _goSignup() {
    Modular.to.navigate('/auth/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalMedium,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  AppImages.image(AppImages.primaryLogo, height: 270),
                  Text(
                    'auth.landing.tagline'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.verticalSpaceLarge,

                  // Login / Sign up buttons
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: PrimaryButton(
                      text: 'auth.landing.login'.tr(),
                      onPressed: _goLogin,
                    ),
                  ),
                  AppSpacing.verticalSpaceSmall,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: OutlineButton(
                      text: 'auth.landing.signup'.tr(),
                      onPressed: _goSignup,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
