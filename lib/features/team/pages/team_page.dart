import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/widgets/responsive_wrapper.dart';
import '../../../core/constants/app_constants.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTeamGrid(context),
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
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Meet Our ',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.neutral900,
                    ),
                  ),
                  TextSpan(
                    text: 'Amazing Team',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.googleBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We make life easier for our community through reliable, affordable, and useful tech innovations',
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

  Widget _buildTeamGrid(BuildContext context) {
    final teamMembers = [
      TeamMember(
        name: 'Subham Singh',
        role: 'TECH LEAD',
        bio: 'Tech Lead at GDG GUG, passionate about building amazing developer experiences.',
        image: 'assets/images/team/subham.png',
        social: SocialLinks(
          linkedin: 'https://linkedin.com/in/subham-singh',
          twitter: 'https://twitter.com/subham_singh',
          github: 'https://github.com/subham-singh',
        ),
      ),
      TeamMember(
        name: 'Keshav',
        role: 'GDG HEAD',
        bio: 'Leading the Google Developer Group community at Gurugram University.',
        image: 'assets/images/team/keshav.png',
        social: SocialLinks(
          linkedin: 'https://linkedin.com/in/keshav',
          twitter: 'https://twitter.com/keshav',
          github: 'https://github.com/keshav',
        ),
      ),
      // Add more team members as needed
    ];

    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 32,
            mainAxisSpacing: 32,
            childAspectRatio: 0.8,
          ),
          itemCount: teamMembers.length,
          itemBuilder: (context, index) {
            return TeamMemberCard(member: teamMembers[index]);
          },
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatefulWidget {
  final TeamMember member;

  const TeamMemberCard({super.key, required this.member});

  @override
  State<TeamMemberCard> createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<TeamMemberCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, isHovered ? -8.0 : 0.0),
        child: Card(
          elevation: isHovered ? 12 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Header with gradient background
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.googleBlue.withOpacity(0.1),
                      AppConstants.googleRed.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              
              // Avatar positioned over the header
              Transform.translate(
                offset: const Offset(0, -50),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: AppConstants.googleBlue,
                    backgroundImage: AssetImage(widget.member.image),
                    onBackgroundImageError: (_, __) {},
                    child: widget.member.image.isEmpty 
                        ? Text(
                            widget.member.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      // Name and role
                      Text(
                        widget.member.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.member.role == 'TECH LEAD' 
                              ? AppConstants.googleRed.withOpacity(0.1)
                              : AppConstants.googleBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          widget.member.role,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: widget.member.role == 'TECH LEAD'
                                ? AppConstants.googleRed
                                : AppConstants.googleBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Bio
                      Expanded(
                        child: Text(
                          widget.member.bio,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Social links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            Icons.business,
                            widget.member.social.linkedin,
                            AppConstants.googleBlue,
                          ),
                          const SizedBox(width: 12),
                          _buildSocialButton(
                            Icons.alternate_email,
                            widget.member.social.twitter,
                            AppConstants.googleRed,
                          ),
                          const SizedBox(width: 12),
                          _buildSocialButton(
                            Icons.code,
                            widget.member.social.github,
                            AppConstants.neutral900,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String url, Color color) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class TeamMember {
  final String name;
  final String role;
  final String bio;
  final String image;
  final SocialLinks social;

  TeamMember({
    required this.name,
    required this.role,
    required this.bio,
    required this.image,
    required this.social,
  });
}

class SocialLinks {
  final String linkedin;
  final String twitter;
  final String github;

  SocialLinks({
    required this.linkedin,
    required this.twitter,
    required this.github,
  });
} 