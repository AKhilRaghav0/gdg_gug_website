import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/team_member.dart';

class TeamService {
  static final TeamService _instance = TeamService._internal();
  factory TeamService() => _instance;
  TeamService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  static const String _collection = 'team_members';

  // Mock data for development
  final List<TeamMember> _mockTeamMembers = [
    TeamMember(
      id: '1',
      name: 'John Doe',
      role: 'Core Team',
      position: 'Lead Organizer',
      bio: 'Passionate about Flutter and Android development. Leading the GDG community at GUG.',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'john.doe@gug.ac.in',
      linkedinUrl: 'https://linkedin.com/in/johndoe',
      githubUrl: 'https://github.com/johndoe',
      twitterUrl: 'https://twitter.com/johndoe',
      isActive: true,
      joinDate: DateTime.now().subtract(const Duration(days: 365)),
    ),
    TeamMember(
      id: '2',
      name: 'Jane Smith',
      role: 'Tech Team',
      position: 'Technical Lead',
      bio: 'Full-stack developer with expertise in web technologies and cloud computing.',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'jane.smith@gug.ac.in',
      linkedinUrl: 'https://linkedin.com/in/janesmith',
      githubUrl: 'https://github.com/janesmith',
      isActive: true,
      joinDate: DateTime.now().subtract(const Duration(days: 300)),
    ),
    TeamMember(
      id: '3',
      name: 'Mike Johnson',
      role: 'Core Team',
      position: 'Event Coordinator',
      bio: 'Experienced in organizing tech events and building developer communities.',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'mike.johnson@gug.ac.in',
      linkedinUrl: 'https://linkedin.com/in/mikejohnson',
      isActive: true,
      joinDate: DateTime.now().subtract(const Duration(days: 200)),
    ),
    TeamMember(
      id: '4',
      name: 'Sarah Wilson',
      role: 'Social Media/Content Team',
      position: 'Marketing Lead',
      bio: 'Digital marketing specialist focusing on developer community engagement.',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'sarah.wilson@gug.ac.in',
      linkedinUrl: 'https://linkedin.com/in/sarahwilson',
      twitterUrl: 'https://twitter.com/sarahwilson',
      isActive: true,
      joinDate: DateTime.now().subtract(const Duration(days: 150)),
    ),
  ];

  // Get all team members as a stream
  Stream<List<TeamMember>> getTeamMembers() {
    return Stream.value(_mockTeamMembers);
  }

  // Get active team members only
  Stream<List<TeamMember>> getActiveTeamMembers() {
    return Stream.value(_mockTeamMembers.where((m) => m.isActive).toList());
  }

  // Get team member by ID
  Future<TeamMember?> getTeamMemberById(String id) async {
    try {
      return _mockTeamMembers.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new team member
  Future<void> addTeamMember(TeamMember member) async {
    // In a real app, this would save to Firebase
    _mockTeamMembers.add(member);
  }

  // Update team member
  Future<void> updateTeamMember(TeamMember member) async {
    // In a real app, this would update in Firebase
    final index = _mockTeamMembers.indexWhere((m) => m.id == member.id);
    if (index != -1) {
      _mockTeamMembers[index] = member;
    }
  }

  // Remove team member
  Future<void> removeTeamMember(String id) async {
    // In a real app, this would delete from Firebase
    _mockTeamMembers.removeWhere((m) => m.id == id);
  }

  // Deactivate team member (soft delete)
  Future<void> deactivateTeamMember(String id) async {
    final index = _mockTeamMembers.indexWhere((m) => m.id == id);
    if (index != -1) {
      _mockTeamMembers[index] = _mockTeamMembers[index].copyWith(isActive: false);
    }
  }

  // Activate team member
  Future<void> activateTeamMember(String id) async {
    final index = _mockTeamMembers.indexWhere((m) => m.id == id);
    if (index != -1) {
      _mockTeamMembers[index] = _mockTeamMembers[index].copyWith(isActive: true);
    }
  }

  // Get team members by role
  Future<List<TeamMember>> getTeamMembersByRole(String role) async {
    return _mockTeamMembers.where((m) => m.role == role && m.isActive).toList();
  }

  // Get leadership team (specific roles)
  Future<List<TeamMember>> getLeadershipTeam() async {
    const leadershipRoles = [
      'Lead Organizer',
      'Technical Lead',
      'Event Coordinator',
      'Marketing Lead'
    ];
    return _mockTeamMembers
        .where((m) => leadershipRoles.contains(m.role) && m.isActive)
        .toList();
  }

  // Get all team members with optional filters
  Stream<List<TeamMember>> getTeamMembersStream({
    TeamCategory? category,
    bool? isActive,
    int? limit,
  }) {
    Query query = _firestore.collection(_collection);

    if (category != null) {
      query = query.where('category', isEqualTo: category.name);
    }

    if (isActive != null) {
      query = query.where('isActive', isEqualTo: isActive);
    }

    query = query.orderBy('order').orderBy('name');

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TeamMember.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  // Create new team member
  Future<String> createTeamMember(TeamMember member) async {
    try {
      final docRef = await _firestore.collection(_collection).add(member.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create team member: $e');
    }
  }

  // Upload team member image
  Future<String> uploadTeamMemberImage(String memberId, Uint8List imageBytes, String fileName) async {
    try {
      final ref = _storage.ref().child('team/$memberId/$fileName');
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
} 