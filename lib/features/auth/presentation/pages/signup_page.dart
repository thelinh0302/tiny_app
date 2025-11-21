import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:finly_app/core/widgets/date_text_field.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/phone_text_field.dart';
import 'package:finly_app/features/auth/presentation/widgets/social_login_button.dart';
import 'package:finly_app/features/auth/presentation/widgets/terms_privacy_consent.dart';
import 'package:finly_app/core/widgets/app_alert.dart';

import 'package:finly_app/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:finly_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:finly_app/features/auth/presentation/utils/signup_error_texts.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Modular.get<SignupBloc>(),
      child: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.otpSent) {
            // Navigate to OTP input after code has been sent by Firebase
            Modular.to.navigate(
              '/auth/otp',
              arguments: {
                'verificationId': state.verificationId,
                'fullName': state.fullName.value,
                'email': state.email.value,
                'mobile': state.mobile.value,
                'dob': state.dob.value!.toIso8601String(),
                'password': state.password.value,
              },
            );
          } else if (state.status == SignupStatus.submissionFailure) {
            AppAlert.error(context, state.errorMessage ?? 'Error');
          }
        },
        child: MainLayout(
          topChild: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.horizontalMedium,
                  vertical: AppSpacing.verticalLarge,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'auth.landing.signup'.tr(),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          enableContentScroll: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                final bloc = BlocProvider.of<SignupBloc>(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSpacing.verticalSpaceXLarge,
                    // Full name
                    CustomTextField(
                      labelText: 'auth.signup.labels.fullName'.tr(),
                      hintText: 'auth.signup.placeholders.fullName'.tr(),
                      keyboardType: TextInputType.name,
                      onChanged: (v) => bloc.add(SignupFullNameChanged(v)),
                      errorText:
                          state.fullName.displayError != null
                              ? 'auth.signup.validation.fullNameRequired'.tr()
                              : null,
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    // Email
                    CustomTextField(
                      labelText: 'auth.signup.labels.email'.tr(),
                      hintText: 'auth.signup.placeholders.email'.tr(),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => bloc.add(SignupEmailChanged(v)),
                      errorText: emailErrorText(state.email),
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    // Mobile
                    PhoneTextField(
                      labelText: 'auth.signup.labels.mobile'.tr(),
                      hintText: 'auth.signup.placeholders.mobile'.tr(),
                      onChanged: (v) => bloc.add(SignupMobileChanged(v)),
                      errorText: mobileErrorText(state.mobile),
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    // DOB
                    DateTextField(
                      labelText: 'auth.signup.labels.dob'.tr(),
                      hintText: 'auth.signup.placeholders.dob'.tr(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      onDateChanged: (d) => bloc.add(SignupDobChanged(d)),
                      errorText: dobErrorText(state.dob),
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    // Password
                    CustomTextField(
                      labelText: 'auth.signup.labels.password'.tr(),
                      hintText: 'auth.signup.placeholders.password'.tr(),
                      obscureText: state.obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed:
                            () =>
                                bloc.add(const SignupPasswordObscureToggled()),
                      ),
                      onChanged: (v) => bloc.add(SignupPasswordChanged(v)),
                      errorText: passwordErrorText(state.password),
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    // Confirm Password
                    CustomTextField(
                      labelText: 'auth.signup.labels.confirmPassword'.tr(),
                      hintText: 'auth.signup.placeholders.confirmPassword'.tr(),
                      obscureText: state.obscureConfirm,
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.obscureConfirm
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed:
                            () => bloc.add(const SignupConfirmObscureToggled()),
                      ),
                      onChanged:
                          (v) => bloc.add(SignupConfirmPasswordChanged(v)),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted:
                          (_) => bloc.add(const SignupSubmitted()),
                      errorText: confirmErrorText(state.confirmPassword),
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    const TermsPrivacyConsent(),
                    AppSpacing.verticalSpaceXLarge,
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: 'auth.landing.signup'.tr(),
                            onPressed: () => bloc.add(const SignupSubmitted()),
                            isLoading: state.status == SignupStatus.otpSending,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    BlocProvider<LoginBloc>(
                      create: (_) => Modular.get<LoginBloc>(),
                      child: BlocListener<LoginBloc, LoginState>(
                        listener: (context, loginState) {
                          if (loginState.status ==
                              LoginStatus.submissionSuccess) {
                            Modular.to.navigate('/user/');
                          } else if (loginState.status ==
                              LoginStatus.submissionFailure) {
                            AppAlert.error(
                              context,
                              loginState.errorMessage ?? 'Login failed',
                            );
                          }
                        },
                        child: SocialLogin(
                          onGooglePressed: () {
                            BlocProvider.of<LoginBloc>(
                              context,
                            ).add(const LoginWithGooglePressed());
                          },
                          // onFacebookPressed: () {
                          //   BlocProvider.of<LoginBloc>(
                          //     context,
                          //   ).add(const LoginWithFacebookPressed());
                          // },
                        ),
                      ),
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'auth.login.noAccountPrefix'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.darkGrey),
                        ),
                        TextButton(
                          onPressed: () => Modular.to.navigate('/auth/login'),
                          child: Text('auth.landing.login'.tr()),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
