import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _NavBarState extends State<NavBar> {
  bool isMobileMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFDADCE0), width: 1), // neutral.200
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Mobile menu button
              if (MediaQuery.of(context).size.width < 768)
                IconButton(
                  onPressed: () {
                    setState(() {
                      isMobileMenuOpen = !isMobileMenuOpen;
                    });
                    _showMobileMenu(context);
                  },
                  icon: const Icon(Icons.menu),
                  color: const Color(0xFF5F6368), // neutral.700
                ),
              
              // Logo
              GestureDetector(
                onTap: () => context.go('/'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Image.asset(
                    'assets/images/gdg_logo.png',
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppConstants.googleBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.group,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(width: 32),
              
              // Desktop navigation links
              if (MediaQuery.of(context).size.width >= 768)
                Expanded(
                  child: Row(
                    children: [
                      _buildNavLink(context, 'Home', '/'),
                      _buildNavLink(context, 'About', '/about'),
                      _buildNavLink(context, 'Events', '/events'),
                      _buildNavLink(context, 'Team', '/team'),
                      _buildNavLink(context, 'News', '/news'),
                      _buildNavLink(context, 'Contact', '/contact'),
                    ],
                  ),
                ),
              
              // Spacer for mobile
              if (MediaQuery.of(context).size.width < 768)
                const Spacer(),
              
              // Login/Logout button
              _buildAuthButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(BuildContext context, String text, String route) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final isActive = currentRoute == route;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () => context.go(route),
        style: TextButton.styleFrom(
          backgroundColor: isActive 
            ? const Color(0xFFE8F0FE) // primary.50
            : Colors.transparent,
          foregroundColor: isActive 
            ? AppConstants.googleBlue // primary.500
            : const Color(0xFF5F6368), // neutral.700
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton(BuildContext context) {
    // For now, just show Login button
    // TODO: Replace with actual auth logic
    final bool isLoggedIn = false; // Replace with actual auth state
    
    if (isLoggedIn) {
      return OutlinedButton(
        onPressed: () {
          // TODO: Implement logout
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.googleBlue,
          side: const BorderSide(color: AppConstants.googleBlue),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text('Logout'),
      );
    } else {
      return ElevatedButton(
        onPressed: () => context.go('/admin/login'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.googleBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Admin Login',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with logo and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/gdg_logo.png',
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppConstants.googleBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.group,
                        color: Colors.white,
                        size: 24,
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: const Color(0xFF5F6368),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Navigation links
            _buildMobileNavLink(context, 'Home', '/'),
            _buildMobileNavLink(context, 'About', '/about'),
            _buildMobileNavLink(context, 'Events', '/events'),
            _buildMobileNavLink(context, 'Team', '/team'),
            _buildMobileNavLink(context, 'News', '/news'),
            _buildMobileNavLink(context, 'Contact', '/contact'),
            
            const SizedBox(height: 24),
            
            // Auth button
            SizedBox(
              width: double.infinity,
              child: _buildAuthButton(context),
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNavLink(BuildContext context, String text, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          context.go(route);
        },
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF5F6368),
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.centerLeft,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
} 