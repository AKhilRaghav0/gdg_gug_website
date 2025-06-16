import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class AdminDashboard extends StatefulWidget {
  final Widget? child;
  
  const AdminDashboard({super.key, this.child});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isCollapsed = false;
  String _currentRoute = '/admin';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get current route from GoRouterState
    _currentRoute = GoRouterState.of(context).matchedLocation;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    
    if (!isDesktop) {
      // Mobile layout - keep the existing mobile-friendly design
      return _buildMobileLayout(context);
    }
    
    // Desktop layout - new sidebar design
    return Scaffold(
      backgroundColor: AppConstants.neutral50,
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(context),
          // Main content area
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: widget.child ?? _buildDashboardContent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final sidebarWidth = _isCollapsed ? 80.0 : 280.0;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: sidebarWidth,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(color: AppConstants.neutral200, width: 1),
          ),
        ),
        child: Column(
          children: [
            // Logo and title
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppConstants.googleBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (!_isCollapsed) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Admin Panel',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppConstants.neutral900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
            
            // Navigation items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    route: '/admin',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.event,
                    title: 'Events',
                    route: '/admin/events',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.people,
                    title: 'Team',
                    route: '/admin/team',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.article,
                    title: 'Content',
                    route: '/admin/content',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.group,
                    title: 'Circle',
                    route: '/admin/circle',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.person,
                    title: 'Users',
                    route: '/admin/users',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.analytics,
                    title: 'Analytics',
                    route: '/admin/analytics',
                  ),
                  const SizedBox(height: 24),
                  if (!_isCollapsed)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'SETTINGS',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppConstants.neutral500,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  _buildNavItem(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    route: '/admin/settings',
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help',
                    route: '/admin/help',
                  ),
                ],
              ),
            ),
            
            // Collapse button and logout
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isCollapsed = !_isCollapsed;
                        });
                      },
                      icon: Icon(
                        _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                        size: 20,
                      ),
                      label: _isCollapsed 
                          ? const SizedBox.shrink()
                          : const Text('Collapse'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppConstants.neutral600,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout, size: 20),
                      label: _isCollapsed 
                          ? const SizedBox.shrink()
                          : const Text('Logout'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppConstants.googleRed,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isActive = _currentRoute == route;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.go(route);
            setState(() {
              _currentRoute = route;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? AppConstants.googleBlue.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(12),
              border: isActive 
                  ? Border.all(color: AppConstants.googleBlue.withOpacity(0.3))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive 
                      ? AppConstants.googleBlue 
                      : AppConstants.neutral600,
                ),
                if (!_isCollapsed) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive 
                            ? AppConstants.googleBlue 
                            : AppConstants.neutral700,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppConstants.neutral200, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getPageTitle(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.neutral900,
                    ),
                  ),
                  Text(
                    _getPageSubtitle(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            // Search bar
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.neutral50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppConstants.neutral200),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: AppConstants.neutral400),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppConstants.neutral400,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Notifications
            IconButton(
              onPressed: () {},
              icon: Stack(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: AppConstants.neutral600,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppConstants.googleRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // User avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.googleBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPageTitle() {
    switch (_currentRoute) {
      case '/admin':
        return 'Dashboard';
      case '/admin/events':
        return 'Events Management';
      case '/admin/team':
        return 'Team Management';
      case '/admin/content':
        return 'Content Management';
      case '/admin/circle':
        return 'Circle Management';
      case '/admin/users':
        return 'User Management';
      case '/admin/analytics':
        return 'Analytics';
      default:
        return 'Admin Panel';
    }
  }

  String _getPageSubtitle() {
    switch (_currentRoute) {
      case '/admin':
        return 'Overview of your GDG community';
      case '/admin/events':
        return 'Create and manage events';
      case '/admin/team':
        return 'Manage team members and roles';
      case '/admin/content':
        return 'Manage articles and content';
      case '/admin/circle':
        return 'Community circle management';
      case '/admin/users':
        return 'User accounts and permissions';
      case '/admin/analytics':
        return 'Insights and statistics';
      default:
        return 'GDG Gurugram University';
    }
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.neutral50,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                color: AppConstants.googleBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Admin Dashboard'),
          ],
        ),
        backgroundColor: AppConstants.googleBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: widget.child ?? _buildDashboardContent(context),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(context),
          const SizedBox(height: 32),
          
          // Stats Overview
          _buildStatsOverview(context),
          const SizedBox(height: 32),
          
          // Management Sections
          _buildManagementSection(context),
          const SizedBox(height: 32),
          
          // Quick Actions
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.googleBlue,
            AppConstants.googleBlue.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.googleBlue.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Admin!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your GDG community with powerful tools',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.go('/admin/events'),
                  icon: const Icon(Icons.add),
                  label: const Text('Quick Add Event'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppConstants.googleBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.dashboard,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(BuildContext context) {
    final stats = [
      {
        'title': 'Total Events',
        'value': '24',
        'change': '+3 this month',
        'icon': Icons.event,
        'color': AppConstants.googleBlue,
      },
      {
        'title': 'Team Members',
        'value': '47',
        'change': '+5 new members',
        'icon': Icons.people,
        'color': AppConstants.googleGreen,
      },
      {
        'title': 'Articles Published',
        'value': '18',
        'change': '+2 this week',
        'icon': Icons.article,
        'color': AppConstants.googleRed,
      },
      {
        'title': 'Active Users',
        'value': '156',
        'change': '+12% growth',
        'icon': Icons.trending_up,
        'color': AppConstants.googleYellow,
      },
    ];

    final isDesktop = MediaQuery.of(context).size.width > 1024;
    final crossAxisCount = isDesktop ? 4 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview Statistics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isDesktop ? 1.3 : 1.1,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.neutral900.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (stat['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          stat['icon'] as IconData,
                          color: stat['color'] as Color,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.more_vert,
                        color: AppConstants.neutral400,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    stat['value'] as String,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.neutral900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat['title'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstants.neutral600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stat['change'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.googleGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildManagementSection(BuildContext context) {
    final managementItems = [
      {
        'title': 'Events Management',
        'description': 'Create, edit, and manage community events',
        'icon': Icons.event,
        'color': AppConstants.googleBlue,
        'route': '/admin/events',
      },
      {
        'title': 'Team Management',
        'description': 'Manage team members and their roles',
        'icon': Icons.people,
        'color': AppConstants.googleGreen,
        'route': '/admin/team',
      },
      {
        'title': 'Content Management',
        'description': 'Manage articles, news, and content',
        'icon': Icons.article,
        'color': AppConstants.googleRed,
        'route': '/admin/content',
      },
      {
        'title': 'Circle Management',
        'description': 'Manage community discussions and posts',
        'icon': Icons.group,
        'color': AppConstants.googleYellow,
        'route': '/admin/circle',
      },
      {
        'title': 'User Management',
        'description': 'Manage user accounts and permissions',
        'icon': Icons.person,
        'color': AppConstants.googleBlue,
        'route': '/admin/users',
      },
      {
        'title': 'Analytics',
        'description': 'View insights and performance metrics',
        'icon': Icons.analytics,
        'color': AppConstants.googleGreen,
        'route': '/admin/analytics',
      },
    ];

    final isDesktop = MediaQuery.of(context).size.width > 1024;
    final crossAxisCount = isDesktop ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Management Tools',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isDesktop ? 1.4 : 1.2,
          ),
          itemCount: managementItems.length,
          itemBuilder: (context, index) {
            final item = managementItems[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.go(item['route'] as String),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.neutral900.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: item['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item['title'] as String,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppConstants.neutral900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['description'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.neutral600,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            'Manage',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: item['color'] as Color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            color: item['color'] as Color,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.neutral900.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickActionButton(
                context,
                'Add Event',
                Icons.add,
                AppConstants.googleBlue,
                () => context.go('/admin/events'),
              ),
              _buildQuickActionButton(
                context,
                'Add Member',
                Icons.person_add,
                AppConstants.googleGreen,
                () => context.go('/admin/team'),
              ),
              _buildQuickActionButton(
                context,
                'Create Post',
                Icons.post_add,
                AppConstants.googleRed,
                () => context.go('/admin/circle'),
              ),
              _buildQuickActionButton(
                context,
                'View Analytics',
                Icons.insights,
                AppConstants.googleYellow,
                () => context.go('/admin/analytics'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.googleRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
} 