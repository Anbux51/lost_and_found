import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campus_lost_found/core/constants/firestore_collections.dart';
import 'package:campus_lost_found/core/enums/user_role.dart';
import 'package:campus_lost_found/core/errors/app_exception.dart';
import 'package:campus_lost_found/features/auth/domain/app_user.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Stream<User?> userChanges() => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signUp({
    required String name,
    required String campusId,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    // Admins are never created through sign-up.
    if (role == UserRole.admin) {
      throw const AppException('Invalid role selected.');
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      final user = credential.user!;

      try {
        await _db.collection(FirestoreCollections.users).doc(user.uid).set({
          'name': name.trim(),
          'campusId': campusId.trim(),
          'email': user.email,
          'role': role.value,
          'isSuspended': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } on FirebaseException {
        // Roll back the auth account so the email is not left half-registered.
        await user.delete();
        throw const AppException('Could not create your profile. Please try again.');
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuth(e);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      final profile = await fetchProfile(credential.user!.uid);

      if (profile.isSuspended) {
        await _auth.signOut();
        throw const AppException(
          'This account has been suspended. Contact the campus administrator.',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuth(e);
    }
  }

  Future<AppUser> fetchProfile(String uid) async {
    final doc = await _db.collection(FirestoreCollections.users).doc(uid).get();
    return AppUser.fromFirestore(doc);
  }

  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) throw const AppException('Please sign in again.');
    await user.sendEmailVerification();
  }

  /// Reloads the user from Firebase and returns whether the email is verified.
  Future<bool> refreshVerificationStatus() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuth(e);
    }
  }

  Future<void> signOut() => _auth.signOut();
}