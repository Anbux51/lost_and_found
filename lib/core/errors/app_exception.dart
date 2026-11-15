import 'package:firebase_auth/firebase_auth.dart';

class AppException implements Exception {
  const AppException(this.message);

  final String message;

  factory AppException.fromAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return const AppException('An account already exists for this email.');
      case 'invalid-email':
        return const AppException('Enter a valid email address.');
      case 'weak-password':
        return const AppException('Choose a stronger password.');
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const AppException('Email or password is incorrect.');
      case 'too-many-requests':
        return const AppException('Too many attempts. Try again in a few minutes.');
      case 'network-request-failed':
        return const AppException('No internet connection. Check your network.');
      default:
        return const AppException('Something went wrong. Please try again.');
    }
  }

  @override
  String toString() => message;
}