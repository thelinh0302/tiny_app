import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:finly_app/core/theme/app_colors.dart';

class OtpCodeInput extends StatelessWidget {
  final int numberOfFields;
  final ValueChanged<String>? onCodeChanged;
  final ValueChanged<String>? onSubmit;

  const OtpCodeInput({
    super.key,
    this.numberOfFields = 6,
    this.onCodeChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      numberOfFields: numberOfFields,
      keyboardType: TextInputType.number,
      showFieldAsBox: true,
      filled: true,
      fillColor: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      borderWidth: 1.5,
      enabledBorderColor: AppColors.darkGrey.withOpacity(0.2),
      focusedBorderColor: AppColors.mainGreen,
      textStyle: Theme.of(
        context,
      ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
      onCodeChanged: onCodeChanged,
      onSubmit: onSubmit,
    );
  }
}
