import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:finly_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finly_app/core/utils/phone_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:finly_app/core/config/supabase_config.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:finly_app/core/network/dio_client.dart';
import 'package:finly_app/core/services/token_storage.dart';

/// Auth Service
/// - Originally backed by Supabase Auth (email/password)
/// - Now uses HTTP API for signup via DioClient
/// - Maintains a ValueNotifier<bool> for route guards and UI
/// - Maps errors to app Exceptions
/// - Leaves login state unchanged on signup (to support email confirmation flows)
class AuthService {
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(false);
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  StreamSubscription<AuthState>? _authSub;

  AuthService({required this.dioClient, required this.tokenStorage}) {
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

  Future<bool> login(String phone, String password) async {
    try {
      // Allow using a Vietnamese phone number (e.g. 0399...) as the login
      // identifier by normalizing it to E.164 (+84...) when applicable.
      final normalizedPhone = PhoneUtils.normalizeVietnamPhone(phone);
      // Call HTTP API login endpoint via DioClient
      final response = await dioClient.post(
        '/auth/login',
        data: <String, dynamic>{'phone': normalizedPhone, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final accessToken = data['accessToken'] as String?;
          final refreshToken = data['refreshToken'] as String?;
          final expireAt = data['expireAt'] as String?;

          if (accessToken == null || refreshToken == null || expireAt == null) {
            throw ServerException('Invalid login response from server');
          }

          await tokenStorage.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expireAt: expireAt,
          );

          _isLoggedIn.value = true;
          return true;
        } else {
          throw ServerException('Unexpected login response format');
        }
      } else {
        throw ServerException(
          'Failed to login: ${response.statusCode ?? 'unknown status'}',
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
            e.response?.statusMessage ?? e.message ?? 'Failed to login';
        throw ServerException(message);
      }
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
      // Normalize mobile phone to E.164 (+84...) before sending to backend
      final normalizedMobile = PhoneUtils.normalizeVietnamPhone(mobile);

      // Call your HTTP API for signup using the shared DioClient.
      // Adjust the endpoint path and payload keys to match your backend.
      final response = await dioClient.post(
        '/auth/signup',
        data: <String, dynamic>{
          'fullName': fullName,
          'email': email,
          'mobile': normalizedMobile,
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

  /// Check if a user already exists by email and phone.
  /// Calls `/auth/check-user-exists` with payload:
  /// { "email": "john@example.com", "phone": "+84123456789" }
  /// and expects a response: { "exists": false }.
  Future<bool> checkUserExists({
    required String email,
    required String mobile,
  }) async {
    try {
      final normalizedMobile = PhoneUtils.normalizeVietnamPhone(mobile);
      final response = await dioClient.post(
        '/auth/check-user-exists',
        data: <String, dynamic>{'email': email, 'phone': normalizedMobile},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final exists = data['exists'];
          if (exists is bool) return exists;
          throw ServerException('Invalid check-user-exists response');
        }
        throw ServerException('Unexpected check-user-exists response format');
      } else {
        throw ServerException(
          'Failed to check user exists: ${response.statusCode ?? 'unknown status'}',
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
            e.response?.statusMessage ??
            e.message ??
            'Failed to check user exists';
        throw ServerException(message);
      }
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException('Unexpected check-user-exists error: $e');
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
      // Normalize mobile phone to E.164 (+84...) before sending to backend
      final normalizedMobile = PhoneUtils.normalizeVietnamPhone(mobile);
      print(normalizedMobile);

      final response = await dioClient.post(
        '/auth/signup',
        data: <String, dynamic>{
          'fullName': fullName,
          'email': email,
          'mobile': normalizedMobile,
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
      print(e);
      throw ServerException('Unexpected signup error: $e');
    }
  }

  Future<bool> resetPasswordWithPhone({
    required String phone,
    required String newPassword,
    required String firebaseIdToken,
  }) async {
    try {
      final normalizedPhone = PhoneUtils.normalizeVietnamPhone(phone);

      final response = await dioClient.post(
        '/auth/reset-password/phone',
        data: <String, dynamic>{
          'phone': normalizedPhone,
          'newPassword': newPassword,
          'firebaseIdToken': firebaseIdToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ServerException(
          'Failed to reset password: ${response.statusCode ?? 'unknown status'}',
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
            e.response?.statusMessage ??
            e.message ??
            'Failed to reset password';
        throw ServerException(message);
      }
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException('Unexpected reset password error: $e');
    }
  }

  Future<void> logout() async {
    try {
      // Clear stored API tokens
      await tokenStorage.clearTokens();

      // Also sign out from Supabase (for social logins that still use it)
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
      // 1) Native Google sign-in to get OAuth tokens
      // Use default GoogleSignIn configuration so it reads client IDs
      // from GoogleService-Info.plist (iOS) and the platform-specific
      // configuration without overriding them with potentially mismatched
      // values.
      final googleSignIn = GoogleSignIn();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in flow.
        throw ServerException('Google sign-in cancelled');
      }

      final googleAuth = await googleUser.authentication;

      // 2) Sign in to Firebase with Google credential
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebaseAuth = fb.FirebaseAuth.instance;
      final userCred = await firebaseAuth.signInWithCredential(credential);
      final user = userCred.user;

      if (user == null) {
        throw ServerException('Failed to sign in with Google');
      }

      final firebaseIdToken = await user.getIdToken(true);
      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        throw ServerException('Missing Firebase ID token');
      }

      // Optionally sign out from Firebase to avoid persisting parallel auth state
      await firebaseAuth.signOut();

      // 3) Call backend API with Firebase ID token
      final response = await dioClient.post(
        '/auth/google/login',
        data: <String, dynamic>{'firebaseIdToken': firebaseIdToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final accessToken = data['accessToken'] as String?;
          final refreshToken = data['refreshToken'] as String?;
          final expireAt = data['expireAt'] as String?;

          if (accessToken == null || refreshToken == null || expireAt == null) {
            throw ServerException('Invalid Google login response from server');
          }

          await tokenStorage.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expireAt: expireAt,
          );

          _isLoggedIn.value = true;
          return true;
        } else {
          throw ServerException('Unexpected Google login response format');
        }
      } else {
        throw ServerException(
          'Failed to login with Google: ${response.statusCode ?? 'unknown status'}',
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
            e.response?.statusMessage ??
            e.message ??
            'Failed to login with Google';
        throw ServerException(message);
      }
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(
        e.message ?? 'Firebase auth error during Google sign-in',
      );
    } on PlatformException catch (e) {
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

      // Use stored refresh token to obtain a new access token via API
      final storedRefreshToken = await tokenStorage.getRefreshToken();
      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        throw ServerException(
          'No active session found. Please login once to enable Face ID.',
        );
      }

      final response = await dioClient.post(
        '/auth/refresh',
        data: <String, dynamic>{'refreshToken': storedRefreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final accessToken = data['accessToken'] as String?;
          final refreshToken = data['refreshToken'] as String?;
          final expireAt = data['expireAt'] as String?;

          if (accessToken == null || refreshToken == null || expireAt == null) {
            throw ServerException('Invalid refresh response from server');
          }

          await tokenStorage.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expireAt: expireAt,
          );

          _isLoggedIn.value = true;
          return true;
        } else {
          throw ServerException('Unexpected refresh response format');
        }
      } else {
        throw ServerException(
          'Failed to refresh session: ${response.statusCode ?? 'unknown status'}',
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
            e.response?.statusMessage ?? e.message ?? 'Failed to refresh';
        throw ServerException(message);
      }
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
