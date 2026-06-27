import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_spaghetti/models/user_preferences_model.dart';
import 'package:flutter_spaghetti/states/preferences_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A notifier class for managing the state of user preferences.
class PreferencesNotifier extends ChangeNotifier {
  /// Creates a [PreferencesNotifier] instance and loads the user preferences.
  PreferencesNotifier() {
    unawaited(loadPreferences());
  }

  PreferencesState _state = const PreferencesStateLoading();

  /// Gets the current state of user preferences.
  PreferencesState get state => _state;

  /// Loads the user preferences from shared preferences and updates
  /// the state accordingly.
  Future<void> loadPreferences() async {
    _state = const PreferencesStateLoading();
    notifyListeners();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _state = PreferencesStateSuccess(
        UserPreferences(
          locale: prefs.getString('pref_locale') ?? 'pt',
          darkMode: prefs.getBool('pref_dark_mode') ?? false,
          fontScale: prefs.getDouble('pref_font_scale') ?? 1.0,
        ),
      );
    } on Object catch (e) {
      _state = PreferencesStateFailure(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Updates the locale preference and reloads the user preferences.
  Future<void> updateLocale(final String locale) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('pref_locale', locale);
      await loadPreferences();
    } on Object catch (e) {
      _state = PreferencesStateFailure(e.toString());
      notifyListeners();
    }
  }

  /// Updates the dark mode preference and reloads the user preferences.
  Future<void> updateDarkMode(final bool darkMode) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pref_dark_mode', darkMode);
      await loadPreferences();
    } on Object catch (e) {
      _state = PreferencesStateFailure(e.toString());
      notifyListeners();
    }
  }

  /// Updates the font scale preference and reloads the user preferences.
  Future<void> updateFontScale(final double fontScale) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('pref_font_scale', fontScale);
      await loadPreferences();
    } on Object catch (e) {
      _state = PreferencesStateFailure(e.toString());
      notifyListeners();
    }
  }
}
