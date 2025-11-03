import 'package:flutter/material.dart';

/// Main scaffold wrapper
/// Reusable scaffold with consistent structure
class MainScaffold extends StatelessWidget {
  final Widget? appBarTitle;
  final List<Widget>? appBarActions;
  final Widget body;
  final Widget? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;
  final bool extendBody;
  final Color? backgroundColor;

  const MainScaffold({
    super.key,
    this.appBarTitle,
    this.appBarActions,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.extendBody = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBarTitle != null || appBarActions != null
              ? AppBar(title: appBarTitle, actions: appBarActions)
              : null,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      extendBody: extendBody,
      backgroundColor: backgroundColor,
    );
  }
}
