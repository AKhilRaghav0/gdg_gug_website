import 'package:flutter/material.dart';
import '../../../shared/widgets/responsive_wrapper.dart';
import '../../../core/constants/app_constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          _buildMissionSection(context),
          _buildValuesSection(context),
          _buildHistorySection(context),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            Text(
              'About GDG GUG',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Google Developer Group at Gurugram University is a community-driven initiative to foster learning, sharing, and collaboration among developers.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionSection(BuildContext context) {
    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Mission',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'To create an inclusive environment where developers can learn, grow, and innovate together. We believe in the power of community-driven learning and the importance of sharing knowledge to advance technology.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'We organize workshops, tech talks, hackathons, and networking events to help developers stay updated with the latest technologies and connect with like-minded individuals.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 80),
            Expanded(
              flex: 1,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.googleBlue.withOpacity(0.1),
                      AppConstants.googleGreen.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.groups,
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

  Widget _buildValuesSection(BuildContext context) {
    final values = [
      {
        'icon': Icons.diversity_1,
        'title': 'Inclusive Community',
        'description': 'We welcome developers of all skill levels and backgrounds.',
        'color': AppConstants.googleBlue,
      },
      {
        'icon': Icons.school,
        'title': 'Learning First',
        'description': 'Continuous learning and knowledge sharing is at our core.',
        'color': AppConstants.googleGreen,
      },
      {
        'icon': Icons.handshake,
        'title': 'Collaboration',
        'description': 'We believe in the power of working together to achieve more.',
        'color': AppConstants.googleRed,
      },
      {
        'icon': Icons.lightbulb,
        'title': 'Innovation',
        'description': 'We encourage creative thinking and innovative solutions.',
        'color': AppConstants.googleYellow,
      },
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            Text(
              'Our Values',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 32,
                mainAxisSpacing: 32,
                childAspectRatio: 1.2,
              ),
              itemCount: values.length,
              itemBuilder: (context, index) {
                final value = values[index];
                return Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: (value['color'] as Color).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (value['color'] as Color).withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (value['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          value['icon'] as IconData,
                          size: 32,
                          color: value['color'] as Color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        value['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        value['description'] as String,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Column(
          children: [
            Text(
              'Our Journey',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.googleRed.withOpacity(0.1),
                          AppConstants.googleYellow.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.timeline,
                        size: 120,
                        color: AppConstants.googleRed,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 80),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimelineItem(
                        context,
                        '2023',
                        'Founded',
                        'GDG GUG was established with a vision to create a thriving developer community at Gurugram University.',
                      ),
                      const SizedBox(height: 32),
                      _buildTimelineItem(
                        context,
                        '2023',
                        'First Event',
                        'Organized our first tech talk on Flutter development, attracting 50+ students and faculty members.',
                      ),
                      const SizedBox(height: 32),
                      _buildTimelineItem(
                        context,
                        '2024',
                        'Growing Community',
                        'Expanded to include regular workshops, hackathons, and study jams with 200+ active members.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String year, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppConstants.googleBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppConstants.googleBlue, width: 2),
          ),
          child: Center(
            child: Text(
              year,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.googleBlue,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 