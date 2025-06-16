import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import '../models/event.dart';
import '../models/team_member.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections
  static const String eventsCollection = 'events';
  static const String teamMembersCollection = 'team_members';

  // ========== EVENT SERVICES ==========
  
  /// Get all events with real-time updates
  static Stream<List<Event>> getEventsStream() {
    return _firestore
        .collection(eventsCollection)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Event.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  /// Get events by status
  static Stream<List<Event>> getEventsByStatus(String status) {
    return _firestore
        .collection(eventsCollection)
        .where('status', isEqualTo: status)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Event.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  /// Add a new event
  static Future<String> addEvent(Event event) async {
    try {
      final docRef = await _firestore
          .collection(eventsCollection)
          .add(event.toFirestore());
      
      // Update the event with the generated ID
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add event: $e');
    }
  }

  /// Update an existing event
  static Future<void> updateEvent(String eventId, Event event) async {
    try {
      await _firestore
          .collection(eventsCollection)
          .doc(eventId)
          .update(event.toFirestore());
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  /// Delete an event
  static Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore
          .collection(eventsCollection)
          .doc(eventId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  /// Get single event by ID
  static Future<Event?> getEventById(String eventId) async {
    try {
      final doc = await _firestore
          .collection(eventsCollection)
          .doc(eventId)
          .get();
      
      if (doc.exists) {
        return Event.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get event: $e');
    }
  }

  // ========== TEAM MEMBER SERVICES ==========
  
  /// Get all team members with real-time updates
  static Stream<List<TeamMember>> getTeamMembersStream() {
    return _firestore
        .collection(teamMembersCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TeamMember.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  /// Get team members by role
  static Stream<List<TeamMember>> getTeamMembersByRole(String role) {
    return _firestore
        .collection(teamMembersCollection)
        .where('role', isEqualTo: role)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TeamMember.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  /// Add a new team member
  static Future<String> addTeamMember(TeamMember member) async {
    try {
      final docRef = await _firestore
          .collection(teamMembersCollection)
          .add(member.toFirestore());
      
      // Update the member with the generated ID
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add team member: $e');
    }
  }

  /// Update an existing team member
  static Future<void> updateTeamMember(String memberId, TeamMember member) async {
    try {
      await _firestore
          .collection(teamMembersCollection)
          .doc(memberId)
          .update(member.toFirestore());
    } catch (e) {
      throw Exception('Failed to update team member: $e');
    }
  }

  /// Delete a team member
  static Future<void> deleteTeamMember(String memberId) async {
    try {
      await _firestore
          .collection(teamMembersCollection)
          .doc(memberId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete team member: $e');
    }
  }

  // ========== FILE UPLOAD SERVICES ==========
  
  /// Upload image to Firebase Storage
  static Future<String> uploadImage({
    required Uint8List imageData,
    required String fileName,
    required String folder, // e.g., 'events', 'team', 'articles'
  }) async {
    try {
      final ref = _storage.ref().child('$folder/$fileName');
      final uploadTask = ref.putData(
        imageData,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Delete image from Firebase Storage
  static Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // ========== UTILITY METHODS ==========
  
  /// Generate unique filename
  static String generateFileName(String originalName, String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = originalName.split('.').last;
    return '${prefix}_${timestamp}.$extension';
  }

  /// Get current user ID
  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Check if user is authenticated
  static bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  // ========== DASHBOARD STATS ==========
  
  /// Get statistics for dashboard
  static Future<Map<String, int>> getDashboardStats() async {
    try {
      final eventsSnapshot = await _firestore.collection(eventsCollection).get();
      final teamSnapshot = await _firestore.collection(teamMembersCollection).get();
      
      return {
        'totalEvents': eventsSnapshot.docs.length,
        'totalTeamMembers': teamSnapshot.docs.length,
        'upcomingEvents': eventsSnapshot.docs
            .where((doc) => doc.data()['status'] == 'Upcoming')
            .length,
      };
    } catch (e) {
      throw Exception('Failed to get dashboard stats: $e');
    }
  }
} 