import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

/// PhoneAuthService wraps Firebase Phone Authentication to:
/// - send OTP to a phone number and return the verificationId
/// - verify an OTP (smsCode) and return a Firebase ID Token
///
/// Note:
/// - You must initialize Firebase in main.dart before using this service.
/// - Ensure the provided phone number includes the country code (e.g., +84...).
class PhoneAuthService {
  final FirebaseAuth _auth;

  PhoneAuthService({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  /// Sends an OTP code to the given [phoneNumber] and resolves with verificationId
  /// when the code is sent. Throws if any Firebase auth error occurs.
  Future<String> sendCode(String phoneNumber) async {
    final completer = Completer<String>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        // On some Android devices, auto-verification can happen here.
        // We intentionally do not auto-sign-in; we want the user to input the OTP.
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(
            Exception(e.message ?? 'Phone verification failed'),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // If timeout fires but codeSent already completed, do nothing.
        if (!completer.isCompleted) {
          // Still provide verificationId; user can continue with manual input.
          completer.complete(verificationId);
        }
      },
    );

    return completer.future;
  }

  /// Verifies the [smsCode] with the provided [verificationId], signs in the user,
  /// and returns a fresh Firebase ID token (JWT).
  ///
  /// Optionally signs out from Firebase after fetching the token (default true)
  /// to avoid persisting Firebase auth state alongside other auth systems.
  Future<String> verifyAndGetIdToken({
    required String verificationId,
    required String smsCode,
    bool signOutAfter = true,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;
    if (user == null) {
      throw Exception('Failed to sign in with phone credential');
    }

    final idToken = await user.getIdToken(true);
    if (idToken == null) {
      throw Exception('Missing Firebase ID token');
    }
    if (idToken.isEmpty) {
      throw Exception('Empty Firebase ID token');
    }

    if (signOutAfter) {
      await _auth.signOut();
    }

    return idToken;
  }
}
