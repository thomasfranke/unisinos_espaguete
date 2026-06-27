import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_spaghetti/states/favorites_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A notifier class for managing the state of user favorites.
class FavoritesNotifier extends ChangeNotifier {
  /// Creates a [FavoritesNotifier] instance and loads the user favorites.
  FavoritesNotifier() {
    unawaited(loadFavorites());
  }

  FavoritesState _state = const FavoritesStateLoading();

  /// Gets the current state of user favorites.
  FavoritesState get state => _state;

  /// Loads the user favorites from shared preferences and updates
  /// the state accordingly.
  Future<void> loadFavorites() async {
    _state = const FavoritesStateLoading();
    notifyListeners();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _state = FavoritesStateSuccess(
        prefs.getStringList('favorites') ?? <String>[],
      );
    } on Object catch (e) {
      _state = FavoritesStateFailure(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Toggles the favorite status of a given symbol and updates
  /// the state accordingly.
  Future<void> toggleFavorite(final String symbol) async {
    try {
      final List<String> current = switch (_state) {
        FavoritesStateSuccess(:final List<String> favorites) =>
          List<String>.from(favorites),
        _ => <String>[],
      };

      if (current.contains(symbol)) {
        current.remove(symbol);
      } else {
        current.add(symbol);
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites', current);
      _state = FavoritesStateSuccess(current);
    } on Object catch (e) {
      _state = FavoritesStateFailure(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Checks if a given symbol is in the list of user favorites.
  bool isFavorite(final String symbol) => switch (_state) {
    FavoritesStateSuccess(:final List<String> favorites) => favorites.contains(
      symbol,
    ),
    _ => false,
  };
}
