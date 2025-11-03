import 'package:flutter/foundation.dart';

/// Simple in-memory Auth Service (placeholder)
/// Replace with real implementation (API, secure storage) later.
class AuthService {
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(false);

  bool get isLoggedIn => _isLoggedIn.value;
  ValueListenable<bool> get isLoggedInListenable => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    // TODO: integrate real auth
    await Future.delayed(const Duration(milliseconds: 400));
    _isLoggedIn.value = true;
    return true;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isLoggedIn.value = false;
  }
}
