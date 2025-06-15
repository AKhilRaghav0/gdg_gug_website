import 'package:cloud_firestore/cloud_firestore.dart';

class TeamMember {
  final String id;
  final String name;
  final String role;
  final String bio;
  final String? imageUrl;
  final String email;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? twitterUrl;
  final String? instagramUrl;
  final bool isActive;
  final DateTime joinDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> skills;
  final String? phoneNumber;
  final String? department;
  final int? yearOfStudy;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.bio,
    this.imageUrl,
    required this.email,
    this.linkedinUrl,
    this.githubUrl,
    this.twitterUrl,
    this.instagramUrl,
    required this.isActive,
    required this.joinDate,
    this.createdAt,
    this.updatedAt,
    this.skills = const [],
    this.phoneNumber,
    this.department,
    this.yearOfStudy,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      bio: json['bio'] as String,
      imageUrl: json['imageUrl'] as String?,
      email: json['email'] as String,
      linkedinUrl: json['linkedinUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      twitterUrl: json['twitterUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      isActive: json['isActive'] as bool,
      joinDate: DateTime.parse(json['joinDate'] as String),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      skills: (json['skills'] as List<dynamic>?)?.cast<String>() ?? [],
      phoneNumber: json['phoneNumber'] as String?,
      department: json['department'] as String?,
      yearOfStudy: json['yearOfStudy'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'bio': bio,
      'imageUrl': imageUrl,
      'email': email,
      'linkedinUrl': linkedinUrl,
      'githubUrl': githubUrl,
      'twitterUrl': twitterUrl,
      'instagramUrl': instagramUrl,
      'isActive': isActive,
      'joinDate': joinDate.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'skills': skills,
      'phoneNumber': phoneNumber,
      'department': department,
      'yearOfStudy': yearOfStudy,
    };
  }

  TeamMember copyWith({
    String? id,
    String? name,
    String? role,
    String? bio,
    String? imageUrl,
    String? email,
    String? linkedinUrl,
    String? githubUrl,
    String? twitterUrl,
    String? instagramUrl,
    bool? isActive,
    DateTime? joinDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? skills,
    String? phoneNumber,
    String? department,
    int? yearOfStudy,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      twitterUrl: twitterUrl ?? this.twitterUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      isActive: isActive ?? this.isActive,
      joinDate: joinDate ?? this.joinDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      skills: skills ?? this.skills,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
    );
  }

  bool get hasLinkedIn => linkedinUrl != null && linkedinUrl!.isNotEmpty;
  bool get hasGitHub => githubUrl != null && githubUrl!.isNotEmpty;
  bool get hasTwitter => twitterUrl != null && twitterUrl!.isNotEmpty;
  bool get hasInstagram => instagramUrl != null && instagramUrl!.isNotEmpty;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  
  List<String> get socialLinks {
    final links = <String>[];
    if (hasLinkedIn) links.add(linkedinUrl!);
    if (hasGitHub) links.add(githubUrl!);
    if (hasTwitter) links.add(twitterUrl!);
    if (hasInstagram) links.add(instagramUrl!);
    return links;
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