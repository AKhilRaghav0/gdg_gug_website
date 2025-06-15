import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/config/app_config.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppConstants.neutral200,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Logo
          GestureDetector(
            onTap: () => context.go('/'),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppConstants.googleBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.group,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'GDG GUG',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.googleBlue,
                      ),
                    ),
                    if (AppConfig.showEnvironmentBanner)
                      Text(
                        '${AppConfig.environment.name.toUpperCase()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.googleRed,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Navigation items
        _buildNavItem(context, 'Home', '/'),
        _buildNavItem(context, 'About', '/about'),
        _buildNavItem(context, 'Events', '/events'),
        _buildNavItem(context, 'News', '/news'),
        _buildNavItem(context, 'Team', '/team'),
        _buildNavItem(context, 'Contact', '/contact'),
        _buildNavItem(context, 'TPO', '/tpo'),
        
        const SizedBox(width: 16),
        
        // Action buttons
        _buildActionButton(context),
        
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route) {
    final isActive = GoRouterState.of(context).matchedLocation == route;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () => context.go(route),
        style: TextButton.styleFrom(
          foregroundColor: isActive ? AppConstants.googleBlue : AppConstants.neutral700,
          backgroundColor: isActive ? AppConstants.googleBlue.withOpacity(0.1) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppConstants.googleBlue : AppConstants.neutral700,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => context.go('/admin/login'),
      icon: const Icon(Icons.admin_panel_settings, size: 16),
      label: const Text('Admin'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.googleBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
    );
  }
} 