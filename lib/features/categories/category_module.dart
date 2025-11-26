import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/features/main/presentation/pages/main_shell_page.dart';

/// Category feature module.
///
/// Holds the main post-login dashboard (home) experience.
class CategoryModule extends Module {
  @override
  void routes(RouteManager r) {
    // /category -> main shell with bottom navigation
    r.child('/', child: (context) => const MainShellPage());
  }
}
