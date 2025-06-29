import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static const String _usersCollection = 'users';
  static const String _allowedEmailsCollection = 'allowed_admins';

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Get current app user
  Future<AppUser?> getCurrentAppUser() async {
    final user = currentUser;
    if (user == null) return null;

    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      photoUrl: user.photoURL,
      isAdmin: await _checkIsAdmin(user.email),
    );
  }

  // Check if user is admin
  Future<bool> _checkIsAdmin(String? email) async {
    // For development, you can add admin emails here
    const adminEmails = [
      'admin@gdggug.com',
      'gdg@gug.ac.in',
    ];
    return email != null && adminEmails.map((e) => e.toLowerCase()).contains(email.toLowerCase());
  }

  // Check if email is allowed for admin access
  Future<bool> isEmailAllowedForAdmin(String email) async {
    try {
      final doc = await _firestore
          .collection(_allowedEmailsCollection)
          .doc(email)
          .get();
      return doc.exists && (doc.data()?['isActive'] ?? false);
    } catch (e) {
      return false;
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // Create or update user in Firestore
  Future<void> _createOrUpdateUser(User firebaseUser) async {
    try {
      final userDoc = _firestore.collection(_usersCollection).doc(firebaseUser.uid);
      final doc = await userDoc.get();

      final now = DateTime.now();

      if (doc.exists) {
        // Update existing user
        await userDoc.update({
          'name': firebaseUser.displayName ?? '',
          'imageUrl': firebaseUser.photoURL ?? '',
          'lastLoginAt': Timestamp.fromDate(now),
          'updatedAt': Timestamp.fromDate(now),
        });
      } else {
        // Create new user
        final appUser = AppUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? '',
          imageUrl: firebaseUser.photoURL ?? '',
          role: UserRole.admin, // Default role for new admin users
          permissions: [
            Permission.read,
            Permission.write,
            Permission.manageEvents,
            Permission.manageTeam,
            Permission.manageContent,
          ],
          isActive: true,
          createdAt: now,
          updatedAt: now,
          lastLoginAt: now,
          preferences: {},
        );

        await userDoc.set(appUser.toFirestore());
      }
    } catch (e) {
      throw Exception('Failed to create/update user: $e');
    }
  }

  // Update user role and permissions (super admin only)
  Future<void> updateUserPermissions(
    String userId,
    UserRole newRole,
    List<Permission> newPermissions,
  ) async {
    try {
      final currentAppUser = await getCurrentAppUser();
      if (currentAppUser?.role != UserRole.superAdmin) {
        throw Exception('Only super admins can update user permissions');
      }

      await _firestore.collection(_usersCollection).doc(userId).update({
        'role': newRole.name,
        'permissions': newPermissions.map((p) => p.name).toList(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update user permissions: $e');
    }
  }

  // Add allowed admin email (super admin only)
  Future<void> addAllowedAdminEmail(String email, UserRole role) async {
    try {
      final currentAppUser = await getCurrentAppUser();
      if (currentAppUser?.role != UserRole.superAdmin) {
        throw Exception('Only super admins can add allowed emails');
      }

      await _firestore.collection(_allowedEmailsCollection).doc(email).set({
        'email': email,
        'role': role.name,
        'isActive': true,
        'addedBy': currentAppUser!.id,
        'addedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to add allowed admin email: $e');
    }
  }

  // Remove allowed admin email (super admin only)
  Future<void> removeAllowedAdminEmail(String email) async {
    try {
      final currentAppUser = await getCurrentAppUser();
      if (currentAppUser?.role != UserRole.superAdmin) {
        throw Exception('Only super admins can remove allowed emails');
      }

      await _firestore.collection(_allowedEmailsCollection).doc(email).delete();
    } catch (e) {
      throw Exception('Failed to remove allowed admin email: $e');
    }
  }

  // Get all users (admin only)
  Stream<List<AppUser>> getAllUsers() {
    return _firestore
        .collection(_usersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => AppUser.fromFirestore(doc, null)).toList();
    });
  }

  // Get allowed admin emails (super admin only)
  Stream<List<Map<String, dynamic>>> getAllowedAdminEmails() {
    return _firestore
        .collection(_allowedEmailsCollection)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'email': data['email'],
          'role': data['role'],
          'isActive': data['isActive'],
          'addedBy': data['addedBy'],
          'addedAt': data['addedAt'],
        };
      }).toList();
    });
  }

  // Check if current user has permission
  Future<bool> hasPermission(Permission permission) async {
    final appUser = await getCurrentAppUser();
    return appUser?.hasPermission(permission) ?? false;
  }

  // Deactivate user (super admin only)
  Future<void> deactivateUser(String userId) async {
    try {
      final currentAppUser = await getCurrentAppUser();
      if (currentAppUser?.role != UserRole.superAdmin) {
        throw Exception('Only super admins can deactivate users');
      }

      await _firestore.collection(_usersCollection).doc(userId).update({
        'isActive': false,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to deactivate user: $e');
    }
  }

  // Reactivate user (super admin only)
  Future<void> reactivateUser(String userId) async {
    try {
      final currentAppUser = await getCurrentAppUser();
      if (currentAppUser?.role != UserRole.superAdmin) {
        throw Exception('Only super admins can reactivate users');
      }

      await _firestore.collection(_usersCollection).doc(userId).update({
        'isActive': true,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to reactivate user: $e');
    }
  }
} 