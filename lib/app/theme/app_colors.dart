import 'package:material_ui/material_ui.dart';

abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF0F766E);
  static const primaryContainer = Color(0xFFCCFBF1);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFF59E0B);
  static const error = Color(0xFFB42318);
  static const success = Color(0xFF15803D);

  // Surfaces
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF1F5F9);
  static const outline = Color(0xFFE2E8F0);

  // Text
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textDisabled = Color(0xFF94A3B8);

  // Item status badges (always paired with a text label)
  static const statusOpen = Color(0xFF2563EB);
  static const statusUnderReview = Color(0xFFD97706);
  static const statusClaimed = Color(0xFF7C3AED);
  static const statusReturned = Color(0xFF15803D);
}