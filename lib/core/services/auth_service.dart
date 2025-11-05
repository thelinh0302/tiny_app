import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:finly_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth Service backed by Supabase Auth (email/password)
/// - Maintains a ValueNotifier<bool> for route guards and UI
/// - Maps Supabase errors to app Exceptions
/// - Leaves login state unchanged on signup (to support email confirmation flows)
class AuthService {
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(false);
  StreamSubscription<AuthState>? _authSub;

  AuthService() {
    final supa = Supabase.instance.client;
    // Initialize current login state
    _isLoggedIn.value = supa.auth.currentSession != null;

    // Keep state in sync with auth events
    _authSub = supa.auth.onAuthStateChange.listen((state) {
      _isLoggedIn.value = state.session != null;
    });
  }

  bool get isLoggedIn => _isLoggedIn.value;
  ValueListenable<bool> get isLoggedInListenable => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    try {
      final supa = Supabase.instance.client;
      final res = await supa.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final ok = res.session != null;
      _isLoggedIn.value = ok;
      return ok;
    } on AuthException catch (e) {
      // Supabase-specific auth error (invalid credentials, etc.)
      throw ServerException(e.message);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException('Unexpected auth error: $e');
    }
  }

  Future<bool> signup({
    required String fullName,
    required String email,
    required String mobile,
    required DateTime dob,
    required String password,
  }) async {
    try {
      final supa = Supabase.instance.client;
      // Store app-specific info in user_metadata.
      // Your DB trigger uses raw_user_meta_data->>'username' to create public.users.
      await supa.auth.signUp(
        email: email,
        password: password,
        data: <String, dynamic>{
          'username': fullName,
          'mobile': mobile,
          'dob': dob.toIso8601String(),
        },
      );

      // Do not change login state here; many projects require email confirmation.
      // The auth state listener will update _isLoggedIn if a session is created.
      return true;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException('Unexpected signup error: $e');
    }
  }

  Future<void> logout() async {
    try {
      final supa = Supabase.instance.client;
      await supa.auth.signOut();
      _isLoggedIn.value = false;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException('Unexpected logout error: $e');
    }
  }

  // Optional cleanup if needed by your DI lifecycle.
  void dispose() {
    _authSub?.cancel();
  }
}
