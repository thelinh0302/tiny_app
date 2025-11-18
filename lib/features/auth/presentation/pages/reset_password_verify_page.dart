import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/app_alert.dart';
import 'package:finly_app/core/widgets/otp_code_input.dart';
import 'package:finly_app/features/auth/presentation/bloc/reset_password_verify_bloc.dart';

/// Page 2 of reset password flow (after phone input):
/// - User enters OTP only
/// - On success, navigates to new-password page with firebaseIdToken
class ResetPasswordVerifyPage extends StatefulWidget {
  final String phone;
  final String verificationId;

  const ResetPasswordVerifyPage({
    super.key,
    required this.phone,
    required this.verificationId,
  });

  @override
  State<ResetPasswordVerifyPage> createState() =>
      _ResetPasswordVerifyPageState();
}

class _ResetPasswordVerifyPageState extends State<ResetPasswordVerifyPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Modular.get<ResetPasswordVerifyBloc>(),
      child: BlocListener<ResetPasswordVerifyBloc, ResetPasswordVerifyState>(
        listener: (context, state) {
          if (state.status == ResetPasswordVerifyStatus.failure) {
            final msg = state.errorMessage ?? 'auth.otp.messages.invalidCode';
            final text = msg.startsWith('auth.') ? msg.tr() : msg;
            AppAlert.error(context, text);
          } else if (state.status == ResetPasswordVerifyStatus.success &&
              state.firebaseIdToken != null) {
            // OTP verified successfully -> go to new password page
            Modular.to.pushNamed(
              '/auth/reset-password/new-password',
              arguments: {
                'phone': widget.phone,
                'firebaseIdToken': state.firebaseIdToken,
              },
            );
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
                    'auth.otp.title'.tr(),
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
              ResetPasswordVerifyBloc,
              ResetPasswordVerifyState
            >(
              builder: (context, state) {
                final bloc = BlocProvider.of<ResetPasswordVerifyBloc>(context);
                final isLoading =
                    state.status == ResetPasswordVerifyStatus.loading;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSpacing.verticalSpaceXLarge,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'auth.otp.codeLabel'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AppSpacing.verticalSpaceMedium,
                    OtpCodeInput(
                      numberOfFields: 6,
                      onCodeChanged:
                          (v) => bloc.add(ResetPasswordCodeChanged(v)),
                      onSubmit: (v) => bloc.add(ResetPasswordCodeChanged(v)),
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: 'auth.resetPassword.verify.submit'.tr(),
                            onPressed:
                                () => bloc.add(
                                  ResetPasswordVerifySubmitted(
                                    phone: widget.phone,
                                    verificationId: widget.verificationId,
                                  ),
                                ),
                            isLoading: isLoading,
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
