import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Result of formatting a money input string for the UI text controller
/// plus the numeric value parsed from the input (if any).
class AmountFormatResult {
  final TextEditingValue controllerValue;
  final double? parsedAmount;

  const AmountFormatResult({
    required this.controllerValue,
    required this.parsedAmount,
  });
}

/// Formats a raw money input string according to locale rules and
/// returns both the TextEditingValue to set on the controller and the
/// parsed numeric amount.
///
/// Supported locales:
/// - Vietnamese (vi_*): digits only, currency symbol ₫, no decimals
/// - Others (default): US style with $ and two decimals, with partial
///   input handling for trailing '.' and single decimal digit
AmountFormatResult formatAmountInput({
  required Locale locale,
  required String rawInput,
}) {
  final isVi = locale.languageCode.toLowerCase().startsWith('vi');

  // Vietnamese formatting: digits only, group + ₫, no decimals
  if (isVi) {
    final digits = rawInput.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const AmountFormatResult(
        controllerValue: TextEditingValue(text: ''),
        parsedAmount: null,
      );
    }

    final amount = int.tryParse(digits) ?? 0;

    final formatted = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    ).format(amount);

    return AmountFormatResult(
      controllerValue: TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      ),
      parsedAmount: amount.toDouble(),
    );
  }

  // Default (EN/US-like) formatting with decimals
  final cleaned = rawInput.replaceAll(RegExp(r'[^0-9.]'), '');

  // CASE A: empty
  if (cleaned.isEmpty) {
    return const AmountFormatResult(
      controllerValue: TextEditingValue(text: ''),
      parsedAmount: null,
    );
  }

  final parts = cleaned.split('.');

  // CASE B: user typing dot at the end → "5."
  if (cleaned.endsWith('.')) {
    final display = "${parts[0]}.";
    return AmountFormatResult(
      controllerValue: TextEditingValue(
        text: display,
        selection: TextSelection.collapsed(offset: display.length),
      ),
      parsedAmount: double.tryParse(parts[0]) ?? 0,
    );
  }

  // CASE C: decimals exist but not enough to format → "5.2"
  if (parts.length == 2 && parts[1].length < 2) {
    final display = cleaned; // keep raw input
    final asDouble = double.tryParse(display) ?? 0;
    return AmountFormatResult(
      controllerValue: TextEditingValue(
        text: display,
        selection: TextSelection.collapsed(offset: display.length),
      ),
      parsedAmount: asDouble,
    );
  }

  // CASE D: Safe to format: "5.20", "12.34", "50.00"
  String decimals = parts.length == 2 ? parts[1] : '00';
  if (decimals.length > 2) decimals = decimals.substring(0, 2);

  final amount = double.parse("${parts[0]}.$decimals");

  final formatted = NumberFormat.currency(
    locale: 'en_US',
    symbol: r'$',
    decimalDigits: 2,
  ).format(amount);

  final caretPos = formatted.length - 3; // before decimal part

  return AmountFormatResult(
    controllerValue: TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: caretPos),
    ),
    parsedAmount: amount,
  );
}
