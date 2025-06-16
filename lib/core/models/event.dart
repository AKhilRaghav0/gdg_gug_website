import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String? imageUrl;
  final String category;
  final int maxAttendees;
  final int currentAttendees;
  final int registeredCount;
  final String status;
  final String duration;
  final String? registrationUrl;
  final bool isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;
  final String? organizer;
  final double? fee;
  final bool isOnline;
  final String? meetingLink;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.imageUrl,
    required this.category,
    required this.maxAttendees,
    required this.currentAttendees,
    int? registeredCount,
    this.status = 'Upcoming',
    this.duration = '2 hours',
    this.registrationUrl,
    required this.isPublished,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.organizer,
    this.fee,
    this.isOnline = false,
    this.meetingLink,
  }) : registeredCount = registeredCount ?? currentAttendees;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
      maxAttendees: json['maxAttendees'] as int,
      currentAttendees: json['currentAttendees'] as int,
      registeredCount: json['registeredCount'] as int? ?? json['currentAttendees'] as int,
      status: json['status'] as String? ?? 'Upcoming',
      duration: json['duration'] as String? ?? '2 hours',
      registrationUrl: json['registrationUrl'] as String?,
      isPublished: json['isPublished'] as bool,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      organizer: json['organizer'] as String?,
      fee: json['fee'] as double?,
      isOnline: json['isOnline'] as bool? ?? false,
      meetingLink: json['meetingLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'imageUrl': imageUrl,
      'category': category,
      'maxAttendees': maxAttendees,
      'currentAttendees': currentAttendees,
      'registeredCount': registeredCount,
      'status': status,
      'duration': duration,
      'registrationUrl': registrationUrl,
      'isPublished': isPublished,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'tags': tags,
      'organizer': organizer,
      'fee': fee,
      'isOnline': isOnline,
      'meetingLink': meetingLink,
    };
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    String? imageUrl,
    String? category,
    int? maxAttendees,
    int? currentAttendees,
    int? registeredCount,
    String? status,
    String? duration,
    String? registrationUrl,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    String? organizer,
    double? fee,
    bool? isOnline,
    String? meetingLink,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      currentAttendees: currentAttendees ?? this.currentAttendees,
      registeredCount: registeredCount ?? this.registeredCount,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      registrationUrl: registrationUrl ?? this.registrationUrl,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      organizer: organizer ?? this.organizer,
      fee: fee ?? this.fee,
      isOnline: isOnline ?? this.isOnline,
      meetingLink: meetingLink ?? this.meetingLink,
    );
  }

  bool get isFull => currentAttendees >= maxAttendees;
  bool get hasSpots => currentAttendees < maxAttendees;
  int get spotsLeft => maxAttendees - currentAttendees;
  bool get isPast => date.isBefore(DateTime.now());
  bool get isUpcoming => date.isAfter(DateTime.now());
  bool get isFree => fee == null || fee == 0.0;

  // Firestore serialization methods
  factory Event.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Event(
      id: documentId,
      title: data['title'] as String,
      description: data['description'] as String,
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] as String,
      imageUrl: data['imageUrl'] as String?,
      category: data['category'] as String,
      maxAttendees: data['maxAttendees'] as int,
      currentAttendees: data['currentAttendees'] as int,
      registeredCount: data['registeredCount'] as int? ?? data['currentAttendees'] as int,
      status: data['status'] as String? ?? 'Upcoming',
      duration: data['duration'] as String? ?? '2 hours',
      registrationUrl: data['registrationUrl'] as String?,
      isPublished: data['isPublished'] as bool,
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      organizer: data['organizer'] as String?,
      fee: data['fee'] as double?,
      isOnline: data['isOnline'] as bool? ?? false,
      meetingLink: data['meetingLink'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'location': location,
      'imageUrl': imageUrl,
      'category': category,
      'maxAttendees': maxAttendees,
      'currentAttendees': currentAttendees,
      'registeredCount': registeredCount,
      'status': status,
      'duration': duration,
      'registrationUrl': registrationUrl,
      'isPublished': isPublished,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'tags': tags,
      'organizer': organizer,
      'fee': fee,
      'isOnline': isOnline,
      'meetingLink': meetingLink,
    };
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