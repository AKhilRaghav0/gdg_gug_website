import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/event.dart';

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  static const String _collection = 'events';
  static const String _registrationsCollection = 'event_registrations';

  // Mock data for development
  final List<Event> _mockEvents = [
    Event(
      id: '1',
      title: 'Flutter Workshop',
      description: 'Learn Flutter development from scratch',
      date: DateTime.now().add(const Duration(days: 7)),
      location: 'GUG Campus',
      imageUrl: 'https://via.placeholder.com/300x200',
      category: 'Workshop',
      maxAttendees: 50,
      currentAttendees: 23,
      isPublished: true,
    ),
    Event(
      id: '2',
      title: 'Google I/O Extended',
      description: 'Watch Google I/O together and discuss the latest announcements',
      date: DateTime.now().add(const Duration(days: 14)),
      location: 'GUG Auditorium',
      imageUrl: 'https://via.placeholder.com/300x200',
      category: 'Conference',
      maxAttendees: 100,
      currentAttendees: 45,
      isPublished: true,
    ),
    Event(
      id: '3',
      title: 'Android Study Jam',
      description: 'Learn Android development in a structured way',
      date: DateTime.now().add(const Duration(days: 21)),
      location: 'Computer Lab',
      imageUrl: 'https://via.placeholder.com/300x200',
      category: 'Study Jam',
      maxAttendees: 30,
      currentAttendees: 15,
      isPublished: false,
    ),
  ];

  // Get all events with optional filters (using mock data for development)
  Stream<List<Event>> getEvents({
    String? status,
    String? type,
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var filteredEvents = List<Event>.from(_mockEvents);
    
    if (startDate != null) {
      filteredEvents = filteredEvents.where((e) => e.date.isAfter(startDate)).toList();
    }
    
    if (endDate != null) {
      filteredEvents = filteredEvents.where((e) => e.date.isBefore(endDate)).toList();
    }
    
    if (limit != null && filteredEvents.length > limit) {
      filteredEvents = filteredEvents.take(limit).toList();
    }
    
    return Stream.value(filteredEvents);
  }

  // Get upcoming events
  Stream<List<Event>> getUpcomingEvents({int limit = 10}) {
    return getEvents(
      startDate: DateTime.now(),
      limit: limit,
    );
  }

  // Get featured events
  Stream<List<Event>> getFeaturedEvents({int limit = 3}) {
    final featuredEvents = _mockEvents.where((e) => e.isPublished).take(limit).toList();
    return Stream.value(featuredEvents);
  }

  // Get single event by ID
  Future<Event?> getEventById(String eventId) async {
    return getMockEventById(eventId);
  }

  // Create new event
  Future<String> createEvent(Event event) async {
    _mockEvents.add(event);
    return event.id;
  }

  // Update existing event
  Future<void> updateEvent(Event event) async {
    final index = _mockEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _mockEvents[index] = event;
    }
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    _mockEvents.removeWhere((e) => e.id == eventId);
  }

  // Register for event
  Future<void> registerForEvent(String eventId, String userId) async {
    final eventIndex = _mockEvents.indexWhere((e) => e.id == eventId);
    if (eventIndex != -1) {
      final event = _mockEvents[eventIndex];
      if (event.currentAttendees < event.maxAttendees) {
        _mockEvents[eventIndex] = event.copyWith(
          currentAttendees: event.currentAttendees + 1,
        );
      }
    }
  }

  // Cancel event registration
  Future<void> cancelEventRegistration(String eventId, String userId) async {
    final eventIndex = _mockEvents.indexWhere((e) => e.id == eventId);
    if (eventIndex != -1) {
      final event = _mockEvents[eventIndex];
      if (event.currentAttendees > 0) {
        _mockEvents[eventIndex] = event.copyWith(
          currentAttendees: event.currentAttendees - 1,
        );
      }
    }
  }

  // Get event registrations (mock implementation)
  Stream<List<String>> getEventRegistrations(String eventId) {
    // Return empty list for development
    return Stream.value([]);
  }

  // Check if user is registered for event
  Future<bool> isUserRegistered(String eventId, String userId) async {
    // Mock implementation - always return false for development
    return false;
  }

  // Upload event image (mock implementation)
  Future<String> uploadEventImage(String eventId, String fileName) async {
    // Return a placeholder URL for development
    return 'https://via.placeholder.com/300x200';
  }

  // Delete event image (mock implementation)
  Future<void> deleteEventImage(String imageUrl) async {
    // Mock implementation - do nothing for development
  }

  // Search events (mock implementation)
  Stream<List<Event>> searchEvents(String query) {
    final filtered = _mockEvents.where((e) => 
      e.title.toLowerCase().contains(query.toLowerCase()) ||
      e.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
    return Stream.value(filtered);
  }

  // Get events by tag (mock implementation)
  Stream<List<Event>> getEventsByTag(String tag) {
    final filtered = _mockEvents.where((e) => 
      e.tags.contains(tag)
    ).toList();
    return Stream.value(filtered);
  }

  // Get event statistics (mock implementation)
  Future<Map<String, dynamic>> getEventStats() async {
    final totalEvents = _mockEvents.length;
    final upcomingEvents = _mockEvents.where((e) => e.isUpcoming).length;
    final publishedEvents = _mockEvents.where((e) => e.isPublished).length;

    return {
      'totalEvents': totalEvents,
      'upcomingEvents': upcomingEvents,
      'publishedEvents': publishedEvents,
      'totalRegistrations': _mockEvents.fold<int>(0, (sum, e) => sum + e.currentAttendees),
    };
  }

  // Get all events as a stream (mock version)
  Stream<List<Event>> getMockEvents() {
    return Stream.value(_mockEvents);
  }

  // Get published events only (mock version)
  Stream<List<Event>> getMockPublishedEvents() {
    return Stream.value(_mockEvents.where((e) => e.isPublished).toList());
  }

  // Get event by ID (mock version)
  Future<Event?> getMockEventById(String id) async {
    try {
      return _mockEvents.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // Create new event
  Future<void> createEventMock(Event event) async {
    // In a real app, this would save to Firebase
    _mockEvents.add(event);
  }

  // Update event
  Future<void> updateEventMock(Event event) async {
    // In a real app, this would update in Firebase
    final index = _mockEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _mockEvents[index] = event;
    }
  }

  // Delete event
  Future<void> deleteEventMock(String id) async {
    // In a real app, this would delete from Firebase
    _mockEvents.removeWhere((e) => e.id == id);
  }

  // Register for event
  Future<void> registerForEventMock(String eventId, String userId) async {
    // In a real app, this would save registration to Firebase
    final eventIndex = _mockEvents.indexWhere((e) => e.id == eventId);
    if (eventIndex != -1) {
      final event = _mockEvents[eventIndex];
      if (event.currentAttendees < event.maxAttendees) {
        _mockEvents[eventIndex] = event.copyWith(
          currentAttendees: event.currentAttendees + 1,
        );
      }
    }
  }

  // Unregister from event
  Future<void> unregisterFromEventMock(String eventId, String userId) async {
    // In a real app, this would remove registration from Firebase
    final eventIndex = _mockEvents.indexWhere((e) => e.id == eventId);
    if (eventIndex != -1) {
      final event = _mockEvents[eventIndex];
      if (event.currentAttendees > 0) {
        _mockEvents[eventIndex] = event.copyWith(
          currentAttendees: event.currentAttendees - 1,
        );
      }
    }
  }
} 