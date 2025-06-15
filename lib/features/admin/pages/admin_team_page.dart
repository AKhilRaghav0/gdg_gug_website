import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/team_service.dart';
import '../../../core/models/team_member.dart';
import '../../../core/constants/app_constants.dart';

class AdminTeamPage extends StatefulWidget {
  const AdminTeamPage({super.key});

  @override
  State<AdminTeamPage> createState() => _AdminTeamPageState();
}

class _AdminTeamPageState extends State<AdminTeamPage> {
  final TeamService _teamService = TeamService();
  List<TeamMember> _teamMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeamMembers();
  }

  void _loadTeamMembers() {
    _teamService.getTeamMembers().listen((members) {
      setState(() {
        _teamMembers = members;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Team'),
        backgroundColor: AppConstants.googleGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin/dashboard'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _teamMembers.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No team members found'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _teamMembers.length,
                  itemBuilder: (context, index) {
                    final member = _teamMembers[index];
                    return _buildTeamMemberCard(member);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create team member page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add team member feature coming soon!')),
          );
        },
        backgroundColor: AppConstants.googleGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTeamMemberCard(TeamMember member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: AppConstants.googleGreen,
              backgroundImage: member.imageUrl.isNotEmpty 
                  ? NetworkImage(member.imageUrl)
                  : null,
              child: member.imageUrl.isEmpty
                  ? Text(
                      member.name.isNotEmpty ? member.name[0].toUpperCase() : 'T',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(width: 16),
            
            // Member Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.role,
                    style: TextStyle(
                      color: AppConstants.googleGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.bio,
                    style: TextStyle(color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(member.category).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          member.category.name.toUpperCase(),
                          style: TextStyle(
                            color: _getCategoryColor(member.category),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!member.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'INACTIVE',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Social Links Preview
            Column(
              children: [
                if (member.socialLinks.linkedin.isNotEmpty)
                  const Icon(Icons.business, size: 16, color: Colors.blue),
                if (member.socialLinks.github.isNotEmpty)
                  const Icon(Icons.code, size: 16, color: Colors.black),
                if (member.socialLinks.twitter.isNotEmpty)
                  const Icon(Icons.alternate_email, size: 16, color: Colors.lightBlue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(TeamCategory category) {
    switch (category) {
      case TeamCategory.leadership:
        return AppConstants.googleRed;
      case TeamCategory.technical:
        return AppConstants.googleBlue;
      case TeamCategory.marketing:
        return AppConstants.googleGreen;
      case TeamCategory.design:
        return AppConstants.googleYellow;
      case TeamCategory.content:
        return Colors.purple;
      case TeamCategory.event:
        return Colors.orange;
      case TeamCategory.member:
        return AppConstants.neutral600;
      case TeamCategory.alumni:
        return Colors.grey;
    }
  }
} 