import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/team_member.dart';

class AdminTeamPage extends StatefulWidget {
  const AdminTeamPage({super.key});

  @override
  State<AdminTeamPage> createState() => _AdminTeamPageState();
}

class _AdminTeamPageState extends State<AdminTeamPage> {
  final List<TeamMember> _teamMembers = _generateSampleMembers();
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
    final filteredMembers = _getFilteredMembers();
    
    return Container(
      color: AppConstants.neutral50,
      child: Column(
        children: [
          // Header Section with Stats
          _buildHeaderSection(context),
          
          // Search and Filter Section
          _buildSearchAndFilter(context),
          
          // Team Members List
          Expanded(
            child: _buildTeamMembersList(filteredMembers),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final roleStats = _getRoleStatistics();
    
    return Container(
      color: AppConstants.googleGreen,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team Overview',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your GDG team members and roles',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () => _exportTeamData(),
                    color: Colors.white,
                    tooltip: 'Export Team Data',
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showMoreOptions(),
                    color: Colors.white,
                    tooltip: 'More Options',
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddMemberDialog(context),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Member'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppConstants.googleGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '${_teamMembers.length}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total Members',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Role Statistics
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: roleStats.length,
              itemBuilder: (context, index) {
                final stat = roleStats[index];
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stat['count'].toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat['role'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    return Container(
      color: Colors.white,
                  padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Search Field
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search members...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Role Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedRole,
              onChanged: (value) => setState(() => _selectedRole = value!),
              decoration: InputDecoration(
                labelText: 'Filter by Role',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              items: _teamRoles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMembersList(List<TeamMember> members) {
    if (members.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppConstants.neutral400,
            ),
            const SizedBox(height: 16),
            Text(
              'No team members found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppConstants.neutral600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first team member to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.neutral500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      itemBuilder: (context, index) {
        return _buildTeamMemberCard(members[index]);
      },
    );
  }

  Widget _buildTeamMemberCard(TeamMember member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.neutral900.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    _getRoleColor(member.role),
                    _getRoleColor(member.role).withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  member.name.split(' ').map((e) => e[0]).take(2).join(),
                      style: const TextStyle(
                    color: Colors.white,
                        fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                      ),
            ),
            const SizedBox(width: 16),
            
            // Member Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          member.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getRoleColor(member.role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          member.role,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getRoleColor(member.role),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.position,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstants.neutral600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (member.bio.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      member.bio,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppConstants.neutral600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  
                  // Contact Info
                  Row(
                    children: [
                      if (member.email.isNotEmpty) ...[
                        Icon(Icons.email, size: 16, color: AppConstants.neutral500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            member.email,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppConstants.neutral600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      const SizedBox(width: 16),
                      Text(
                        'Joined ${_formatJoinDate(member.joinDate)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.neutral500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Actions
            Column(
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMemberAction(value, member),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'change_role',
                      child: Row(
                        children: [
                          Icon(Icons.swap_horiz, size: 16),
                          SizedBox(width: 8),
                          Text('Change Role'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Remove', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.neutral100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.more_vert, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Core Team':
        return AppConstants.googleBlue;
      case 'Tech Team':
        return AppConstants.googleGreen;
      case 'Social Media/Content Team':
        return AppConstants.googleRed;
      case 'Data Management Team':
        return AppConstants.googleYellow;
      case 'Sponsorship Team':
        return Colors.purple;
      case 'Graphic Designing Team':
        return Colors.orange;
      case 'Community Managers':
        return Colors.teal;
      default:
        return AppConstants.neutral600;
    }
  }

  List<TeamMember> _getFilteredMembers() {
    var filtered = _teamMembers;
    
    if (_selectedRole != 'All') {
      filtered = filtered.where((member) => member.role == _selectedRole).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((member) =>
        member.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        member.position.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        member.email.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  List<Map<String, dynamic>> _getRoleStatistics() {
    final Map<String, int> roleCount = {};
    
    for (final role in _teamRoles.skip(1)) {
      roleCount[role] = _teamMembers.where((member) => member.role == role).length;
    }
    
    return roleCount.entries.map((entry) => {
      'role': entry.key.replaceAll(' Team', ''),
      'count': entry.value,
    }).toList();
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddMemberDialog(
        onMemberAdded: (member) {
          setState(() {
            _teamMembers.add(member);
          });
        },
        availableRoles: _teamRoles.skip(1).toList(),
      ),
    );
  }

  void _handleMemberAction(String action, TeamMember member) {
    switch (action) {
      case 'edit':
        _showEditMemberDialog(member);
        break;
      case 'change_role':
        _showChangeRoleDialog(member);
        break;
      case 'remove':
        _showRemoveConfirmation(member);
        break;
    }
  }

  void _showEditMemberDialog(TeamMember member) {
    // TODO: Implement edit member dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${member.name} - Feature coming soon!')),
    );
  }

  void _showChangeRoleDialog(TeamMember member) {
    // TODO: Implement change role dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Change role for ${member.name} - Feature coming soon!')),
    );
  }

  void _showRemoveConfirmation(TeamMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Team Member'),
        content: Text('Are you sure you want to remove ${member.name} from the team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _teamMembers.remove(member);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${member.name} removed from team')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _exportTeamData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting team data - Feature coming soon!')),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.import_export),
              title: const Text('Import Members'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Import feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Send Team Invitation'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Team invitation feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Team Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Team settings coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatJoinDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  static List<TeamMember> _generateSampleMembers() {
    return [
      TeamMember(
        id: '1',
        name: 'Rohit Sharma',
        email: 'rohit@gdg.com',
        position: 'Lead Organizer',
        role: 'Core Team',
        bio: 'Passionate about Flutter development and community building',
        imageUrl: '',
        joinDate: DateTime.now().subtract(const Duration(days: 365)),
        isActive: true,
      ),
      TeamMember(
        id: '2',
        name: 'Priya Singh',
        email: 'priya@gdg.com',
        position: 'Technical Lead',
        role: 'Tech Team',
        bio: 'Full-stack developer with expertise in cloud technologies',
        imageUrl: '',
        joinDate: DateTime.now().subtract(const Duration(days: 300)),
        isActive: true,
      ),
      TeamMember(
        id: '3',
        name: 'Arjun Patel',
        email: 'arjun@gdg.com',
        position: 'Content Manager',
        role: 'Social Media/Content Team',
        bio: 'Creating engaging content for our developer community',
        imageUrl: '',
        joinDate: DateTime.now().subtract(const Duration(days: 200)),
        isActive: true,
      ),
      TeamMember(
        id: '4',
        name: 'Sneha Reddy',
        email: 'sneha@gdg.com',
        position: 'Data Analyst',
        role: 'Data Management Team',
        bio: 'Analyzing community engagement and event metrics',
        imageUrl: '',
        joinDate: DateTime.now().subtract(const Duration(days: 150)),
        isActive: true,
      ),
      TeamMember(
        id: '5',
        name: 'Vikram Gupta',
        email: 'vikram@gdg.com',
        position: 'Partnership Manager',
        role: 'Sponsorship Team',
        bio: 'Building strategic partnerships with tech companies',
        imageUrl: '',
        joinDate: DateTime.now().subtract(const Duration(days: 120)),
        isActive: true,
      ),
      TeamMember(
        id: '6',
        name: 'Ananya Joshi',
        email: 'ananya@gdg.com',
        position: 'Design Lead',
        role: 'Graphic Designing Team',
        bio: 'Creating visual identity and design assets',
        imageUrl: '',
        joinDate: DateTime.now().subtract(const Duration(days: 90)),
        isActive: true,
      ),
      TeamMember(
        id: '7',
        name: 'Karan Mehta',
        email: 'karan@gdg.com',
        position: 'Community Lead',
        role: 'Community Managers',
        bio: 'Fostering engagement and building connections',
        imageUrl: '',
        joinDate: DateTime.now().subtract(const Duration(days: 60)),
        isActive: true,
      ),
    ];
  }
}

class AddMemberDialog extends StatefulWidget {
  final Function(TeamMember) onMemberAdded;
  final List<String> availableRoles;

  const AddMemberDialog({
    super.key,
    required this.onMemberAdded,
    required this.availableRoles,
  });

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _positionController = TextEditingController();
  final _bioController = TextEditingController();
  String _selectedRole = '';

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.availableRoles.first;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Team Member',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter member\'s full name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter email address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Position and Role Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _positionController,
                      decoration: const InputDecoration(
                        labelText: 'Position',
                        hintText: 'e.g. Technical Lead',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a position';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      onChanged: (value) => setState(() => _selectedRole = value!),
                      decoration: const InputDecoration(
                        labelText: 'Role',
                      ),
                      items: widget.availableRoles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Bio Field
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio (Optional)',
                  hintText: 'Brief description about the member',
                ),
              ),
              const SizedBox(height: 24),
              
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _addMember,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.googleGreen,
                    ),
                    child: const Text('Add Member'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addMember() {
    if (_formKey.currentState!.validate()) {
      final newMember = TeamMember(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        position: _positionController.text.trim(),
        role: _selectedRole,
        bio: _bioController.text.trim(),
        imageUrl: '',
        joinDate: DateTime.now(),
        isActive: true,
      );
      
      widget.onMemberAdded(newMember);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _positionController.dispose();
    _bioController.dispose();
    super.dispose();
  }
} 