import 'package:finly_app/core/services/auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<bool> login(String email, String password);
  Future<bool> loginWithGoogle();
  Future<bool> loginWithFacebook();
  Future<bool> loginWithBiometrics();

  Future<bool> signup({
    required String fullName,
    required String email,
    required String mobile,
    required DateTime dob,
    required String password,
  });

  Future<bool> signupWithFirebaseToken({
    required String fullName,
    required String email,
    required String mobile,
    required DateTime dob,
    required String password,
    required String firebaseIdToken,
  });

  Future<bool> checkUserExists({required String email, required String mobile});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService authService;

  AuthRemoteDataSourceImpl({required this.authService});

  @override
  Future<bool> login(String email, String password) {
    return authService.login(email, password);
  }

  @override
  Future<bool> loginWithGoogle() {
    return authService.signInWithGoogle();
  }

  @override
  Future<bool> loginWithFacebook() {
    return authService.signInWithFacebook();
  }

  @override
  Future<bool> loginWithBiometrics() {
    return authService.signInWithBiometrics();
  }

  @override
  Future<bool> signup({
    required String fullName,
    required String email,
    required String mobile,
    required DateTime dob,
    required String password,
  }) {
    return authService.signup(
      fullName: fullName,
      email: email,
      mobile: mobile,
      dob: dob,
      password: password,
    );
  }

  @override
  Future<bool> signupWithFirebaseToken({
    required String fullName,
    required String email,
    required String mobile,
    required DateTime dob,
    required String password,
    required String firebaseIdToken,
  }) {
    return authService.signupWithFirebaseToken(
      fullName: fullName,
      email: email,
      mobile: mobile,
      dob: dob,
      password: password,
      firebaseIdToken: firebaseIdToken,
    );
  }

  @override
  Future<bool> checkUserExists({
    required String email,
    required String mobile,
  }) {
    return authService.checkUserExists(email: email, mobile: mobile);
  }
}
