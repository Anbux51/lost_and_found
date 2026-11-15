import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_lost_found/core/enums/user_role.dart';

class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.campusId,
    required this.email,
    required this.role,
    required this.isSuspended,
    required this.createdAt,
  });

  final String uid;
  final String name;
  final String campusId;
  final String email;
  final UserRole role;
  final bool isSuspended;
  final DateTime createdAt;

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('User document ${doc.id} has no data.');
    }

    final role = UserRole.tryFrom(data['role'] as String?);
    if (role == null) {
      throw StateError('User ${doc.id} has an invalid role.');
    }

    return AppUser(
      uid: doc.id,
      name: data['name'] as String,
      campusId: data['campusId'] as String,
      email: data['email'] as String,
      role: role,
      isSuspended: data['isSuspended'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'campusId': campusId,
      'email': email,
      'role': role.value,
      'isSuspended': isSuspended,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}