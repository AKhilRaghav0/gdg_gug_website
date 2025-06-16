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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppConstants.neutral900.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: _buildLogo(context, isMobile),
        actions: isMobile ? [
          _buildMobileMenu(context),
          const SizedBox(width: 8),
        ] : [
          // Desktop/Tablet Navigation items
          if (!isTablet) ...[
            _buildNavItem(context, 'Home', '/'),
            _buildNavItem(context, 'About', '/about'),
            _buildNavItem(context, 'Events', '/events'),
            _buildNavItem(context, 'News', '/news'),
            _buildNavItem(context, 'Team', '/team'),
            _buildNavItem(context, 'Contact', '/contact'),
            _buildNavItem(context, 'TPO', '/tpo'),
            _buildNavItem(context, 'Circle', '/circle'),
          ] else ...[
            // Tablet - show limited items
            _buildNavItem(context, 'Home', '/'),
            _buildNavItem(context, 'Events', '/events'),
            _buildNavItem(context, 'Circle', '/circle'),
            _buildTabletMenu(context),
          ],
          
          const SizedBox(width: 8),
          
          // Action buttons
          if (screenWidth > 950) _buildActionButton(context),
          
          const SizedBox(width: 8),
        ],
    ),
    );
  }

  Widget _buildLogo(BuildContext context, bool isMobile) {
    return GestureDetector(
      onTap: () => context.go('/'),
          child: Row(
        mainAxisSize: MainAxisSize.min,
            children: [
          Container(
            width: isMobile ? 32 : 40,
            height: isMobile ? 32 : 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/gdg_logo.png',
                fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppConstants.googleBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                    child: Icon(
                          Icons.group,
                          color: Colors.white,
                      size: isMobile ? 18 : 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
          SizedBox(width: isMobile ? 8 : 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
                    children: [
              Text(
                'GDG GUG',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.googleBlue,
                  fontSize: isMobile ? 18 : null,
                ),
              ),
              if (AppConfig.showEnvironmentBanner)
                Text(
                  '${AppConfig.environment.name.toUpperCase()}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.googleRed,
                    fontSize: isMobile ? 8 : 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppConstants.neutral300),
        ),
        child: const Icon(Icons.menu, color: AppConstants.neutral700),
      ),
      onSelected: (String route) => context.go(route),
      itemBuilder: (BuildContext context) => [
        _buildMobileMenuItem('Home', '/', Icons.home),
        _buildMobileMenuItem('About', '/about', Icons.info_outline),
        _buildMobileMenuItem('Events', '/events', Icons.event),
        _buildMobileMenuItem('News', '/news', Icons.article),
        _buildMobileMenuItem('Team', '/team', Icons.people),
        _buildMobileMenuItem('Contact', '/contact', Icons.contact_mail),
        _buildMobileMenuItem('TPO', '/tpo', Icons.work),
        _buildMobileMenuItem('Circle', '/circle', Icons.photo_camera),
      ],
    );
  }

  PopupMenuItem<String> _buildMobileMenuItem(String title, String route, IconData icon) {
    return PopupMenuItem<String>(
      value: route,
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppConstants.neutral600),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildTabletMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppConstants.neutral300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('More'),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ),
      ),
      onSelected: (String route) => context.go(route),
      itemBuilder: (BuildContext context) => [
        _buildMobileMenuItem('About', '/about', Icons.info_outline),
        _buildMobileMenuItem('News', '/news', Icons.article),
        _buildMobileMenuItem('Team', '/team', Icons.people),
        _buildMobileMenuItem('Contact', '/contact', Icons.contact_mail),
        _buildMobileMenuItem('TPO', '/tpo', Icons.work),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route) {
    final isActive = GoRouterState.of(context).matchedLocation == route;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: _NavItemWidget(
        title: title,
        route: route,
        isActive: isActive,
        ),
      );
    }

  Widget _buildActionButton(BuildContext context) {
    return _AdminButtonWidget();
  }
}

class _NavItemWidget extends StatefulWidget {
  final String title;
  final String route;
  final bool isActive;

  const _NavItemWidget({
    required this.title,
    required this.route,
    required this.isActive,
  });

  @override
  State<_NavItemWidget> createState() => _NavItemWidgetState();
}

class _NavItemWidgetState extends State<_NavItemWidget>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    if (widget.isActive) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(_NavItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isHovered ? _scaleAnimation.value : 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
                  mainAxisSize: MainAxisSize.min,
          children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: widget.isActive || _isHovered 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        color: widget.isActive 
                            ? AppConstants.googleBlue
                            : _isHovered 
                                ? AppConstants.googleBlue.withOpacity(0.8)
                                : AppConstants.neutral700,
                        fontSize: 14,
                      ),
                      child: Text(widget.title),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      width: widget.isActive 
                          ? widget.title.length * 8.0 
                          : _isHovered 
                              ? widget.title.length * 6.0 
                              : 0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.googleBlue,
                            AppConstants.googleRed,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                ),
              ],
            ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AdminButtonWidget extends StatefulWidget {
  @override
  State<_AdminButtonWidget> createState() => _AdminButtonWidgetState();
}

class _AdminButtonWidgetState extends State<_AdminButtonWidget>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _colorAnimation = ColorTween(
      begin: AppConstants.googleBlue,
      end: AppConstants.googleRed,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/admin/login'),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _colorAnimation.value ?? AppConstants.googleBlue,
                      (_colorAnimation.value ?? AppConstants.googleBlue).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: (_colorAnimation.value ?? AppConstants.googleBlue).withOpacity(0.3),
                      blurRadius: _isHovered ? 12 : 8,
                      offset: Offset(0, _isHovered ? 4 : 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Admin',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 