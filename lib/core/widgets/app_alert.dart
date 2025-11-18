import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

/// AppAlert wraps QuickAlert to provide a simple, reusable API
/// that replaces SnackBars across the app.
///
/// Default behavior mimics transient SnackBars: no confirm button
/// and auto close after a short duration.
class AppAlert {
  // Prevent multiple alerts from stacking on top of each other.
  static bool _isShowing = false;

  static Future<void> success(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 2),
    bool barrierDismissible = true,
  }) async {
    return _show(
      context,
      message,
      type: QuickAlertType.success,
      title: title,
      duration: duration,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> error(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    bool barrierDismissible = true,
  }) async {
    return _show(
      context,
      message,
      type: QuickAlertType.error,
      title: title,
      duration: duration,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> info(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 2),
    bool barrierDismissible = true,
  }) async {
    return _show(
      context,
      message,
      type: QuickAlertType.info,
      title: title,
      duration: duration,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> warning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    bool barrierDismissible = true,
  }) async {
    return _show(
      context,
      message,
      type: QuickAlertType.warning,
      title: title,
      duration: duration,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> _show(
    BuildContext context,
    String message, {
    required QuickAlertType type,
    String? title,
    Duration? duration,
    bool barrierDismissible = true,
  }) async {
    // If an alert is already visible, avoid showing another one on top.
    if (_isShowing) return;

    _isShowing = true;
    try {
      await QuickAlert.show(
        context: context,
        type: type,
        title: title,
        text: message,
        autoCloseDuration: duration,
        showConfirmBtn: false,
        barrierDismissible: barrierDismissible,
      );
    } finally {
      _isShowing = false;
    }
  }
}
