import 'package:campus_lost_found/core/constants/app_constants.dart';

abstract final class Validators {
  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required.';
    }
    return null;
  }

  static String? campusEmail(String? value) {
    final email = value?.trim().toLowerCase() ?? '';
    if (email.isEmpty) return 'Campus email is required.';

    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(email)) return 'Enter a valid email address.';

    if (!email.endsWith('@${AppConstants.allowedEmailDomain}')) {
      return 'Use your official campus email (@${AppConstants.allowedEmailDomain}).';
    }
    return null;
  }

  static String? campusId(String? value) {
    final id = value?.trim() ?? '';
    if (id.isEmpty) return 'Campus ID is required.';
    if (id.length < 4) return 'Campus ID looks too short.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include at least one number.';
    }
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
      return 'Include at least one symbol.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirm your password.';
    if (value != password) return 'Passwords do not match.';
    return null;
  }
}