import 'package:flutter/material.dart';

import 'package:finly_app/core/widgets/app_bottom_navigation.dart';
import 'package:finly_app/core/widgets/main_scaffold.dart';
import 'package:finly_app/features/dashboard/presentation/pages/home_page.dart';
import 'package:finly_app/features/categories/presentation/pages/categories_page.dart';
import 'package:finly_app/features/user/presentation/pages/transactions_page.dart';
import 'package:finly_app/features/user/presentation/pages/analytics_page.dart';
import 'package:finly_app/features/user/presentation/pages/profile_page.dart';

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
  int _currentIndex = 0;

  late final List<Widget> _pages = <Widget>[
    const HomePage(), // index 0 - home
    const AnalyticsPage(), // index 1 - analytics
    const TransactionsPage(), // index 2 - transactions
    const CategoriesPage(), // index 3 - categories
    const ProfilePage(), // index 4 - profile
    const _SettingsPlaceholderPage(), // index 5 - settings
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      // Let each tab/page manage its own app bar if needed.
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
      // Optional: if you want body to appear under the nav bar with transparency
      extendBody: true,
    );
  }
}

class _SettingsPlaceholderPage extends StatelessWidget {
  const _SettingsPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings - coming soon'));
  }
}
