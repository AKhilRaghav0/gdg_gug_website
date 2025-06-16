import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/widgets/responsive_wrapper.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/team_member.dart';
import '../../admin/providers/admin_provider.dart';

class TeamPage extends ConsumerWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamMembersAsync = ref.watch(activeTeamMembersStreamProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          teamMembersAsync.when(
            data: (teamMembers) => _buildTeamGrid(context, teamMembers),
            loading: () => _buildLoadingState(),
            error: (error, stack) => _buildErrorState(context, error.toString()),
          ),
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

  Widget _buildTeamGrid(BuildContext context, List<TeamMember> teamMembers) {
    if (teamMembers.isEmpty) {
      return _buildEmptyState(context);
    }

    // Group team members by role
    final Map<String, List<TeamMember>> teamsByRole = {};
    for (final member in teamMembers) {
      final role = member.role;
      if (!teamsByRole.containsKey(role)) {
        teamsByRole[role] = [];
      }
      teamsByRole[role]!.add(member);
    }

    // Define role order for better organization
    final roleOrder = [
      'GDG Head',
      'Lead Organizer', 
      'Tech Lead',
      'Technical Lead',
      'Core Team',
      'Social Media/Content Team',
      'Marketing Lead',
      'Design Team',
    ];

    // Sort roles according to the defined order
    final sortedRoles = teamsByRole.keys.toList()
      ..sort((a, b) {
        final indexA = roleOrder.indexOf(a);
        final indexB = roleOrder.indexOf(b);
        
        if (indexA == -1 && indexB == -1) return a.compareTo(b);
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;
        
        return indexA.compareTo(indexB);
      });

    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < sortedRoles.length; i++) ...[
              _buildRoleSection(context, sortedRoles[i], teamsByRole[sortedRoles[i]]!),
              if (i < sortedRoles.length - 1) const SizedBox(height: 64),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSection(BuildContext context, String role, List<TeamMember> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Role title with member count
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getRoleSectionColor(role).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _getRoleSectionColor(role).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getRoleIcon(role),
                    size: 20,
                    color: _getRoleSectionColor(role),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    role,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getRoleSectionColor(role),
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppConstants.neutral200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${members.length} ${members.length == 1 ? 'member' : 'members'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.neutral600,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Members grid for this role
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 3;
            if (constraints.maxWidth < 768) {
              crossAxisCount = 1;
            } else if (constraints.maxWidth < 1024) {
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
              itemCount: members.length,
              itemBuilder: (context, index) {
                return TeamMemberCard(member: members[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppConstants.googleBlue),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.googleRed,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading team members',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppConstants.googleRed,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.neutral600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppConstants.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              'No team members found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppConstants.neutral600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleSectionColor(String role) {
    switch (role.toLowerCase()) {
      case 'gdg head':
      case 'lead organizer':
        return const Color(0xFF388E3C); // Material Green
      case 'tech lead':
      case 'technical lead':
        return const Color(0xFF1976D2); // Material Blue
      case 'core team':
        return const Color(0xFF7B1FA2); // Material Purple
      case 'social media/content team':
      case 'marketing lead':
        return const Color(0xFFF57C00); // Material Orange
      case 'design team':
        return const Color(0xFFE91E63); // Material Pink
      default:
        return const Color(0xFF455A64); // Blue Grey
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'gdg head':
      case 'lead organizer':
        return Icons.star_rounded;
      case 'tech lead':
      case 'technical lead':
        return Icons.code_rounded;
      case 'core team':
        return Icons.group_rounded;
      case 'social media/content team':
      case 'marketing lead':
        return Icons.campaign_rounded;
      case 'design team':
        return Icons.palette_rounded;
      default:
        return Icons.person_rounded;
    }
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..translate(0.0, isHovered ? -12.0 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isHovered ? AppConstants.googleBlue.withOpacity(0.3) : AppConstants.neutral100,
              width: isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovered 
                    ? AppConstants.googleBlue.withOpacity(0.15)
                    : AppConstants.neutral900.withOpacity(0.08),
                offset: Offset(0, isHovered ? 20 : 8),
                blurRadius: isHovered ? 40 : 24,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: isHovered 
                    ? AppConstants.googleBlue.withOpacity(0.08)
                    : AppConstants.neutral900.withOpacity(0.04),
                offset: Offset(0, isHovered ? 4 : 2),
                blurRadius: isHovered ? 8 : 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              // Header section with background pattern
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: _getRoleColor(widget.member.role).withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  children: [
                    // Subtle pattern overlay
                    Positioned.fill(
                      child: CustomPaint(
                        painter: PatternPainter(
                          color: _getRoleColor(widget.member.role).withOpacity(0.03),
                        ),
                      ),
                    ),
                    // Role badge positioned at top right
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getRoleColor(widget.member.role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getRoleColor(widget.member.role).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.member.role.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getRoleColor(widget.member.role),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Profile section with overlapping avatar
              Transform.translate(
                offset: const Offset(0, -45),
                child: Column(
                  children: [
                    // Avatar with status indicator
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.neutral900.withOpacity(0.1),
                                offset: const Offset(0, 8),
                                blurRadius: 24,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: _getRoleColor(widget.member.role).withOpacity(0.1),
                            backgroundImage: widget.member.imageUrl != null 
                                ? NetworkImage(widget.member.imageUrl!)
                                : null,
                            child: widget.member.imageUrl == null || widget.member.imageUrl!.isEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _getRoleColor(widget.member.role).withOpacity(0.1),
                                    ),
                                    child: Text(
                                      widget.member.name.substring(0, 1).toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: _getRoleColor(widget.member.role),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        // Active status indicator
                        if (widget.member.isActive)
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppConstants.googleGreen,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppConstants.googleGreen.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Name and position
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            widget.member.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppConstants.neutral900,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 4),
                          
                          if (widget.member.position.isNotEmpty)
                            Text(
                              widget.member.position,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: _getRoleColor(widget.member.role),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      // Bio
                      Expanded(
                        child: Text(
                          widget.member.bio,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            color: AppConstants.neutral600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Divider
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppConstants.neutral200,
                          borderRadius: BorderRadius.circular(0.5),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Social links with improved design
                      _buildSocialLinks(),
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

  Widget _buildSocialLinks() {
    final socialLinks = <Widget>[];
    
    if (widget.member.linkedinUrl != null && widget.member.linkedinUrl!.isNotEmpty) {
      socialLinks.add(_buildSocialButton(
        Icons.business_rounded,
        widget.member.linkedinUrl!,
        const Color(0xFF0077B5), // LinkedIn blue
      ));
    }
    
    if (widget.member.twitterUrl != null && widget.member.twitterUrl!.isNotEmpty) {
      socialLinks.add(_buildSocialButton(
        Icons.alternate_email_rounded,
        widget.member.twitterUrl!,
        const Color(0xFF1DA1F2), // Twitter blue
      ));
    }
    
    if (widget.member.githubUrl != null && widget.member.githubUrl!.isNotEmpty) {
      socialLinks.add(_buildSocialButton(
        Icons.code_rounded,
        widget.member.githubUrl!,
        const Color(0xFF333333), // GitHub dark
      ));
    }

    if (socialLinks.isEmpty) {
      return Container(
        height: 40,
        child: Center(
          child: Text(
            '${widget.member.email}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppConstants.neutral500,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: socialLinks
          .expand((widget) => [widget, const SizedBox(width: 12)])
          .take(socialLinks.length * 2 - 1)
          .toList(),
    );
  }

  Widget _buildSocialButton(IconData icon, String url, Color color) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isHovered ? color.withOpacity(0.1) : AppConstants.neutral50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHovered ? color.withOpacity(0.3) : AppConstants.neutral200,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isHovered ? color : AppConstants.neutral600,
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'tech lead':
      case 'technical lead':
        return const Color(0xFF1976D2); // Material Blue
      case 'gdg head':
      case 'lead organizer':
        return const Color(0xFF388E3C); // Material Green
      case 'core team':
        return const Color(0xFF7B1FA2); // Material Purple
      case 'social media/content team':
      case 'marketing lead':
        return const Color(0xFFF57C00); // Material Orange
      case 'design team':
        return const Color(0xFFE91E63); // Material Pink
      default:
        return const Color(0xFF455A64); // Blue Grey
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

// Custom painter for subtle background pattern
class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 20.0;
    
    // Draw subtle dot pattern
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 