import 'package:finly_app/core/services/auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<bool> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService authService;

  AuthRemoteDataSourceImpl({required this.authService});

  @override
  Future<bool> login(String email, String password) {
    return authService.login(email, password);
  }
}
