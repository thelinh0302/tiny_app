import 'package:formz/formz.dart';

// Name is required and non-empty after trim
enum CategoryNameValidationError { empty }

class CategoryNameInput
    extends FormzInput<String, CategoryNameValidationError> {
  const CategoryNameInput.pure() : super.pure('');
  const CategoryNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  CategoryNameValidationError? validator(String value) {
    if (value.trim().isEmpty) return CategoryNameValidationError.empty;
    return null;
  }
}

// Type is required and must be either 'income' or 'expense'
enum CategoryTypeValidationError { empty, invalid }

class CategoryTypeInput
    extends FormzInput<String?, CategoryTypeValidationError> {
  const CategoryTypeInput.pure() : super.pure(null);
  const CategoryTypeInput.dirty([String? value]) : super.dirty(value);

  static const _allowed = {'income', 'expense'};

  @override
  CategoryTypeValidationError? validator(String? value) {
    if (value == null || value.isEmpty)
      return CategoryTypeValidationError.empty;
    if (!_allowed.contains(value)) return CategoryTypeValidationError.invalid;
    return null;
  }
}

// Icon URL is required and should be a non-empty string. We skip full URL validation for now.
enum CategoryIconValidationError { empty }

class CategoryIconInput
    extends FormzInput<String?, CategoryIconValidationError> {
  const CategoryIconInput.pure() : super.pure(null);
  const CategoryIconInput.dirty([String? value]) : super.dirty(value);

  @override
  CategoryIconValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty)
      return CategoryIconValidationError.empty;
    return null;
  }
}
