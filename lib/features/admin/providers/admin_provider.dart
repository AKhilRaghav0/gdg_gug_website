import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../../../core/services/firebase_realtime_service.dart';
import '../../../core/models/event.dart';
import '../../../core/models/team_member.dart';

// Firebase Realtime Database Service Provider
final firebaseRealtimeServiceProvider = Provider<FirebaseRealtimeService>((ref) {
  return FirebaseRealtimeService();
});

// Events Stream Provider
final eventsStreamProvider = StreamProvider<List<Event>>((ref) {
  final service = ref.watch(firebaseRealtimeServiceProvider);
  return service.getEventsStream();
});

// Published Events Stream Provider
final publishedEventsStreamProvider = StreamProvider<List<Event>>((ref) {
  final service = ref.watch(firebaseRealtimeServiceProvider);
  return service.getPublishedEventsStream();
});

// Team Members Stream Provider
final teamMembersStreamProvider = StreamProvider<List<TeamMember>>((ref) {
  final service = ref.watch(firebaseRealtimeServiceProvider);
  return service.getTeamMembersStream();
});

// Active Team Members Stream Provider
final activeTeamMembersStreamProvider = StreamProvider<List<TeamMember>>((ref) {
  final service = ref.watch(firebaseRealtimeServiceProvider);
  return service.getActiveTeamMembersStream();
});

// Dashboard Stats Provider
final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  final service = ref.watch(firebaseRealtimeServiceProvider);
  return service.getDashboardStats();
});

// Admin Controller
class AdminController extends StateNotifier<AsyncValue<void>> {
  AdminController(this._service) : super(const AsyncValue.data(null));

  final FirebaseRealtimeService _service;

  // Event Management
  Future<void> addEvent(Event event) async {
    state = const AsyncValue.loading();
    try {
      await _service.createEvent(event);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateEvent(String id, Event event) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateEvent(id, event);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteEvent(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteEvent(id);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Team Management
  Future<void> addTeamMember(TeamMember member) async {
    state = const AsyncValue.loading();
    try {
      await _service.createTeamMember(member);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTeamMember(String id, TeamMember member) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateTeamMember(id, member);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteTeamMember(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteTeamMember(id);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Image Upload
  Future<String> uploadEventImage(String eventId, List<int> imageBytes, String fileName) async {
    try {
      return await _service.uploadEventImage(eventId, Uint8List.fromList(imageBytes), fileName);
    } catch (e) {
      throw Exception('Failed to upload event image: $e');
    }
  }

  Future<String> uploadTeamMemberImage(String memberId, List<int> imageBytes, String fileName) async {
    try {
      return await _service.uploadTeamMemberImage(memberId, Uint8List.fromList(imageBytes), fileName);
    } catch (e) {
      throw Exception('Failed to upload team member image: $e');
    }
  }
}

// Admin Controller Provider
final adminControllerProvider = StateNotifierProvider<AdminController, AsyncValue<void>>((ref) {
  final service = ref.watch(firebaseRealtimeServiceProvider);
  return AdminController(service);
});

// Utility providers for UI state
final selectedEventProvider = StateProvider<Event?>((ref) => null);
final selectedTeamMemberProvider = StateProvider<TeamMember?>((ref) => null);
final adminSearchQueryProvider = StateProvider<String>((ref) => '');
final adminSelectedTabProvider = StateProvider<int>((ref) => 0); 