import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/responsive_wrapper.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            const HeroSection(),
            // Features Section
            Container(
              color: const Color(0xFFF8F9FA), // neutral.50
              child: const FeaturesSection(),
            ),
            // CTA Section
            const CTASection(),
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1024) {
              // Desktop layout - side by side
              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildHeroContent(context),
                  ),
                  const SizedBox(width: 64),
                  Expanded(
                    flex: 1,
                    child: _buildHeroImage(),
                  ),
                ],
              );
            } else {
              // Mobile layout - stacked
              return Column(
                children: [
                  _buildHeroContent(context),
                  const SizedBox(height: 32),
                  _buildHeroImage(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF202124), // neutral.900
              height: 1.2,
            ),
            children: const [
              TextSpan(text: 'Welcome to '),
              TextSpan(
                text: 'GDG Gurugram University',
                style: TextStyle(color: AppConstants.googleBlue), // primary.600
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Join our vibrant community of developers, connect with Google Developer Experts, and explore the latest in technology.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF5F6368), // neutral.700
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.go('/events'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Explore Events'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.googleBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () => context.go('/team'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppConstants.googleBlue,
                side: const BorderSide(color: AppConstants.googleBlue),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Meet the Team'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 500),
      child: Image.asset(
        'assets/images/hero_image.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.image,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  static final List<FeatureItem> features = [
    FeatureItem(
      icon: Icons.mic,
      title: 'Tech Talks',
      description: 'Learn from industry experts and Google Developer Experts.',
      color: AppConstants.googleBlue, // primary.500
    ),
    FeatureItem(
      icon: Icons.network_wifi,
      title: 'Networking',
      description: 'Connect with like-minded developers and tech enthusiasts.',
      color: AppConstants.googleRed, // red.500
    ),
    FeatureItem(
      icon: Icons.lightbulb,
      title: 'Workshops',
      description: 'Hands-on sessions to learn and practice new technologies.',
      color: AppConstants.googleYellow, // yellow.600
    ),
    FeatureItem(
      icon: Icons.extension,
      title: 'Hackathons',
      description: 'Collaborate and build innovative solutions together.',
      color: AppConstants.googleGreen, // green.500
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 16),
        child: Column(
          children: [
            // Section header
            Column(
              children: [
                Text(
                  'What We Offer',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: const Color(0xFF202124), // neutral.900
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Text(
                    'Join our community and get access to exclusive events, workshops, and networking opportunities.',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF5F6368), // neutral.700
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Features grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth > 1200) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth > 768) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    return FeatureCard(feature: features[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  final FeatureItem feature;

  const FeatureCard({super.key, required this.feature});

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, isHovered ? -4.0 : 0.0),
        child: Card(
          elevation: isHovered ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.feature.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.feature.icon,
                    color: widget.feature.color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.feature.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF202124), // neutral.900
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.feature.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF5F6368), // neutral.700
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CTASection extends StatelessWidget {
  const CTASection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 16),
        child: Card(
          color: const Color(0xFFE8F0FE), // primary.50
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFC2D7FE)), // primary.100
          ),
          child: Container(
            padding: const EdgeInsets.all(48),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 768) {
                  // Desktop layout
                  return Row(
                    children: [
                      Expanded(
                        child: _buildCTAContent(context),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: _buildCTAImage(),
                      ),
                    ],
                  );
                } else {
                  // Mobile layout
                  return Column(
                    children: [
                      _buildCTAContent(context),
                      const SizedBox(height: 32),
                      _buildCTAImage(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCTAContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to Join Our Community?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: const Color(0xFF202124), // neutral.900
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Get involved with GDG Gurugram University and be part of an amazing tech community.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF5F6368), // neutral.700
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => context.go('/events'),
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Join Upcoming Events'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.googleBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCTAImage() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Image.asset(
        'assets/images/gdg_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.image,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
class FeatureItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
