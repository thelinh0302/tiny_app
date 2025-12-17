import 'dart:async';
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

  static Future<void> _safePop(BuildContext context) async {
    // Try to pop using rootNavigator first, then fallback to local navigator.
    try {
      final rootNav = Navigator.of(context, rootNavigator: true);
      if (rootNav.canPop()) {
        rootNav.pop();
        return;
      }
    } catch (_) {}
    try {
      final nav = Navigator.of(context);
      if (nav.canPop()) {
        nav.pop();
      }
    } catch (_) {}
  }

  /// Shows a confirm/cancel dialog and, when confirmed, runs an async task.
  /// The dialog remains visible (shows a loading state) until the task completes,
  /// then it disappears and returns whether the task succeeded.
  static Future<bool?> confirmAsync(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool barrierDismissible = false,
    required Future<bool> Function() onConfirm,
  }) async {
    if (_isShowing) return null;
    _isShowing = true;

    final completer = Completer<bool?>();

    // Show confirmation dialog
    unawaited(
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: title,
        text: message,
        showCancelBtn: true,
        confirmBtnText: confirmText,
        cancelBtnText: cancelText,
        barrierDismissible: barrierDismissible,
        onCancelBtnTap: () async {
          await _safePop(context);
          if (!completer.isCompleted) completer.complete(null);
        },
        onConfirmBtnTap: () async {
          // Close confirm dialog first (if still mounted)
          await _safePop(context);
          // Show loading while running async task
          bool loadingOpen = false;
          unawaited(
            QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              title: 'Please wait',
              text: 'Processing...',
              barrierDismissible: false,
              showConfirmBtn: false,
            ),
          );
          // Ensure the loading route is actually pushed before we try to pop it later
          await Future.delayed(const Duration(milliseconds: 50));
          loadingOpen = true;

          bool ok = false;
          try {
            ok = await onConfirm();
          } finally {
            // Close loading dialog if it was opened
            if (loadingOpen) {
              await _safePop(context);
            }
            if (!completer.isCompleted) completer.complete(ok);
          }
        },
      ),
    );

    try {
      return await completer.future;
    } finally {
      _isShowing = false;
    }
  }
}
