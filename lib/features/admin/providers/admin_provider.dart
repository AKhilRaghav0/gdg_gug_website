import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../../../core/services/firebase_service.dart';
import '../../../core/models/event.dart';
import '../../../core/models/team_member.dart';

// Events state management
final eventsStreamProvider = StreamProvider<List<Event>>((ref) {
  return FirebaseService.getEventsStream();
});

final eventsByStatusProvider = StreamProvider.family<List<Event>, String>((ref, status) {
  return FirebaseService.getEventsByStatus(status);
});

// Team members state management  
final teamMembersStreamProvider = StreamProvider<List<TeamMember>>((ref) {
  return FirebaseService.getTeamMembersStream();
});

final teamMembersByRoleProvider = StreamProvider.family<List<TeamMember>, String>((ref, role) {
  return FirebaseService.getTeamMembersByRole(role);
});

// Dashboard stats
final dashboardStatsProvider = FutureProvider<Map<String, int>>((ref) {
  return FirebaseService.getDashboardStats();
});

// Admin controller
class AdminController extends StateNotifier<AdminState> {
  AdminController() : super(AdminState());

  // Event management
  Future<void> addEvent(Event event) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await FirebaseService.addEvent(event);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateEvent(String eventId, Event event) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await FirebaseService.updateEvent(eventId, event);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteEvent(String eventId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await FirebaseService.deleteEvent(eventId);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Team member management
  Future<void> addTeamMember(TeamMember member) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await FirebaseService.addTeamMember(member);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateTeamMember(String memberId, TeamMember member) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await FirebaseService.updateTeamMember(memberId, member);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteTeamMember(String memberId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await FirebaseService.deleteTeamMember(memberId);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Image upload
  Future<String?> uploadImage({
    required List<int> imageData,
    required String fileName,
    required String folder,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final imageBytes = Uint8List.fromList(imageData);
      final url = await FirebaseService.uploadImage(
        imageData: imageBytes,
        fileName: fileName,
        folder: folder,
      );
      state = state.copyWith(isLoading: false);
      return url;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// State class
class AdminState {
  final bool isLoading;
  final String? error;

  AdminState({
    this.isLoading = false,
    this.error,
  });

  AdminState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Provider instance
final adminControllerProvider = StateNotifierProvider<AdminController, AdminState>((ref) {
  return AdminController();
});

// Utility providers for UI state
final selectedEventProvider = StateProvider<Event?>((ref) => null);
final selectedTeamMemberProvider = StateProvider<TeamMember?>((ref) => null);
final adminSearchQueryProvider = StateProvider<String>((ref) => '');
final adminSelectedTabProvider = StateProvider<int>((ref) => 0); 