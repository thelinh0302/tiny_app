import 'package:easy_localization/easy_localization.dart';
import 'package:finly_app/features/auth/presentation/models/login_inputs.dart';
import 'package:finly_app/features/auth/presentation/models/signup_inputs.dart';

String? emailErrorText(EmailInput email) {
  if (email.displayError == null) return null;
  return email.displayError == EmailValidationError.empty
      ? 'auth.signup.validation.emailRequired'.tr()
      : 'auth.signup.validation.emailInvalid'.tr();
}

String? mobileErrorText(MobileInput mobile) {
  if (mobile.displayError == null) return null;
  return mobile.displayError == MobileValidationError.empty
      ? 'auth.signup.validation.mobileRequired'.tr()
      : 'auth.signup.validation.mobileInvalid'.tr();
}

String? dobErrorText(DobInput dob) {
  if (dob.displayError == null) return null;
  return 'auth.signup.validation.dobRequired'.tr();
}

String? passwordErrorText(PasswordInput password) {
  if (password.displayError == null) return null;
  return password.displayError == PasswordValidationError.empty
      ? 'auth.signup.validation.passwordRequired'.tr()
      : 'auth.signup.validation.passwordTooShort'.tr();
}

String? confirmErrorText(ConfirmedPasswordInput confirm) {
  if (confirm.displayError == null) return null;
  return confirm.displayError == ConfirmedPasswordValidationError.empty
      ? 'auth.signup.validation.confirmRequired'.tr()
      : 'auth.signup.validation.passwordsMismatch'.tr();
}
