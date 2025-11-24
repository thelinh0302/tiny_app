import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/features/main/presentation/pages/main_shell_page.dart';

/// Dashboard feature module.
///
/// Holds the main post-login dashboard (home) experience.
class DashboardModule extends Module {
  @override
  void routes(RouteManager r) {
    // /dashboard -> main shell with bottom navigation
    r.child('/', child: (context) => const MainShellPage());
  }
}
