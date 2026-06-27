import 'package:flutter/material.dart';

/// Color palette for the application, inspired by financial terminals such as
/// Bloomberg and TradingView. Uses a dark base with green/red accents for
/// price movements.
abstract final class AppColors {
  /// The background color for the app.
  static const Color background = Color(0xFF0D1117);

  /// The color used for surfaces such as cards and panels.
  static const Color surface = Color(0xFF161B22);

  /// The color used for surfaces such as cards and panels in the dark theme.
  static const Color surfaceVariant = Color(0xFF1C2128);

  /// The primary accent color for the app, used for buttons, highlights, and
  static const Color primary = Color(0xFF00C896);

  /// A muted version of the primary accent color, used for disabled states and
  static const Color primaryMuted = Color(0x1A00C896);

  /// The color used to indicate positive price movements (e.g. green).
  static const Color positive = Color(0xFF00C896);

  /// A muted version of the positive color, used for disabled states and
  static const Color positiveMuted = Color(0x1A00C896);

  /// The color used to indicate negative price movements (e.g. red).
  static const Color negative = Color(0xFFFF4560);

  /// A muted version of the negative color, used for disabled states and
  static const Color negativeMuted = Color(0x1AFF4560);

  /// The primary text color for the app
  static const Color textPrimary = Color(0xFFE6EDF3);

  /// The secondary text color for the app.
  static const Color textSecondary = Color(0xFF7D8590);

  /// The color used for disabled text and icons.
  static const Color textDisabled = Color(0xFF484F58);

  /// The color used for borders and dividers.
  static const Color border = Color(0xFF21262D);
}
