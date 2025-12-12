import 'package:flutter/material.dart';

import 'package:finly_app/core/widgets/main_layout.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/home_header.dart';
import 'package:finly_app/features/dashboard/presentation/widgets/home_overview_section.dart';

/// Dashboard Home page shown after login.
/// Composition of layout + header + overview widgets.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      enableContentScroll: false,
      topChild: HomeHeader(),
      child: HomeOverviewSection(),
      useIntrinsicTopHeight: true,
    );
  }
}
