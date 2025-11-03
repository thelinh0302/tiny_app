import 'package:flutter_modular/flutter_modular.dart';
import 'core/network/dio_client.dart';
import 'features/user/user_module.dart';

/// Main application module using Flutter Modular
/// Following Modular Architecture and Dependency Inversion Principle
class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Core - Network
    i.addLazySingleton<DioClient>(() => DioClient());
  }

  @override
  void routes(RouteManager r) {
    // User feature module
    r.module('/', module: UserModule());
  }
}
