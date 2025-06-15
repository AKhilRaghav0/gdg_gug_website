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

  // Get all team members with optional filters
  Stream<List<TeamMember>> getTeamMembers({
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
      return snapshot.docs.map((doc) => TeamMember.fromFirestore(doc)).toList();
    });
  }

  // Get active team members
  Stream<List<TeamMember>> getActiveTeamMembers() {
    return getTeamMembers(isActive: true);
  }

  // Get single team member by ID
  Future<TeamMember?> getTeamMemberById(String memberId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(memberId).get();
      if (doc.exists) {
        return TeamMember.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get team member: $e');
    }
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

  // Update existing team member
  Future<void> updateTeamMember(TeamMember member) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(member.id)
          .update(member.toFirestore());
    } catch (e) {
      throw Exception('Failed to update team member: $e');
    }
  }

  // Delete team member
  Future<void> deleteTeamMember(String memberId) async {
    try {
      await _firestore.collection(_collection).doc(memberId).delete();
    } catch (e) {
      throw Exception('Failed to delete team member: $e');
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