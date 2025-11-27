import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:finly_app/core/widgets/app_bottom_navigation.dart';
import 'package:finly_app/core/widgets/main_scaffold.dart';

/// Main "post-login" shell for the authenticated area.
///
/// This page is the root shell for the authenticated area and
/// coordinates the bottom navigation between Dashboard and
/// User-related pages.
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  late final VoidCallback _navListener;

  @override
  void initState() {
    super.initState();
    // Rebuild when route changes so bottom nav highlights correct tab.
    _navListener = () => setState(() {});
    Modular.to.addListener(_navListener);
    // Ensure default child when landing on /dashboard without a child route.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final path = Modular.to.path;
      if (path == '/dashboard' || path == '/dashboard/') {
        Modular.to.navigate('/dashboard/home');
      }
    });
  }

  @override
  void dispose() {
    Modular.to.removeListener(_navListener);
    super.dispose();
  }

  int _tabIndexFromPath(String path) {
    if (path.contains('/dashboard/analytics')) return 1;
    if (path.contains('/dashboard/transactions')) return 2;
    if (path.contains('/dashboard/category')) return 3;
    if (path.contains('/dashboard/profile')) return 4;
    if (path.contains('/dashboard/settings')) return 5;
    // default to home
    return 0;
  }

  void _onTabSelected(int index) {
    switch (index) {
      case 0:
        Modular.to.navigate('/dashboard/home');
        break;
      case 1:
        Modular.to.navigate('/dashboard/analytics');
        break;
      case 2:
        Modular.to.navigate('/dashboard/transactions');
        break;
      case 3:
        Modular.to.navigate('/dashboard/category/');
        break;
      case 4:
        Modular.to.navigate('/dashboard/profile');
        break;
      case 5:
        Modular.to.navigate('/dashboard/settings');
        break;
    }
    // Force immediate rebuild for visual feedback.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _tabIndexFromPath(Modular.to.path);
    return MainScaffold(
      // Body renders the current child route of this shell.
      body: const RouterOutlet(),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,
        onTap: _onTabSelected,
      ),
      // Optional: if you want body to appear under the nav bar with transparency
      extendBody: true,
    );
  }
}
