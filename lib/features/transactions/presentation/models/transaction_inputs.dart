import 'package:formz/formz.dart';

// Name is required
enum TxnNameValidationError { empty }

class TxnNameInput extends FormzInput<String, TxnNameValidationError> {
  const TxnNameInput.pure() : super.pure('');
  const TxnNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  TxnNameValidationError? validator(String value) {
    if (value.trim().isEmpty) return TxnNameValidationError.empty;
    return null;
  }
}

// Category required
enum TxnCategoryValidationError { empty }

class TxnCategoryIdInput
    extends FormzInput<String?, TxnCategoryValidationError> {
  const TxnCategoryIdInput.pure() : super.pure(null);
  const TxnCategoryIdInput.dirty([String? value]) : super.dirty(value);

  @override
  TxnCategoryValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return TxnCategoryValidationError.empty;
    return null;
  }
}

// Amount in major unit (e.g., USD dollars or VND units) required > 0
enum TxnAmountValidationError { empty, invalid }

class TxnAmountInput extends FormzInput<double?, TxnAmountValidationError> {
  const TxnAmountInput.pure() : super.pure(null);
  const TxnAmountInput.dirty([double? value]) : super.dirty(value);

  @override
  TxnAmountValidationError? validator(double? value) {
    if (value == null) return TxnAmountValidationError.empty;
    if (value <= 0) return TxnAmountValidationError.invalid;
    return null;
  }
}

// Date required
enum TxnDateValidationError { empty }

class TxnDateInput extends FormzInput<DateTime?, TxnDateValidationError> {
  const TxnDateInput.pure() : super.pure(null);
  const TxnDateInput.dirty([DateTime? value]) : super.dirty(value);

  @override
  TxnDateValidationError? validator(DateTime? value) {
    if (value == null) return TxnDateValidationError.empty;
    return null;
  }
}

// Optional fields
class TxnNoteInput extends FormzInput<String?, Never> {
  const TxnNoteInput.pure() : super.pure(null);
  const TxnNoteInput.dirty([String? value]) : super.dirty(value);

  @override
  Never? validator(String? value) => null;
}

class TxnAttachmentUrlInput extends FormzInput<String?, Never> {
  const TxnAttachmentUrlInput.pure() : super.pure(null);
  const TxnAttachmentUrlInput.dirty([String? value]) : super.dirty(value);

  @override
  Never? validator(String? value) => null;
}
