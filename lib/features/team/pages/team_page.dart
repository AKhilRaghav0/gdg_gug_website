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

    return Container(
      color: AppConstants.neutral50,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveWrapper(
        child: LayoutBuilder(
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
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                return TeamMemberCard(member: teamMembers[index]);
              },
            );
          },
        ),
      ),
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
                    backgroundImage: widget.member.imageUrl != null 
                        ? NetworkImage(widget.member.imageUrl!)
                        : null,
                    onBackgroundImageError: (_, __) {},
                    child: widget.member.imageUrl == null || widget.member.imageUrl!.isEmpty
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
                          color: _getRoleColor(widget.member.role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          widget.member.role.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getRoleColor(widget.member.role),
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
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Social links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.member.linkedinUrl != null && widget.member.linkedinUrl!.isNotEmpty)
                            _buildSocialButton(
                              Icons.business,
                              widget.member.linkedinUrl!,
                              AppConstants.googleBlue,
                            ),
                          if (widget.member.linkedinUrl != null && widget.member.linkedinUrl!.isNotEmpty)
                            const SizedBox(width: 12),
                          if (widget.member.twitterUrl != null && widget.member.twitterUrl!.isNotEmpty)
                            _buildSocialButton(
                              Icons.alternate_email,
                              widget.member.twitterUrl!,
                              AppConstants.googleRed,
                            ),
                          if (widget.member.twitterUrl != null && widget.member.twitterUrl!.isNotEmpty)
                            const SizedBox(width: 12),
                          if (widget.member.githubUrl != null && widget.member.githubUrl!.isNotEmpty)
                            _buildSocialButton(
                              Icons.code,
                              widget.member.githubUrl!,
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

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'tech lead':
      case 'technical lead':
        return AppConstants.googleRed;
      case 'gdg head':
      case 'lead organizer':
        return AppConstants.googleBlue;
      case 'core team':
        return AppConstants.googleGreen;
      case 'social media/content team':
      case 'marketing lead':
        return AppConstants.googleYellow;
      default:
        return AppConstants.googleBlue;
    }
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