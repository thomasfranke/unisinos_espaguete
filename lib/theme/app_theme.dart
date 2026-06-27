import 'package:flutter/material.dart';
import 'package:flutter_spaghetti/theme/app_colors.dart';

/// Application theme configuration, providing dark and light themes
/// inspired by financial terminals.
final class AppTheme {
  /// Dark theme configuration.
  ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.background,
      secondary: AppColors.primary,
      onSecondary: AppColors.background,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.negative,
      onError: AppColors.textPrimary,
    ),
  );

  /// Light theme configuration.
  ThemeData get light => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primary,
      surface: Colors.grey.shade50,
      onSurface: const Color(0xFF1A1A2E),
      error: AppColors.negative,
    ),
  );
}
