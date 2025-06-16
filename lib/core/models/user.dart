import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String? imageUrl;
  final UserRole role;
  final List<Permission> permissions;
  final bool isAdmin;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic> preferences;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.imageUrl,
    this.role = UserRole.user,
    this.permissions = const [],
    this.isAdmin = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.preferences = const {},
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.user,
      ),
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((p) => Permission.values.firstWhere(
            (e) => e.toString() == 'Permission.$p',
            orElse: () => Permission.read,
          ))
          .toList() ?? [],
      isAdmin: json['isAdmin'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      preferences: json['preferences'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'imageUrl': imageUrl,
      'role': role.toString().split('.').last,
      'permissions': permissions.map((p) => p.toString().split('.').last).toList(),
      'isAdmin': isAdmin,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'preferences': preferences,
    };
  }

  // Firestore methods
  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    final data = doc.data()!;
    data['id'] = doc.id;
    return AppUser.fromJson(data);
  }

  Map<String, dynamic> toFirestore() {
    return toJson();
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? imageUrl,
    UserRole? role,
    List<Permission>? permissions,
    bool? isAdmin,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? preferences,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
    );
  }

  bool hasPermission(Permission permission) {
    if (isAdmin) return true;
    return permissions.contains(permission);
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