import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:finly_app/core/theme/app_colors.dart';

/// Reusable consent text widget:
/// "By continuing, you agree to Terms of Use and Privacy Policy."
/// - Provides tap handlers for Terms/Privacy via callbacks.
/// - Defaults to showing SnackBars if callbacks are not provided.
class TermsPrivacyConsent extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const TermsPrivacyConsent({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.darkGrey),
          children: [
            TextSpan(text: 'auth.signup.consent.prefix'.tr()),
            TextSpan(
              text: 'auth.signup.consent.terms'.tr(),
              style: const TextStyle(
                color: AppColors.mainGreen,
                fontWeight: FontWeight.bold,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap =
                        onTermsTap ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'auth.signup.consent.openTerms'.tr(),
                              ),
                            ),
                          );
                        },
            ),
            TextSpan(text: 'auth.signup.consent.and'.tr()),
            TextSpan(
              text: 'auth.signup.consent.privacy'.tr(),
              style: const TextStyle(
                color: AppColors.mainGreen,
                fontWeight: FontWeight.bold,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap =
                        onPrivacyTap ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'auth.signup.consent.openPrivacy'.tr(),
                              ),
                            ),
                          );
                        },
            ),
            TextSpan(text: 'auth.signup.consent.suffix'.tr()),
          ],
        ),
      ),
    );
  }
}
