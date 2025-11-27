import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/features/main/presentation/pages/main_shell_page.dart';
import 'package:finly_app/features/dashboard/presentation/pages/home_page.dart';
import 'package:finly_app/features/user/presentation/pages/analytics_page.dart';
import 'package:finly_app/features/user/presentation/pages/transactions_page.dart';
import 'package:finly_app/features/user/presentation/pages/profile_page.dart';
import 'package:finly_app/features/user/presentation/pages/settings_page.dart';
import 'package:finly_app/features/categories/category_module.dart';

/// Dashboard feature module.
///
/// Holds the main post-login dashboard (home) experience.
class DashboardModule extends Module {
  @override
  void routes(RouteManager r) {
    // /dashboard -> main shell with bottom navigation and nested routes
    r.child(
      '/',
      child: (context) => const MainShellPage(),
      children: [
        ChildRoute('/home', child: (context) => const HomePage()),
        ChildRoute('/analytics', child: (context) => const AnalyticsPage()),
        ChildRoute(
          '/transactions',
          child: (context) => const TransactionsPage(),
        ),
        ModuleRoute('/category', module: CategoryModule()),
        ChildRoute('/profile', child: (context) => const ProfilePage()),
        ChildRoute('/settings', child: (context) => const SettingsPage()),
      ],
    );
  }
}
