import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/responsive_wrapper.dart';
import '../../../core/constants/app_constants.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section
          _buildHeroSection(context),
          
          // Features Section
          _buildFeaturesSection(context),
          
          // CTA Section
          _buildCTASection(context),
          
          // Footer spacing
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Row(
          children: [
            // Left side - Text content
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'GDG ',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.googleBlue,
                          ),
                        ),
                        TextSpan(
                          text: 'Gurugram University',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.googleBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Join our vibrant community of developers, connect with Google Developer Experts, and explore the latest in technology.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.push('/events'),
                        child: const Text('Explore Events'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () => context.push('/team'),
                        child: const Text('Meet the Team'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 80),
            
            // Right side - Image
            Expanded(
              flex: 1,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.googleBlue.withOpacity(0.1),
                      AppConstants.googleRed.withOpacity(0.1),
                      AppConstants.googleYellow.withOpacity(0.1),
                      AppConstants.googleGreen.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.people,
                    size: 120,
                    color: AppConstants.googleBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      {
        'icon': Icons.mic,
        'title': 'Tech Talks',
        'description': 'Learn from industry experts and Google Developer Experts.',
        'color': AppConstants.googleBlue,
      },
      {
        'icon': Icons.network_check,
        'title': 'Networking',
        'description': 'Connect with like-minded developers and tech enthusiasts.',
        'color': AppConstants.googleRed,
      },
      {
        'icon': Icons.lightbulb,
        'title': 'Workshops',
        'description': 'Hands-on sessions to learn and practice new technologies.',
        'color': AppConstants.googleYellow,
      },
      {
        'icon': Icons.code,
        'title': 'Hackathons',
        'description': 'Collaborate and build innovative solutions together.',
        'color': AppConstants.googleGreen,
      },
    ];

    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            // Section Header
            Column(
              children: [
                Text(
                  'What We Offer',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Join our community and get access to exclusive events, workshops, and networking opportunities.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            
            const SizedBox(height: 64),
            
            // Features Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.2,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: (feature['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            feature['icon'] as IconData,
                            color: feature['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          feature['title'] as String,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          feature['description'] as String,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Container(
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppConstants.googleBlue,
                AppConstants.googleRed,
                AppConstants.googleYellow,
                AppConstants.googleGreen,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Text(
                'Ready to Join Our Community?',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Connect with fellow developers, attend exciting events, and grow your skills together.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.push('/events'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppConstants.googleBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Join Our Events'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () => context.push('/contact'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Contact Us'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
