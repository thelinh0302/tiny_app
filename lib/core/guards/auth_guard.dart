import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import '../services/auth_service.dart';

/// Guard to protect private routes. Redirects to /auth/login if not authenticated.
class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth/login');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) {
    final auth = Modular.get<AuthService>();
    return auth.isLoggedIn;
  }
}
