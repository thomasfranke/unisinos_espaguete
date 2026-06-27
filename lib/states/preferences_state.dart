import 'package:flutter_spaghetti/models/user_preferences_model.dart';

/// A notifier class for managing the state of user preferences.
sealed class PreferencesState {
  const PreferencesState();
}

/// A state representing that user preferences are being loaded.
class PreferencesStateLoading extends PreferencesState {
  /// Creates a [PreferencesStateLoading] instance.
  const PreferencesStateLoading();
}

/// A state representing that user preferences were successfully loaded.
class PreferencesStateSuccess extends PreferencesState {
  /// Creates a [PreferencesStateSuccess] instance.
  const PreferencesStateSuccess(this.preferences);

  /// The user preferences that were successfully loaded.
  final UserPreferences preferences;
}

/// A state representing that there was an error loading user preferences.
class PreferencesStateFailure extends PreferencesState {
  /// Creates a [PreferencesStateFailure] instance.
  const PreferencesStateFailure(this.message);

  /// The error message describing the failure to load user preferences.
  final String message;
}
