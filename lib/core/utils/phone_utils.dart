class PhoneUtils {
  /// Normalize Vietnamese phone numbers to E.164 format (+84...).
  ///
  /// Examples:
  /// - "0399172329"   -> "+84399172329"
  /// - "+84399172329" -> "+84399172329" (unchanged)
  /// - "84999112233"  -> "+84999112233"
  /// - " 0399 172 329" -> "+84399172329"
  ///
  /// Any non-empty value that does not look like a VN local number is
  /// returned trimmed without modification.
  static String normalizeVietnamPhone(String input) {
    var value = input.trim();
    if (value.isEmpty) return value;

    // Remove spaces inside the number
    value = value.replaceAll(RegExp(r"\s+"), "");

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
}
