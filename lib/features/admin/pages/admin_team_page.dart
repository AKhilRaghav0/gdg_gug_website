import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/team_member.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/admin_provider.dart';
import '../../../shared/widgets/image_upload_widget.dart';
import 'dart:typed_data';

class AdminTeamPage extends ConsumerStatefulWidget {
  const AdminTeamPage({super.key});

  @override
  ConsumerState<AdminTeamPage> createState() => _AdminTeamPageState();
}

class _AdminTeamPageState extends ConsumerState<AdminTeamPage> {
  String _selectedRole = 'All';
  String _searchQuery = '';

  final List<String> _teamRoles = [
    'All',
    'Core Team',
    'Tech Team',
    'Social Media/Content Team',
    'Data Management Team',
    'Sponsorship Team',
    'Graphic Designing Team',
    'Community Managers',
  ];

  @override
  Widget build(BuildContext context) {
    final teamMembersAsync = ref.watch(teamMembersStreamProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      backgroundColor: AppConstants.neutral50,
      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(isDesktop ? 32 : 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppConstants.neutral200)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, size: isDesktop ? 32 : 24, color: AppConstants.googleBlue),
                    SizedBox(width: isDesktop ? 16 : 8),
                    Text(
                      'Team Management',
                      style: TextStyle(
                        fontSize: isDesktop ? 28 : 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.neutral900,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showTeamMemberDialog(context),
                      icon: const Icon(Icons.add),
                      label: Text(isDesktop ? 'Add Member' : 'Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.googleBlue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 24 : 16,
                          vertical: isDesktop ? 16 : 12,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isDesktop) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          onChanged: (value) => setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Search team members...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppConstants.neutral300),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: _teamRoles
                              .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                              .toList(),
                          onChanged: (value) => setState(() => _selectedRole = value!),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Team Members List
          Expanded(
            child: teamMembersAsync.when(
              data: (members) {
                final filteredMembers = _filterMembers(members);
                
                if (filteredMembers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: AppConstants.neutral400),
                        const SizedBox(height: 16),
                        Text(
                          'No team members found',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppConstants.neutral600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first team member to get started',
                          style: TextStyle(color: AppConstants.neutral500),
                        ),
                      ],
                    ),
                  );
                }

                return isDesktop ? _buildDesktopMembersList(filteredMembers) : _buildMobileMembersList(filteredMembers);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppConstants.googleRed),
                    const SizedBox(height: 16),
                    Text('Error loading team members: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(teamMembersStreamProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopMembersList(List<TeamMember> members) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.75,
        ),
        itemCount: members.length,
        itemBuilder: (context, index) => _buildMemberCard(members[index], isDesktop: true),
      ),
    );
  }

  Widget _buildMobileMembersList(List<TeamMember> members) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildMemberCard(members[index], isDesktop: false),
      ),
    );
  }

  List<TeamMember> _filterMembers(List<TeamMember> allMembers) {
    return allMembers.where((member) {
      final matchesSearch = _searchQuery.isEmpty ||
          member.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          member.role.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          member.position.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRole = _selectedRole == 'All' || member.role == _selectedRole;
      return matchesSearch && matchesRole && member.isActive;
    }).toList();
  }

  void _showTeamMemberDialog(BuildContext context, {TeamMember? member, bool isDuplicate = false}) {
    showDialog(
      context: context,
      builder: (context) => MemberEditorDialog(
        member: member,
        isDuplicate: isDuplicate,
      ),
    );
  }

  Widget _buildMemberCard(TeamMember member, {required bool isDesktop}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header with role badge and menu
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRoleColor(member.role),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    member.role,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (action) => _handleMemberAction(action, member),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  child: Icon(Icons.more_vert, color: AppConstants.neutral500),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Profile Image
            CircleAvatar(
              radius: isDesktop ? 40 : 30,
              backgroundImage: member.imageUrl != null 
                  ? NetworkImage(member.imageUrl!) 
                  : null,
              backgroundColor: _getRoleColor(member.role).withOpacity(0.2),
              child: member.imageUrl == null 
                  ? Text(
                      member.name.substring(0, 2).toUpperCase(),
                      style: TextStyle(
                        fontSize: isDesktop ? 20 : 16,
                        fontWeight: FontWeight.bold,
                        color: _getRoleColor(member.role),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),

            // Member Info
            Text(
              member.name,
              style: TextStyle(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              member.position,
              style: TextStyle(
                fontSize: isDesktop ? 14 : 12,
                color: AppConstants.neutral600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (member.bio.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                member.bio,
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.neutral500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
            const Spacer(),

            // Social Links
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (member.linkedinUrl != null)
                  Icon(Icons.business, size: 16, color: AppConstants.neutral500),
                if (member.githubUrl != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.code, size: 16, color: AppConstants.neutral500),
                ],
                if (member.twitterUrl != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.alternate_email, size: 16, color: AppConstants.neutral500),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: member.isActive ? AppConstants.googleGreen : AppConstants.neutral400,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                member.isActive ? 'Active' : 'Inactive',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'core team':
        return AppConstants.googleBlue;
      case 'tech team':
        return AppConstants.googleGreen;
      case 'social media/content team':
        return AppConstants.googleRed;
      case 'graphic designing team':
        return AppConstants.googleYellow;
      case 'data management team':
        return Colors.purple;
      case 'event management team':
        return Colors.orange;
      case 'outreach team':
        return Colors.teal;
      default:
        return AppConstants.neutral600;
    }
  }

  void _handleMemberAction(String action, TeamMember member) {
    switch (action) {
      case 'edit':
        _showTeamMemberDialog(context, member: member);
        break;
      case 'duplicate':
        _showTeamMemberDialog(context, member: member, isDuplicate: true);
        break;
      case 'delete':
        _showDeleteMemberDialog(member);
        break;
    }
  }

  void _showDeleteMemberDialog(TeamMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Team Member'),
        content: Text('Are you sure you want to delete "${member.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(adminControllerProvider.notifier).deleteTeamMember(member.id);
              if (mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppConstants.googleRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class MemberEditorDialog extends ConsumerStatefulWidget {
  final TeamMember? member;
  final bool isDuplicate;

  const MemberEditorDialog({super.key, this.member, this.isDuplicate = false});

  @override
  ConsumerState<MemberEditorDialog> createState() => _MemberEditorDialogState();
}

class _MemberEditorDialogState extends ConsumerState<MemberEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _positionController = TextEditingController();
  final _bioController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _githubController = TextEditingController();
  final _twitterController = TextEditingController();

  String _selectedRole = 'Core Team';
  String? _imageUrl;
  bool _isActive = true;
  DateTime _joinDate = DateTime.now();

  final List<String> _availableRoles = [
    'Core Team',
    'Tech Team',
    'Social Media/Content Team',
    'Data Management Team',
    'Sponsorship Team',
    'Graphic Designing Team',
    'Community Managers',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.member != null && !widget.isDuplicate) {
      _nameController.text = widget.member!.name;
      _emailController.text = widget.member!.email;
      _positionController.text = widget.member!.position;
      _bioController.text = widget.member!.bio;
      _linkedinController.text = widget.member!.linkedinUrl ?? '';
      _githubController.text = widget.member!.githubUrl ?? '';
      _twitterController.text = widget.member!.twitterUrl ?? '';
      _selectedRole = widget.member!.role;
      _imageUrl = widget.member!.imageUrl;
      _isActive = widget.member!.isActive;
      _joinDate = widget.member!.joinDate;
    } else if (widget.member != null && widget.isDuplicate) {
      _nameController.text = '${widget.member!.name} (Copy)';
      _emailController.text = '';
      _positionController.text = widget.member!.position;
      _bioController.text = widget.member!.bio;
      _selectedRole = widget.member!.role;
      _imageUrl = widget.member!.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.member == null || widget.isDuplicate ? 'Add Team Member' : 'Edit Team Member',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Image Section
                      Center(
                        child: ImageUploadWidget(
                          initialImageUrl: _imageUrl,
                          onImageSelected: (bytes) {
                            // Handle image selection
                          },
                          onImageUploaded: (url) => setState(() => _imageUrl = url),
                          folder: 'team',
                          width: 120,
                          height: 120,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Basic Info
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Full Name'),
                        validator: (value) => value?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedRole,
                              onChanged: (value) => setState(() => _selectedRole = value!),
                              items: _availableRoles
                                  .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                                  .toList(),
                              decoration: const InputDecoration(labelText: 'Role'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _positionController,
                              decoration: const InputDecoration(labelText: 'Position'),
                              validator: (value) => value?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bioController,
                        decoration: const InputDecoration(labelText: 'Bio'),
                        maxLines: 3,
                        validator: (value) => value?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      // Social Links
                      TextFormField(
                        controller: _linkedinController,
                        decoration: const InputDecoration(
                          labelText: 'LinkedIn URL',
                          prefixIcon: Icon(Icons.business),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _githubController,
                        decoration: const InputDecoration(
                          labelText: 'GitHub URL',
                          prefixIcon: Icon(Icons.code),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _twitterController,
                        decoration: const InputDecoration(
                          labelText: 'Twitter URL',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Settings
                      SwitchListTile(
                        title: const Text('Active Member'),
                        subtitle: const Text('Member is active and visible'),
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveMember,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.googleGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;

    final member = TeamMember(
      id: widget.member != null && !widget.isDuplicate ? widget.member!.id : '',
      name: _nameController.text,
      email: _emailController.text,
      role: _selectedRole,
      position: _positionController.text,
      bio: _bioController.text,
      imageUrl: _imageUrl,
      linkedinUrl: _linkedinController.text.isEmpty ? null : _linkedinController.text,
      githubUrl: _githubController.text.isEmpty ? null : _githubController.text,
      twitterUrl: _twitterController.text.isEmpty ? null : _twitterController.text,
      isActive: _isActive,
      joinDate: _joinDate,
    );

    try {
      if (widget.member == null || widget.isDuplicate) {
        await ref.read(adminControllerProvider.notifier).addTeamMember(member);
      } else {
        await ref.read(adminControllerProvider.notifier).updateTeamMember(member.id, member);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving member: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _positionController.dispose();
    _bioController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _twitterController.dispose();
    super.dispose();
  }
} 