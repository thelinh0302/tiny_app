import 'package:finly_app/core/models/country.dart';

class PhoneUtils {
  /// Generic phone normalization helper.
  ///
  /// Behaviour:
  /// - Trims and removes spaces from [input].
  /// - If the value already starts with "+", it is returned as-is
  ///   (assumed to already be in international / E.164 format).
  /// - If a [country] with a [Country.primaryDialCode] is provided,
  ///   the local number is normalized by:
  ///     - removing leading "0" (trunk prefix) when present, then
  ///     - prefixing with the country's primary dial code
  ///       (root + first suffix from RestCountries, e.g. "+963").
  /// - If [country] is null or has no dial code, we fall back to the
  ///   previous Vietnam-specific behaviour to keep backwards compatibility.
  static String normalizePhone({required String input, Country? country}) {
    var value = input.trim();
    if (value.isEmpty) return value;

    // Remove spaces inside the number
    value = value.replaceAll(RegExp(r"\\s+"), "");

    // Already looks like an international number => keep as-is
    if (value.startsWith('+')) {
      return value;
    }

    // If we know the country and its dialing code, build a dynamic E.164
    final dialCode = country?.primaryDialCode;
    if (dialCode != null && dialCode.isNotEmpty) {
      // Common trunk prefix rule: drop leading 0 for local-format numbers
      if (value.startsWith('0') && value.length > 1) {
        value = value.substring(1);
      }
      return '$dialCode$value';
    }

    // -------- Backwards-compatible Vietnam-specific fallback --------
    // Already in +84... form
    if (value.startsWith('+84')) {
      return value;
    }

    // Starts with 84 but missing the plus sign
    if (value.startsWith('84')) {
      return '+$value';
    }

    // Local VN mobile starting with 0 -> replace leading 0 with +84
    if (value.startsWith('0') && value.length > 1) {
      return '+84${value.substring(1)}';
    }

    // Fallback: return trimmed value as-is (could be email or other format)
    return value;
  }

  /// Deprecated name kept for compatibility with existing call sites.
  /// Delegates to [normalizePhone] without country context.
  static String normalizeVietnamPhone(String input) {
    return normalizePhone(input: input);
  }
}
