import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'navbar.dart';
import 'mobile_bottom_nav.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final currentRoute = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      appBar: isMobile ? null : const NavBar(),
      body: child,
      bottomNavigationBar: isMobile ? MobileBottomNav(currentRoute: currentRoute) : null,
    );
  }
} 