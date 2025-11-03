import 'package:flutter_modular/flutter_modular.dart';
import 'presentation/pages/auth_landing_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/signup_page.dart';

/// AuthModule holds public auth-related routes: login, signup
class AuthModule extends Module {
  @override
  void routes(RouteManager r) {
    // /auth -> landing with login, signup, and social options
    r.child('/', child: (_) => const AuthLandingPage());
    // /auth/login
    r.child('/login', child: (_) => const LoginPage());
    // /auth/signup
    r.child('/signup', child: (_) => const SignupPage());
  }
}
