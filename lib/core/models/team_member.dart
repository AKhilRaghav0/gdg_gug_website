import 'package:cloud_firestore/cloud_firestore.dart';

class TeamMember {
  final String id;
  final String name;
  final String role;
  final String bio;
  final String imageUrl;
  final SocialLinks socialLinks;
  final TeamCategory category;
  final int order;
  final bool isActive;
  final DateTime joinDate;
  final String email;
  final String phone;
  final List<String> skills;
  final List<String> achievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.bio,
    required this.imageUrl,
    required this.socialLinks,
    required this.category,
    required this.order,
    required this.isActive,
    required this.joinDate,
    required this.email,
    required this.phone,
    required this.skills,
    required this.achievements,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'role': role,
      'bio': bio,
      'imageUrl': imageUrl,
      'socialLinks': socialLinks.toMap(),
      'category': category.name,
      'order': order,
      'isActive': isActive,
      'joinDate': Timestamp.fromDate(joinDate),
      'email': email,
      'phone': phone,
      'skills': skills,
      'achievements': achievements,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory TeamMember.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TeamMember(
      id: doc.id,
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      bio: data['bio'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      socialLinks: SocialLinks.fromMap(data['socialLinks'] ?? {}),
      category: TeamCategory.values.firstWhere(
        (e) => e.name == data['category'],
        orElse: () => TeamCategory.member,
      ),
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
      joinDate: (data['joinDate'] as Timestamp).toDate(),
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      achievements: List<String>.from(data['achievements'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  TeamMember copyWith({
    String? name,
    String? role,
    String? bio,
    String? imageUrl,
    SocialLinks? socialLinks,
    TeamCategory? category,
    int? order,
    bool? isActive,
    DateTime? joinDate,
    String? email,
    String? phone,
    List<String>? skills,
    List<String>? achievements,
    DateTime? updatedAt,
  }) {
    return TeamMember(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      socialLinks: socialLinks ?? this.socialLinks,
      category: category ?? this.category,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      joinDate: joinDate ?? this.joinDate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      skills: skills ?? this.skills,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class SocialLinks {
  final String linkedin;
  final String twitter;
  final String github;
  final String instagram;
  final String youtube;
  final String portfolio;
  final String medium;
  final String discord;

  SocialLinks({
    this.linkedin = '',
    this.twitter = '',
    this.github = '',
    this.instagram = '',
    this.youtube = '',
    this.portfolio = '',
    this.medium = '',
    this.discord = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'linkedin': linkedin,
      'twitter': twitter,
      'github': github,
      'instagram': instagram,
      'youtube': youtube,
      'portfolio': portfolio,
      'medium': medium,
      'discord': discord,
    };
  }

  factory SocialLinks.fromMap(Map<String, dynamic> map) {
    return SocialLinks(
      linkedin: map['linkedin'] ?? '',
      twitter: map['twitter'] ?? '',
      github: map['github'] ?? '',
      instagram: map['instagram'] ?? '',
      youtube: map['youtube'] ?? '',
      portfolio: map['portfolio'] ?? '',
      medium: map['medium'] ?? '',
      discord: map['discord'] ?? '',
    );
  }

  SocialLinks copyWith({
    String? linkedin,
    String? twitter,
    String? github,
    String? instagram,
    String? youtube,
    String? portfolio,
    String? medium,
    String? discord,
  }) {
    return SocialLinks(
      linkedin: linkedin ?? this.linkedin,
      twitter: twitter ?? this.twitter,
      github: github ?? this.github,
      instagram: instagram ?? this.instagram,
      youtube: youtube ?? this.youtube,
      portfolio: portfolio ?? this.portfolio,
      medium: medium ?? this.medium,
      discord: discord ?? this.discord,
    );
  }
}

enum TeamCategory {
  leadership,
  technical,
  marketing,
  design,
  content,
  event,
  member,
  alumni
} 