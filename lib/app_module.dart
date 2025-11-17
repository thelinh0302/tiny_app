import 'package:flutter_modular/flutter_modular.dart';
import 'core/network/dio_client.dart';
import 'core/services/auth_service.dart';
import 'core/services/phone_auth_service.dart';
import 'core/guards/auth_guard.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/auth/auth_module.dart';
import 'features/user/user_module.dart';

/// Main application module using Flutter Modular
/// Following Modular Architecture and Dependency Inversion Principle
class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Core - Network
    i.addLazySingleton<DioClient>(() => DioClient());

    // Services
    i.addLazySingleton<AuthService>(
      () => AuthService(dioClient: i.get<DioClient>()),
    );
    i.addLazySingleton<PhoneAuthService>(() => PhoneAuthService());
  }

  @override
  void routes(RouteManager r) {
    // Public routes
    r.child('/', child: (context) => const OnboardingPage());
    r.module('/auth', module: AuthModule());

    // Private routes
    r.module('/user', module: UserModule(), guards: [AuthGuard()]);
  }
}
