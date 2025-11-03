import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/main_layout.dart';
import 'onboarding_page_welcome.dart';
import 'onboarding_page_confirm.dart';

/// Onboarding page with multiple slides
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _goToLogin() {
    Modular.to.navigate('/auth/');
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      topHeightRatio: 0.5,
      topChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Page indicator
          AppSpacing.verticalSpaceLarge,
          // Page headline text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalMedium,
                vertical: AppSpacing.verticalLarge,
              ),
              child: Text(
                _currentPage == 0
                    ? 'Welcome to Expense Manager'
                    : 'Are you ready to take control of your finaces?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      child: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics:
            _currentPage == 1
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
        children: [
          const OnboardingPageA(),
          OnboardingPageB(onGetStarted: _goToLogin),
        ],
      ),
    );
  }
}
