/// A model class representing user preferences.
class UserPreferences {
  /// Creates a [UserPreferences] instance with the given parameters.
  UserPreferences({
    this.locale = 'pt',
    this.darkMode = false,
    this.fontScale = 1.0,
  });

  /// The locale of the app (e.g., 'en', 'pt').
  String locale;

  /// Whether the app is in dark mode.
  bool darkMode;

  /// The font scale factor for the app.
  double fontScale;
}
