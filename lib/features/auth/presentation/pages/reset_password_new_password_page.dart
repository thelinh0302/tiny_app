import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/core/widgets/custom_text_field.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/app_alert.dart';
import 'package:finly_app/features/auth/presentation/bloc/reset_password_new_password_bloc.dart';
import 'package:finly_app/features/auth/presentation/utils/signup_error_texts.dart';

/// Final page of reset password flow:
/// - User inputs new password + confirm
/// - Bloc calls backend to actually change password
class ResetPasswordNewPasswordPage extends StatefulWidget {
  final String phone;
  final String firebaseIdToken;

  const ResetPasswordNewPasswordPage({
    super.key,
    required this.phone,
    required this.firebaseIdToken,
  });

  @override
  State<ResetPasswordNewPasswordPage> createState() =>
      _ResetPasswordNewPasswordPageState();
}

class _ResetPasswordNewPasswordPageState
    extends State<ResetPasswordNewPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Modular.get<ResetPasswordNewPasswordBloc>(),
      child: BlocListener<
        ResetPasswordNewPasswordBloc,
        ResetPasswordNewPasswordState
      >(
        listener: (context, state) {
          if (state.status == ResetPasswordNewPasswordStatus.failure) {
            final msg =
                state.errorMessage ??
                'auth.resetPassword.messages.verifyFailed';
            final text = msg.startsWith('auth.') ? msg.tr() : msg;
            AppAlert.error(context, text);
          } else if (state.status == ResetPasswordNewPasswordStatus.success) {
            AppAlert.success(
              context,
              'auth.resetPassword.messages.success'.tr(),
            );
            Modular.to.navigate('/auth/login');
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
                    'auth.resetPassword.verify.title'.tr(),
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
            child: BlocBuilder<
              ResetPasswordNewPasswordBloc,
              ResetPasswordNewPasswordState
            >(
              builder: (context, state) {
                final bloc = BlocProvider.of<ResetPasswordNewPasswordBloc>(
                  context,
                );
                final isLoading =
                    state.status == ResetPasswordNewPasswordStatus.loading;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSpacing.verticalSpaceXLarge,
                    // New password
                    CustomTextField(
                      labelText:
                          'auth.resetPassword.verify.newPasswordLabel'.tr(),
                      obscureText: true,
                      onChanged:
                          (v) => bloc.add(ResetPasswordNewPasswordChanged(v)),
                      errorText: passwordErrorText(state.password),
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    // Confirm password
                    CustomTextField(
                      labelText:
                          'auth.resetPassword.verify.confirmPasswordLabel'.tr(),
                      obscureText: true,
                      onChanged:
                          (v) => bloc.add(
                            ResetPasswordConfirmNewPasswordChanged(v),
                          ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted:
                          (_) => bloc.add(
                            ResetPasswordNewPasswordSubmitted(
                              phone: widget.phone,
                              firebaseIdToken: widget.firebaseIdToken,
                            ),
                          ),
                      errorText: confirmErrorText(state.confirmPassword),
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: 'auth.resetPassword.verify.submit'.tr(),
                            isLoading: isLoading,
                            onPressed:
                                () => bloc.add(
                                  ResetPasswordNewPasswordSubmitted(
                                    phone: widget.phone,
                                    firebaseIdToken: widget.firebaseIdToken,
                                  ),
                                ),
                          ),
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
