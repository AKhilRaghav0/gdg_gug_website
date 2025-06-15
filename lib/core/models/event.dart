import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final String imageUrl;
  final List<String> tags;
  final EventType type;
  final EventStatus status;
  final int maxAttendees;
  final int currentAttendees;
  final String organizerId;
  final String organizerName;
  final bool isRegistrationOpen;
  final DateTime registrationDeadline;
  final List<String> registeredUsers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> additionalInfo;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.imageUrl,
    required this.tags,
    required this.type,
    required this.status,
    required this.maxAttendees,
    required this.currentAttendees,
    required this.organizerId,
    required this.organizerName,
    required this.isRegistrationOpen,
    required this.registrationDeadline,
    required this.registeredUsers,
    required this.createdAt,
    required this.updatedAt,
    required this.additionalInfo,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'location': location,
      'imageUrl': imageUrl,
      'tags': tags,
      'type': type.name,
      'status': status.name,
      'maxAttendees': maxAttendees,
      'currentAttendees': currentAttendees,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'isRegistrationOpen': isRegistrationOpen,
      'registrationDeadline': Timestamp.fromDate(registrationDeadline),
      'registeredUsers': registeredUsers,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'additionalInfo': additionalInfo,
    };
  }

  // Create from Firestore document
  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      type: EventType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => EventType.workshop,
      ),
      status: EventStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => EventStatus.upcoming,
      ),
      maxAttendees: data['maxAttendees'] ?? 0,
      currentAttendees: data['currentAttendees'] ?? 0,
      organizerId: data['organizerId'] ?? '',
      organizerName: data['organizerName'] ?? '',
      isRegistrationOpen: data['isRegistrationOpen'] ?? false,
      registrationDeadline: (data['registrationDeadline'] as Timestamp).toDate(),
      registeredUsers: List<String>.from(data['registeredUsers'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      additionalInfo: Map<String, dynamic>.from(data['additionalInfo'] ?? {}),
    );
  }

  // Copy with method for updates
  Event copyWith({
    String? title,
    String? description,
    DateTime? dateTime,
    String? location,
    String? imageUrl,
    List<String>? tags,
    EventType? type,
    EventStatus? status,
    int? maxAttendees,
    int? currentAttendees,
    String? organizerId,
    String? organizerName,
    bool? isRegistrationOpen,
    DateTime? registrationDeadline,
    List<String>? registeredUsers,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalInfo,
  }) {
    return Event(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      type: type ?? this.type,
      status: status ?? this.status,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      currentAttendees: currentAttendees ?? this.currentAttendees,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      isRegistrationOpen: isRegistrationOpen ?? this.isRegistrationOpen,
      registrationDeadline: registrationDeadline ?? this.registrationDeadline,
      registeredUsers: registeredUsers ?? this.registeredUsers,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}

enum EventType {
  workshop,
  hackathon,
  meetup,
  conference,
  webinar,
  networking,
  competition,
  other
}

enum EventStatus {
  upcoming,
  ongoing,
  completed,
  cancelled,
  postponed
}

// Event Registration Model
class EventRegistration {
  final String id;
  final String eventId;
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime registeredAt;
  final Map<String, dynamic> additionalData;

  EventRegistration({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.registeredAt,
    required this.additionalData,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'registeredAt': Timestamp.fromDate(registeredAt),
      'additionalData': additionalData,
    };
  }

  factory EventRegistration.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventRegistration(
      id: doc.id,
      eventId: data['eventId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      registeredAt: (data['registeredAt'] as Timestamp).toDate(),
      additionalData: Map<String, dynamic>.from(data['additionalData'] ?? {}),
    );
  }
} 