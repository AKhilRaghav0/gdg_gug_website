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

  // Get all events with optional filters
  Stream<List<Event>> getEvents({
    EventStatus? status,
    EventType? type,
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _firestore.collection(_collection);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    if (startDate != null) {
      query = query.where('dateTime', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where('dateTime', isLessThanOrEqualTo: endDate);
    }

    query = query.orderBy('dateTime', descending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    });
  }

  // Get upcoming events
  Stream<List<Event>> getUpcomingEvents({int limit = 10}) {
    return getEvents(
      status: EventStatus.upcoming,
      startDate: DateTime.now(),
      limit: limit,
    );
  }

  // Get featured events
  Stream<List<Event>> getFeaturedEvents({int limit = 3}) {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: EventStatus.upcoming.name)
        .where('additionalInfo.featured', isEqualTo: true)
        .orderBy('dateTime')
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    });
  }

  // Get single event by ID
  Future<Event?> getEventById(String eventId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(eventId).get();
      if (doc.exists) {
        return Event.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get event: $e');
    }
  }

  // Create new event
  Future<String> createEvent(Event event) async {
    try {
      final docRef = await _firestore.collection(_collection).add(event.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  // Update existing event
  Future<void> updateEvent(Event event) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(event.id)
          .update(event.toFirestore());
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    try {
      // Delete event registrations first
      final registrations = await _firestore
          .collection(_registrationsCollection)
          .where('eventId', isEqualTo: eventId)
          .get();

      final batch = _firestore.batch();
      for (final doc in registrations.docs) {
        batch.delete(doc.reference);
      }

      // Delete the event
      batch.delete(_firestore.collection(_collection).doc(eventId));
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  // Register for event
  Future<void> registerForEvent(EventRegistration registration) async {
    try {
      final batch = _firestore.batch();

      // Add registration
      final regRef = _firestore.collection(_registrationsCollection).doc();
      batch.set(regRef, registration.toFirestore());

      // Update event attendees count
      final eventRef = _firestore.collection(_collection).doc(registration.eventId);
      batch.update(eventRef, {
        'currentAttendees': FieldValue.increment(1),
        'registeredUsers': FieldValue.arrayUnion([registration.userId]),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to register for event: $e');
    }
  }

  // Cancel event registration
  Future<void> cancelEventRegistration(String eventId, String userId) async {
    try {
      final registrations = await _firestore
          .collection(_registrationsCollection)
          .where('eventId', isEqualTo: eventId)
          .where('userId', isEqualTo: userId)
          .get();

      if (registrations.docs.isNotEmpty) {
        final batch = _firestore.batch();

        // Delete registration
        batch.delete(registrations.docs.first.reference);

        // Update event attendees count
        final eventRef = _firestore.collection(_collection).doc(eventId);
        batch.update(eventRef, {
          'currentAttendees': FieldValue.increment(-1),
          'registeredUsers': FieldValue.arrayRemove([userId]),
        });

        await batch.commit();
      }
    } catch (e) {
      throw Exception('Failed to cancel registration: $e');
    }
  }

  // Get event registrations
  Stream<List<EventRegistration>> getEventRegistrations(String eventId) {
    return _firestore
        .collection(_registrationsCollection)
        .where('eventId', isEqualTo: eventId)
        .orderBy('registeredAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => EventRegistration.fromFirestore(doc))
          .toList();
    });
  }

  // Check if user is registered for event
  Future<bool> isUserRegistered(String eventId, String userId) async {
    try {
      final registrations = await _firestore
          .collection(_registrationsCollection)
          .where('eventId', isEqualTo: eventId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      return registrations.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Upload event image
  Future<String> uploadEventImage(String eventId, Uint8List imageBytes, String fileName) async {
    try {
      final ref = _storage.ref().child('events/$eventId/$fileName');
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Delete event image
  Future<void> deleteEventImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Search events
  Stream<List<Event>> searchEvents(String query) {
    return _firestore
        .collection(_collection)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    });
  }

  // Get events by tag
  Stream<List<Event>> getEventsByTag(String tag) {
    return _firestore
        .collection(_collection)
        .where('tags', arrayContains: tag)
        .orderBy('dateTime')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    });
  }

  // Get event statistics
  Future<Map<String, dynamic>> getEventStats() async {
    try {
      final events = await _firestore.collection(_collection).get();
      final registrations = await _firestore.collection(_registrationsCollection).get();

      int totalEvents = events.docs.length;
      int upcomingEvents = events.docs.where((doc) {
        final data = doc.data();
        return data['status'] == EventStatus.upcoming.name;
      }).length;
      int totalRegistrations = registrations.docs.length;

      return {
        'totalEvents': totalEvents,
        'upcomingEvents': upcomingEvents,
        'completedEvents': totalEvents - upcomingEvents,
        'totalRegistrations': totalRegistrations,
      };
    } catch (e) {
      throw Exception('Failed to get event stats: $e');
    }
  }

  // Get all events as a stream
  Stream<List<Event>> getEvents() {
    return Stream.value(_mockEvents);
  }

  // Get published events only
  Stream<List<Event>> getPublishedEvents() {
    return Stream.value(_mockEvents.where((e) => e.isPublished).toList());
  }

  // Get event by ID
  Future<Event?> getEventByIdMock(String id) async {
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