import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/landing/pages/landing_page.dart';
import '../../features/team/pages/team_page.dart';
import '../../features/events/pages/events_page.dart';
import '../../features/news/pages/news_page.dart';
import '../../features/about/pages/about_page.dart';
import '../../features/contact/pages/contact_page.dart';
import '../../shared/widgets/app_scaffold.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const LandingPage(),
          ),
          GoRoute(
            path: '/team',
            builder: (context, state) => const TeamPage(),
          ),
          GoRoute(
            path: '/events',
            builder: (context, state) => const EventsPage(),
          ),
          GoRoute(
            path: '/news',
            builder: (context, state) => const NewsPage(),
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutPage(),
          ),
          GoRoute(
            path: '/contact',
            builder: (context, state) => const ContactPage(),
          ),
          GoRoute(
            path: '/tpo',
            builder: (context, state) => const PlaceholderPage(title: 'TPO'),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const PlaceholderPage(title: 'Login'),
      ),
    ],
  );
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '$title Page',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 