import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/constants/app_spacing.dart';
import 'package:finly_app/core/theme/app_colors.dart';
import 'package:finly_app/core/widgets/custom_button.dart';
import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/core/services/phone_auth_service.dart';
import 'package:finly_app/features/auth/domain/usecases/signup_with_firebase_token.dart';

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
  bool _submitting = false;
  late String _verificationId;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
  }

  Future<void> _onVerifyPressed() async {
    if (_codeController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('auth.otp.messages.invalidCode'.tr())),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final phoneAuth = Modular.get<PhoneAuthService>();
      final idToken = await phoneAuth.verifyAndGetIdToken(
        verificationId: _verificationId,
        smsCode: _codeController.text,
      );

      final signupWithToken = Modular.get<SignupWithFirebaseToken>();
      final result = await signupWithToken(
        SignupWithFirebaseTokenParams(
          fullName: widget.fullName,
          email: widget.email,
          mobile: widget.mobile,
          dob: widget.dob,
          password: widget.password,
          firebaseIdToken: idToken,
        ),
      );

      result.fold(
        (failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        },
        (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('auth.otp.messages.verified'.tr())),
          );
          Modular.to.navigate('/auth/login');
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _onResendPressed() async {
    try {
      final phoneAuth = Modular.get<PhoneAuthService>();
      final newVerificationId = await phoneAuth.sendCode(widget.mobile);
      setState(() {
        _verificationId = newVerificationId;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('auth.otp.messages.codeResent'.tr())),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.mobile.isNotEmpty ? widget.mobile : widget.email;

    return MainLayout(
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
                'auth.otp.subtitle'.tr(namedArgs: {'destination': destination}),
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
            child: Column(
              children: [
                AppSpacing.verticalSpaceXLarge,
                Text(
                  'auth.otp.instructions'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.darkGrey),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalSpaceXLarge,
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '• • • • • •',
                    hintStyle: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(
                      color: AppColors.darkGrey.withOpacity(0.3),
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.darkGrey.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.mainGreen),
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceXLarge,
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'auth.otp.verify'.tr(),
                        isLoading: _submitting,
                        onPressed: _onVerifyPressed,
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalSpaceLarge,
                TextButton(
                  onPressed: _onResendPressed,
                  child: Text('auth.otp.resend'.tr()),
                ),
                AppSpacing.verticalSpaceXLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
