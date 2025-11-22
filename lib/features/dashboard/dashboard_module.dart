import 'package:flutter_modular/flutter_modular.dart';

import 'presentation/pages/home_page.dart';

/// Dashboard feature module.
///
/// Holds the main post-login dashboard (home) experience.
class DashboardModule extends Module {
  @override
  void routes(RouteManager r) {
    // /dashboard -> dashboard home page
    r.child('/', child: (context) => const HomePage());
  }
}
