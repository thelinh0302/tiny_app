import 'package:easy_localization/easy_localization.dart';
import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finly_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:finly_app/features/auth/presentation/models/login_inputs.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:finly_app/core/widgets/phone_text_field.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/features/auth/presentation/widgets/face_id_button.dart';
import 'package:finly_app/features/auth/presentation/widgets/social_login_button.dart';
import 'package:finly_app/core/widgets/app_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Managed by LoginBloc via Formz

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Modular.get<LoginBloc>(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.submissionSuccess) {
            Modular.to.navigate('/dashboard/home');
          } else if (state.status == LoginStatus.submissionFailure) {
            AppAlert.error(context, state.errorMessage ?? 'Login failed');
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
                    'auth.login.title'.tr(),
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
            child: BlocBuilder<LoginBloc, LoginState>(
              builder:
                  (context, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSpacing.verticalSpaceXLarge,
                      PhoneTextField(
                        labelText: 'auth.login.phoneNumber'.tr(),
                        hintText: 'auth.login.placeholders.phoneNumber'.tr(),
                        onChanged:
                            (v) => BlocProvider.of<LoginBloc>(
                              context,
                            ).add(LoginPhoneChanged(v)),
                        errorText:
                            state.phone.displayError != null
                                ? (state.phone.displayError ==
                                        PhoneValidationError.empty
                                    ? 'auth.login.validation.phoneRequired'.tr()
                                    : 'auth.login.validation.phoneInvalid'.tr())
                                : null,
                      ),
                      AppSpacing.verticalSpaceXLarge,
                      CustomTextField(
                        labelText: 'auth.login.password'.tr(),
                        hintText: 'auth.login.placeholders.password'.tr(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => BlocProvider.of<LoginBloc>(
                                context,
                              ).add(const LoginObscureToggled()),
                        ),
                        obscureText: state.obscure,
                        onChanged:
                            (v) => BlocProvider.of<LoginBloc>(
                              context,
                            ).add(LoginPasswordChanged(v)),
                        errorText:
                            state.password.displayError != null
                                ? (state.password.displayError ==
                                        PasswordValidationError.empty
                                    ? 'auth.login.validation.passwordRequired'
                                        .tr()
                                    : 'auth.login.validation.passwordTooShort'
                                        .tr())
                                : null,
                      ),
                      AppSpacing.verticalSpaceXLarge,
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'auth.landing.login'.tr(),
                              onPressed:
                                  () => BlocProvider.of<LoginBloc>(
                                    context,
                                  ).add(const LoginSubmitted()),
                              isLoading:
                                  state.status ==
                                  LoginStatus.submissionInProgress,
                            ),
                          ),
                          AppSpacing.horizontalSpaceMedium,
                          FaceIdButton(
                            onPressed: () {
                              BlocProvider.of<LoginBloc>(
                                context,
                              ).add(const LoginWithBiometricsPressed());
                            },
                          ),
                        ],
                      ),
                      AppSpacing.verticalSpaceXLarge,
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: LinkButton(
                          text: 'auth.login.forgotPassword'.tr(),
                          onPressed: () {
                            Modular.to.pushNamed(
                              '/auth/reset-password/request',
                            );
                          },
                        ),
                      ),

                      AppSpacing.verticalSpaceXLarge,
                      SocialLogin(
                        onGooglePressed: () {
                          BlocProvider.of<LoginBloc>(
                            context,
                          ).add(const LoginWithGooglePressed());
                        },
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
                            onPressed:
                                () => Modular.to.navigate('/auth/signup'),
                            child: Text('auth.landing.signup'.tr()),
                          ),
                        ],
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
