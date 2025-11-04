import 'package:finly_app/core/services/auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<bool> login(String email, String password);

  Future<bool> signup({
    required String fullName,
    required String email,
    required String mobile,
    required DateTime dob,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService authService;

  AuthRemoteDataSourceImpl({required this.authService});

  @override
  Future<bool> login(String email, String password) {
    return authService.login(email, password);
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
}
