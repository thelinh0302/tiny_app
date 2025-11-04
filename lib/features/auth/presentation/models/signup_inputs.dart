import 'package:formz/formz.dart';

enum FullNameValidationError { empty }

enum MobileValidationError { empty, invalid }

enum DobValidationError { empty }

enum ConfirmedPasswordValidationError { empty, mismatch }

class FullNameInput extends FormzInput<String, FullNameValidationError> {
  const FullNameInput.pure() : super.pure('');
  const FullNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  FullNameValidationError? validator(String value) {
    if (value.trim().isEmpty) return FullNameValidationError.empty;
    return null;
  }
}

class MobileInput extends FormzInput<String, MobileValidationError> {
  const MobileInput.pure() : super.pure('');
  const MobileInput.dirty([String value = '']) : super.dirty(value);

  static final _digits = RegExp(r'\d');

  @override
  MobileValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return MobileValidationError.empty;
    final digitsCount =
        trimmed.split('').where((c) => _digits.hasMatch(c)).length;
    if (digitsCount < 7) return MobileValidationError.invalid;
    return null;
  }
}

class DobInput extends FormzInput<DateTime?, DobValidationError> {
  const DobInput.pure() : super.pure(null);
  const DobInput.dirty([DateTime? value]) : super.dirty(value);

  @override
  DobValidationError? validator(DateTime? value) {
    if (value == null) return DobValidationError.empty;
    return null;
  }
}

/// Confirmed password that compares against the original password.
class ConfirmedPasswordInput
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  final String password;

  const ConfirmedPasswordInput.pure({this.password = ''}) : super.pure('');

  const ConfirmedPasswordInput.dirty({
    required String value,
    required this.password,
  }) : super.dirty(value);

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ConfirmedPasswordValidationError.empty;
    if (value != password) return ConfirmedPasswordValidationError.mismatch;
    return null;
  }

  /// Helper to revalidate this input with a new password while keeping same value.
  ConfirmedPasswordInput revalidateWith({required String password}) {
    return ConfirmedPasswordInput.dirty(value: this.value, password: password);
  }
}
