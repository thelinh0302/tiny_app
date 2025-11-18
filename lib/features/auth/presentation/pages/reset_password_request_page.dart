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
import 'package:finly_app/features/auth/presentation/bloc/reset_password_request_bloc.dart';
import 'package:finly_app/features/auth/presentation/models/login_inputs.dart';

class ResetPasswordRequestPage extends StatefulWidget {
  const ResetPasswordRequestPage({super.key});

  @override
  State<ResetPasswordRequestPage> createState() =>
      _ResetPasswordRequestPageState();
}

class _ResetPasswordRequestPageState extends State<ResetPasswordRequestPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Modular.get<ResetPasswordRequestBloc>(),
      child: BlocListener<ResetPasswordRequestBloc, ResetPasswordRequestState>(
        listener: (context, state) {
          if (state.status == ResetPasswordRequestStatus.failure) {
            final msg =
                state.errorMessage ??
                'auth.resetPassword.messages.requestFailed';
            final text = msg.startsWith('auth.') ? msg.tr() : msg;
            AppAlert.error(context, text);
          } else if (state.status == ResetPasswordRequestStatus.codeSent) {
            Modular.to.pushNamed(
              '/auth/reset-password/verify',
              arguments: {
                'phone': state.phone.value,
                'verificationId': state.verificationId,
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
                    'auth.resetPassword.request.title'.tr(),
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
              ResetPasswordRequestBloc,
              ResetPasswordRequestState
            >(
              builder: (context, state) {
                final bloc = BlocProvider.of<ResetPasswordRequestBloc>(context);
                final isLoading =
                    state.status == ResetPasswordRequestStatus.sendingCode;

                String? phoneError;
                if (state.phone.displayError != null) {
                  phoneError =
                      state.phone.displayError == PhoneValidationError.empty
                          ? 'auth.login.validation.phoneRequired'.tr()
                          : 'auth.login.validation.phoneInvalid'.tr();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSpacing.verticalSpaceXLarge,
                    CustomTextField(
                      labelText: 'auth.login.phoneNumber'.tr(),
                      keyboardType: TextInputType.phone,
                      onChanged: (v) => bloc.add(ResetPasswordPhoneChanged(v)),
                      errorText: phoneError,
                    ),
                    AppSpacing.verticalSpaceXLarge,
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: 'auth.resetPassword.request.submit'.tr(),
                            onPressed:
                                () => bloc.add(
                                  const ResetPasswordRequestSubmitted(),
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
