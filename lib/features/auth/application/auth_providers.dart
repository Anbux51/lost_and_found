import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_lost_found/core/constants/firestore_collections.dart';
import 'package:campus_lost_found/features/auth/data/auth_repository.dart';
import 'package:campus_lost_found/features/auth/domain/app_user.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

/// Firebase Auth user (null when signed out).
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// Firestore profile for the signed-in user (null when signed out).
final currentProfileProvider = StreamProvider<AppUser?>((ref) {
  final authUser = ref.watch(authStateProvider).asData?.value;
  if (authUser == null) return Stream.value(null);

  final db = ref.watch(firestoreProvider);
  return db
      .collection(FirestoreCollections.users)
      .doc(authUser.uid)
      .snapshots()
      .map((doc) => doc.exists ? AppUser.fromFirestore(doc) : null);
});