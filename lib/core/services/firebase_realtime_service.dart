import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/event.dart';
import '../models/team_member.dart';

class FirebaseRealtimeService {
  static final FirebaseRealtimeService _instance = FirebaseRealtimeService._internal();
  factory FirebaseRealtimeService() => _instance;
  FirebaseRealtimeService._internal();

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://gdggug-5cfa2-default-rtdb.asia-southeast1.firebasedatabase.app/',
  );
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Events CRUD Operations
  
  /// Get all events as a stream
  Stream<List<Event>> getEventsStream() {
    return _database.ref('events').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <Event>[];
      
      return data.entries.map((entry) {
        final eventData = Map<String, dynamic>.from(entry.value as Map);
        eventData['id'] = entry.key;
        
        // Convert Firebase timestamps to proper formats
        if (eventData['createdAt'] is int) {
          eventData['createdAt'] = DateTime.fromMillisecondsSinceEpoch(eventData['createdAt']).toIso8601String();
        }
        if (eventData['updatedAt'] is int) {
          eventData['updatedAt'] = DateTime.fromMillisecondsSinceEpoch(eventData['updatedAt']).toIso8601String();
        }
        
        // Ensure required fields have proper types
        eventData['maxAttendees'] = (eventData['maxAttendees'] ?? 0).toString();
        eventData['currentAttendees'] = (eventData['currentAttendees'] ?? 0).toString();
        eventData['registeredCount'] = (eventData['registeredCount'] ?? eventData['currentAttendees'] ?? 0).toString();
        eventData['isPublished'] = eventData['isPublished'] ?? false;
        eventData['isOnline'] = eventData['isOnline'] ?? false;
        eventData['tags'] = eventData['tags'] ?? [];
        
        // Convert numeric fields back to int for Event model
        eventData['maxAttendees'] = int.tryParse(eventData['maxAttendees'].toString()) ?? 0;
        eventData['currentAttendees'] = int.tryParse(eventData['currentAttendees'].toString()) ?? 0;
        eventData['registeredCount'] = int.tryParse(eventData['registeredCount'].toString()) ?? 0;
        
        return Event.fromJson(eventData);
      }).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    });
  }

  /// Get published events only
  Stream<List<Event>> getPublishedEventsStream() {
    return getEventsStream().map((events) => 
      events.where((event) => event.isPublished).toList()
    );
  }

  /// Get a specific event by ID
  Future<Event?> getEvent(String id) async {
    try {
      final snapshot = await _database.ref('events/$id').get();
      if (!snapshot.exists) return null;
      
      final eventData = Map<String, dynamic>.from(snapshot.value as Map);
      eventData['id'] = id;
      
      // Convert Firebase timestamps to proper formats
      if (eventData['createdAt'] is int) {
        eventData['createdAt'] = DateTime.fromMillisecondsSinceEpoch(eventData['createdAt']).toIso8601String();
      }
      if (eventData['updatedAt'] is int) {
        eventData['updatedAt'] = DateTime.fromMillisecondsSinceEpoch(eventData['updatedAt']).toIso8601String();
      }
      
      // Ensure required fields have proper types
      eventData['maxAttendees'] = (eventData['maxAttendees'] ?? 0).toString();
      eventData['currentAttendees'] = (eventData['currentAttendees'] ?? 0).toString();
      eventData['registeredCount'] = (eventData['registeredCount'] ?? eventData['currentAttendees'] ?? 0).toString();
      eventData['isPublished'] = eventData['isPublished'] ?? false;
      eventData['isOnline'] = eventData['isOnline'] ?? false;
      eventData['tags'] = eventData['tags'] ?? [];
      
      // Convert numeric fields back to int for Event model
      eventData['maxAttendees'] = int.tryParse(eventData['maxAttendees'].toString()) ?? 0;
      eventData['currentAttendees'] = int.tryParse(eventData['currentAttendees'].toString()) ?? 0;
      eventData['registeredCount'] = int.tryParse(eventData['registeredCount'].toString()) ?? 0;
      
      return Event.fromJson(eventData);
    } catch (e) {
      print('Error getting event: $e');
      return null;
    }
  }

  /// Create new event
  Future<String> createEvent(Event event) async {
    try {
      final ref = _database.ref('events').push();
      final eventData = event.toJson();
      eventData.remove('id'); // Remove ID as it will be the key
      eventData['createdAt'] = ServerValue.timestamp;
      eventData['updatedAt'] = ServerValue.timestamp;
      
      await ref.set(eventData);
      return ref.key!;
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  /// Update existing event
  Future<void> updateEvent(String id, Event event) async {
    try {
      final eventData = event.toJson();
      eventData.remove('id');
      eventData['updatedAt'] = ServerValue.timestamp;
      
      await _database.ref('events/$id').update(eventData);
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  /// Delete event
  Future<void> deleteEvent(String id) async {
    try {
      await _database.ref('events/$id').remove();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  /// Upload event image
  Future<String> uploadEventImage(String eventId, Uint8List imageBytes, String fileName) async {
    try {
      final ref = _storage.ref().child('events/$eventId/$fileName');
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload event image: $e');
    }
  }

  // Team Members CRUD Operations
  
  /// Get all team members as a stream
  Stream<List<TeamMember>> getTeamMembersStream() {
    return _database.ref('team_members').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <TeamMember>[];
      
      return data.entries.map((entry) {
        final memberData = Map<String, dynamic>.from(entry.value as Map);
        memberData['id'] = entry.key;
        
        // Convert timestamp to DateTime string for JSON parsing
        if (memberData['joinDate'] is int) {
          memberData['joinDate'] = DateTime.fromMillisecondsSinceEpoch(memberData['joinDate']).toIso8601String();
        } else if (memberData['joinDate'] is DateTime) {
          memberData['joinDate'] = (memberData['joinDate'] as DateTime).toIso8601String();
        }
        
        if (memberData['createdAt'] is int) {
          memberData['createdAt'] = DateTime.fromMillisecondsSinceEpoch(memberData['createdAt']).toIso8601String();
        } else if (memberData['createdAt'] is DateTime) {
          memberData['createdAt'] = (memberData['createdAt'] as DateTime).toIso8601String();
        }
        
        if (memberData['updatedAt'] is int) {
          memberData['updatedAt'] = DateTime.fromMillisecondsSinceEpoch(memberData['updatedAt']).toIso8601String();
        } else if (memberData['updatedAt'] is DateTime) {
          memberData['updatedAt'] = (memberData['updatedAt'] as DateTime).toIso8601String();
        }
        
        // Ensure required fields have proper defaults
        memberData['isActive'] = memberData['isActive'] ?? true;
        memberData['bio'] = memberData['bio'] ?? '';
        
        return TeamMember.fromJson(memberData);
      }).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    });
  }

  /// Get active team members only
  Stream<List<TeamMember>> getActiveTeamMembersStream() {
    return getTeamMembersStream().map((members) => 
      members.where((member) => member.isActive).toList()
    );
  }

  /// Get a specific team member by ID
  Future<TeamMember?> getTeamMember(String id) async {
    try {
      final snapshot = await _database.ref('team_members/$id').get();
      if (!snapshot.exists) return null;
      
      final memberData = Map<String, dynamic>.from(snapshot.value as Map);
      memberData['id'] = id;
      
      // Convert timestamp to DateTime string for JSON parsing
      if (memberData['joinDate'] is int) {
        memberData['joinDate'] = DateTime.fromMillisecondsSinceEpoch(memberData['joinDate']).toIso8601String();
      } else if (memberData['joinDate'] is DateTime) {
        memberData['joinDate'] = (memberData['joinDate'] as DateTime).toIso8601String();
      }
      
      if (memberData['createdAt'] is int) {
        memberData['createdAt'] = DateTime.fromMillisecondsSinceEpoch(memberData['createdAt']).toIso8601String();
      } else if (memberData['createdAt'] is DateTime) {
        memberData['createdAt'] = (memberData['createdAt'] as DateTime).toIso8601String();
      }
      
      if (memberData['updatedAt'] is int) {
        memberData['updatedAt'] = DateTime.fromMillisecondsSinceEpoch(memberData['updatedAt']).toIso8601String();
      } else if (memberData['updatedAt'] is DateTime) {
        memberData['updatedAt'] = (memberData['updatedAt'] as DateTime).toIso8601String();
      }
      
      // Ensure required fields have proper defaults
      memberData['isActive'] = memberData['isActive'] ?? true;
      memberData['bio'] = memberData['bio'] ?? '';
      
      return TeamMember.fromJson(memberData);
    } catch (e) {
      print('Error getting team member: $e');
      return null;
    }
  }

  /// Create new team member
  Future<String> createTeamMember(TeamMember member) async {
    try {
      final ref = _database.ref('team_members').push();
      final memberData = member.toJson();
      memberData.remove('id');
      // Convert DateTime to timestamp
      memberData['joinDate'] = member.joinDate.millisecondsSinceEpoch;
      memberData['createdAt'] = ServerValue.timestamp;
      memberData['updatedAt'] = ServerValue.timestamp;
      
      await ref.set(memberData);
      return ref.key!;
    } catch (e) {
      throw Exception('Failed to create team member: $e');
    }
  }

  /// Update existing team member
  Future<void> updateTeamMember(String id, TeamMember member) async {
    try {
      final memberData = member.toJson();
      memberData.remove('id');
      // Convert DateTime to timestamp
      memberData['joinDate'] = member.joinDate.millisecondsSinceEpoch;
      memberData['updatedAt'] = ServerValue.timestamp;
      
      await _database.ref('team_members/$id').update(memberData);
    } catch (e) {
      throw Exception('Failed to update team member: $e');
    }
  }

  /// Delete team member
  Future<void> deleteTeamMember(String id) async {
    try {
      await _database.ref('team_members/$id').remove();
    } catch (e) {
      throw Exception('Failed to delete team member: $e');
    }
  }

  /// Upload team member image
  Future<String> uploadTeamMemberImage(String memberId, Uint8List imageBytes, String fileName) async {
    try {
      final ref = _storage.ref().child('team/$memberId/$fileName');
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload team member image: $e');
    }
  }

  // Dashboard Statistics
  
  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final eventsSnapshot = await _database.ref('events').get();
      final membersSnapshot = await _database.ref('team_members').get();
      
      int totalEvents = 0;
      int publishedEvents = 0;
      int upcomingEvents = 0;
      
      if (eventsSnapshot.exists) {
        final eventsData = eventsSnapshot.value as Map<dynamic, dynamic>;
        totalEvents = eventsData.length;
        
        final now = DateTime.now();
        for (final eventData in eventsData.values) {
          final event = eventData as Map<dynamic, dynamic>;
          if (event['isPublished'] == true) {
            publishedEvents++;
          }
          
          // Parse start date
          final startDateStr = event['startDate'] as String?;
          if (startDateStr != null) {
            final startDate = DateTime.parse(startDateStr);
            if (startDate.isAfter(now)) {
              upcomingEvents++;
            }
          }
        }
      }
      
      int totalMembers = 0;
      int activeMembers = 0;
      
      if (membersSnapshot.exists) {
        final membersData = membersSnapshot.value as Map<dynamic, dynamic>;
        totalMembers = membersData.length;
        
        for (final memberData in membersData.values) {
          final member = memberData as Map<dynamic, dynamic>;
          if (member['isActive'] == true) {
            activeMembers++;
          }
        }
      }
      
      return {
        'totalEvents': totalEvents,
        'publishedEvents': publishedEvents,
        'upcomingEvents': upcomingEvents,
        'totalMembers': totalMembers,
        'activeMembers': activeMembers,
      };
    } catch (e) {
      throw Exception('Failed to get dashboard stats: $e');
    }
  }
} 