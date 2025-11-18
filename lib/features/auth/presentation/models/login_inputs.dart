import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

enum PhoneValidationError { empty, invalid }

enum PasswordValidationError { empty, tooShort }

class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([String value = '']) : super.dirty(value);

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  EmailValidationError? validator(String value) {
    if (value.trim().isEmpty) return EmailValidationError.empty;
    if (!_emailRegex.hasMatch(value.trim())) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}

/// Phone input used for login. We intentionally keep a separate type name
/// from [MobileInput] (signup) to avoid import name clashes.
class PhoneInput extends FormzInput<String, PhoneValidationError> {
  const PhoneInput.pure() : super.pure('');
  const PhoneInput.dirty([String value = '']) : super.dirty(value);

  static final _digits = RegExp(r'\d');

  @override
  PhoneValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return PhoneValidationError.empty;
    final digitsCount =
        trimmed.split('').where((c) => _digits.hasMatch(c)).length;
    if (digitsCount < 7) return PhoneValidationError.invalid;
    return null;
  }
}

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < 4) return PasswordValidationError.tooShort;
    return null;
  }
}
