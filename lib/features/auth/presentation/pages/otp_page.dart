import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finly_app/core/widgets/app_alert.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/widgets/otp_code_input.dart';
import 'package:finly_app/features/auth/presentation/bloc/otp_bloc.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  final String fullName;
  final String email;
  final String mobile;
  final DateTime dob;
  final String password;

  const OtpPage({
    super.key,
    required this.verificationId,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.dob,
    required this.password,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onVerifyPressed(BuildContext context) {
    BlocProvider.of<OtpBloc>(context).add(
      OtpSubmitted(
        verificationId: _verificationId,
        code: _codeController.text,
        fullName: widget.fullName,
        email: widget.email,
        mobile: widget.mobile,
        dob: widget.dob,
        password: widget.password,
      ),
    );
  }

  void _onResendPressed(BuildContext context) {
    BlocProvider.of<OtpBloc>(context).add(OtpResendRequested(widget.mobile));
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.mobile.isNotEmpty ? widget.mobile : widget.email;

    return BlocProvider(
      create: (_) => Modular.get<OtpBloc>(),
      child: BlocListener<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state.status == OtpStatus.failure) {
            final msg = state.errorMessage ?? 'Error';
            // If the message looks like a localization key, translate it.
            final text = msg.startsWith('auth.') ? msg.tr() : msg;
            AppAlert.error(context, text);
          } else if (state.status == OtpStatus.success) {
            AppAlert.success(context, 'auth.otp.messages.verified'.tr());
            Modular.to.navigate('/auth/login');
          } else if (state.status == OtpStatus.resendSuccess) {
            if (state.verificationId != null) {
              setState(() => _verificationId = state.verificationId!);
            }
            AppAlert.success(context, 'auth.otp.messages.codeResent'.tr());
          }
        },
        child: MainLayout(
          topChild: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.horizontalMedium,
                  vertical: AppSpacing.verticalLarge,
                ),
                child: Text(
                  // Fallback to key text if translations are not yet added.
                  'auth.otp.title'.tr(args: const []),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (destination.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.horizontalMedium,
                  ),
                  child: Text(
                    'auth.otp.subtitle'.tr(
                      namedArgs: {'destination': destination},
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          enableContentScroll: true,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: BlocBuilder<OtpBloc, OtpState>(
                  builder: (context, state) {
                    final isLoading = state.status == OtpStatus.loading;
                    final isResendLoading =
                        state.status == OtpStatus.resendInProgress;

                    return Column(
                      children: [
                        AppSpacing.verticalSpaceXLarge,
                        Text(
                          'auth.otp.instructions'.tr(),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.darkGrey),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.verticalSpaceXLarge,
                        OtpCodeInput(
                          numberOfFields: 6,
                          onCodeChanged: (code) {
                            _codeController.text = code;
                          },
                          onSubmit: (value) {
                            _codeController.text = value;
                          },
                        ),
                        AppSpacing.verticalSpaceXLarge,
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: 'auth.otp.verify'.tr(),
                                isLoading: isLoading,
                                onPressed: () {
                                  if (!isLoading) {
                                    _onVerifyPressed(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.verticalSpaceLarge,
                        TextButton(
                          onPressed:
                              isResendLoading
                                  ? null
                                  : () => _onResendPressed(context),
                          child: Text('auth.otp.resend'.tr()),
                        ),
                        AppSpacing.verticalSpaceXLarge,
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
