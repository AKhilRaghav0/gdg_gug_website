import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String name;
  final String imageUrl;
  final UserRole role;
  final List<Permission> permissions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic> preferences;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.imageUrl,
    required this.role,
    required this.permissions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    required this.preferences,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'imageUrl': imageUrl,
      'role': role.name,
      'permissions': permissions.map((p) => p.name).toList(),
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'preferences': preferences,
    };
  }

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => UserRole.user,
      ),
      permissions: (data['permissions'] as List<dynamic>?)
              ?.map((p) => Permission.values.firstWhere(
                    (e) => e.name == p,
                    orElse: () => Permission.read,
                  ))
              .toList() ??
          [],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastLoginAt: data['lastLoginAt'] != null
          ? (data['lastLoginAt'] as Timestamp).toDate()
          : null,
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
    );
  }

  AppUser copyWith({
    String? email,
    String? name,
    String? imageUrl,
    UserRole? role,
    List<Permission>? permissions,
    bool? isActive,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? preferences,
  }) {
    return AppUser(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
    );
  }

  bool hasPermission(Permission permission) {
    return permissions.contains(permission) || role == UserRole.superAdmin;
  }

  bool canManageEvents() {
    return hasPermission(Permission.manageEvents);
  }

  bool canManageTeam() {
    return hasPermission(Permission.manageTeam);
  }

  bool canManageUsers() {
    return hasPermission(Permission.manageUsers);
  }

  bool canManageContent() {
    return hasPermission(Permission.manageContent);
  }
}

enum UserRole {
  user,
  editor,
  admin,
  superAdmin
}

enum Permission {
  read,
  write,
  manageEvents,
  manageTeam,
  manageUsers,
  manageContent,
  viewAnalytics,
  systemSettings
} 