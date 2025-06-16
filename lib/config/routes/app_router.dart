import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/landing/pages/landing_page.dart';
import '../../features/team/pages/team_page.dart';
import '../../features/events/pages/events_page.dart';
import '../../features/news/pages/news_page.dart';
import '../../features/about/pages/about_page.dart';
import '../../features/contact/pages/contact_page.dart';
import '../../features/tpo/pages/tpo_page.dart';
import '../../features/circle/pages/circle_page.dart';
import '../../features/messages/pages/messages_page.dart';
import '../../features/auth/pages/admin_login_page.dart';
import '../../features/admin/pages/admin_dashboard.dart';
import '../../features/admin/pages/admin_events_page.dart';
import '../../features/admin/pages/admin_team_page.dart';
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
            builder: (context, state) => const TpoPage(),
          ),
          GoRoute(
            path: '/circle',
            builder: (context, state) => const CirclePage(),
          ),
          GoRoute(
            path: '/messages',
            builder: (context, state) => const MessagesPage(),
          ),
        ],
      ),
      // Admin login route (standalone)
      GoRoute(
        path: '/admin/login',
        builder: (context, state) => const AdminLoginPage(),
      ),
      // Admin routes with nested layout
      ShellRoute(
        builder: (context, state, child) {
          return AdminDashboard(child: child);
        },
        routes: [
          GoRoute(
            path: '/admin',
            builder: (context, state) => const SizedBox.shrink(), // Empty widget, dashboard content handled by AdminDashboard
          ),
          GoRoute(
            path: '/admin/events',
            builder: (context, state) => const AdminEventsPage(),
          ),
          GoRoute(
            path: '/admin/team',
            builder: (context, state) => const AdminTeamPage(),
          ),
          GoRoute(
            path: '/admin/content',
            builder: (context, state) => const PlaceholderPage(title: 'Content Management'),
          ),
          GoRoute(
            path: '/admin/circle',
            builder: (context, state) => const PlaceholderPage(title: 'Circle Management'),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (context, state) => const PlaceholderPage(title: 'User Management'),
          ),
          GoRoute(
            path: '/admin/analytics',
            builder: (context, state) => const PlaceholderPage(title: 'Analytics'),
          ),
          GoRoute(
            path: '/admin/settings',
            builder: (context, state) => const PlaceholderPage(title: 'Settings'),
          ),
          GoRoute(
            path: '/admin/help',
            builder: (context, state) => const PlaceholderPage(title: 'Help'),
          ),
        ],
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
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.construction,
                  size: 64,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming Soon...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  'This feature is under development',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 