import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:finly_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:finly_app/core/config/supabase_config.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:finly_app/core/network/dio_client.dart';

/// Auth Service
/// - Originally backed by Supabase Auth (email/password)
/// - Now uses HTTP API for signup via DioClient
/// - Maintains a ValueNotifier<bool> for route guards and UI
/// - Maps errors to app Exceptions
/// - Leaves login state unchanged on signup (to support email confirmation flows)
class AuthService {
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(false);
  final DioClient dioClient;
  StreamSubscription<AuthState>? _authSub;

  AuthService({required this.dioClient}) {
    // TODO: Remove Supabase usage once login & social auth are migrated to API
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
      // Call your HTTP API for signup using the shared DioClient.
      // Adjust the endpoint path and payload keys to match your backend.
      final response = await dioClient.post(
        '/auth/signup',
        data: <String, dynamic>{
          'fullName': fullName,
          'email': email,
          'mobile': mobile,
          'dob': dob.toIso8601String(),
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Do not change login state here; many projects require email confirmation.
        // The auth state listener (once fully migrated) or subsequent login will
        // update _isLoggedIn if a session is created.
        return true;
      } else {
        throw ServerException(
          'Failed to signup: ${response.statusCode ?? 'unknown status'}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        final message =
            e.response?.statusMessage ?? e.message ?? 'Failed to signup';
        throw ServerException(message);
      }
    } catch (e) {
      throw ServerException('Unexpected signup error: $e');
    }
  }

  Future<bool> signupWithFirebaseToken({
    required String fullName,
    required String email,
    required String mobile,
    required DateTime dob,
    required String password,
    required String firebaseIdToken,
  }) async {
    try {
      final response = await dioClient.post(
        '/auth/signup',
        data: <String, dynamic>{
          'fullName': fullName,
          'email': email,
          'mobile': mobile,
          'dob': dob.toIso8601String(),
          'password': password,
          'firebaseIdToken': firebaseIdToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ServerException(
          'Failed to signup: ${response.statusCode ?? 'unknown status'}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        final message =
            e.response?.statusMessage ?? e.message ?? 'Failed to signup';
        throw ServerException(message);
      }
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

  Future<bool> signInWithGoogle() async {
    try {
      final supa = Supabase.instance.client;

      final googleSignIn = GoogleSignIn(
        serverClientId: SupabaseConfig.googleWebClientId,
        // iOS requires explicit clientId (the iOS client ID from Google console).
        clientId: Platform.isIOS ? SupabaseConfig.googleIOSClientId : null,
        // scopes: const ['email', 'profile', 'openid'],
      );

      final account = await googleSignIn.signIn();
      if (account == null) {
        // User canceled the sign-in flow.
        throw ServerException('Google sign-in cancelled');
      }
      final auth = await account.authentication;

      final idToken = auth.idToken;
      final accessToken = auth.accessToken;

      if (idToken == null || idToken.isEmpty) {
        throw ServerException('Missing Google ID token');
      }

      final res = await supa.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final ok = res.session != null;
      _isLoggedIn.value = ok;
      return ok;
    } on AuthException catch (e) {
      print(e.message);
      throw ServerException(e.message);
    } on PlatformException catch (e) {
      print(e.message);
      throw ServerException(
        'Google Sign-In failed: ${e.code} ${e.message ?? ''}',
      );
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException {
      throw ServerException('Google sign-in timed out');
    } catch (e) {
      throw ServerException('Unexpected Google sign-in error: $e');
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      final supa = Supabase.instance.client;

      // 1) Trigger native Facebook login to obtain an access token
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: const ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) {
        if (result.status == LoginStatus.cancelled) {
          throw ServerException('Facebook sign-in cancelled');
        }
        final msg = result.message ?? 'Facebook sign-in failed';
        throw ServerException(msg);
      }

      final AccessToken? fbToken = result.accessToken;
      if (fbToken == null || fbToken.token.isEmpty) {
        throw ServerException('Missing Facebook access token');
      }

      // 2) Exchange Facebook access token for a Supabase session
      // Supabase supports native Facebook sign in using signInWithIdToken
      // by supplying the accessToken (idToken not used for Facebook).
      final res = await supa.auth.signInWithIdToken(
        provider: OAuthProvider.facebook,
        idToken: fbToken.token, // For Facebook, pass the access token here
      );

      final ok = res.session != null;
      _isLoggedIn.value = ok;
      return ok;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } on PlatformException catch (e) {
      throw ServerException(
        'Facebook Sign-In failed: ${e.code} ${e.message ?? ''}',
      );
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException {
      throw ServerException('Facebook sign-in timed out');
    } catch (e) {
      throw ServerException('Unexpected Facebook sign-in error: $e');
    }
  }

  Future<bool> signInWithBiometrics() async {
    try {
      final localAuth = LocalAuthentication();
      final isSupported = await localAuth.isDeviceSupported();
      final canCheck = await localAuth.canCheckBiometrics;

      if (!isSupported || !canCheck) {
        throw ServerException(
          'Biometric authentication not available on this device',
        );
      }

      final didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (!didAuthenticate) {
        throw ServerException('Biometric authentication failed or cancelled');
      }

      // Unlock only if there is an existing Supabase session.
      final supa = Supabase.instance.client;
      final ok = supa.auth.currentSession != null;
      if (!ok) {
        throw ServerException(
          'No active session found. Please login once to enable Face ID.',
        );
      }
      _isLoggedIn.value = ok;
      return ok;
    } on PlatformException catch (e) {
      throw ServerException('Biometric error: ${e.code} ${e.message ?? ''}');
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException('Unexpected biometric auth error: $e');
    }
  }

  // Optional cleanup if needed by your DI lifecycle.
  void dispose() {
    _authSub?.cancel();
  }
}
