import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import '../services/auth_service.dart';

/// Guard to protect private routes. Redirects to /auth/login if not authenticated.
class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth/login');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    final auth = Modular.get<AuthService>();

    // Fast-path: if we already know we're logged in in-memory, allow.
    if (auth.isLoggedIn) return true;

    // On hot restart / hard reload, in-memory state is lost. Try to
    // restore session from persisted tokens before deciding.
    final restored = await auth.restoreSessionFromStorage();
    return restored;
  }
}
