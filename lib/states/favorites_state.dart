/// A notifier class for managing the state of user favorites.
sealed class FavoritesState {
  const FavoritesState();
}

/// A state representing that user favorites are being loaded.
class FavoritesStateLoading extends FavoritesState {
  /// Creates a [FavoritesStateLoading] instance.
  const FavoritesStateLoading();
}

/// A state representing that user favorites were successfully loaded.
class FavoritesStateSuccess extends FavoritesState {
  /// Creates a [FavoritesStateSuccess] instance.
  const FavoritesStateSuccess(this.favorites);

  /// The list of user favorites that were successfully loaded.
  final List<String> favorites;
}

/// A state representing that there was an error loading user favorites.
class FavoritesStateFailure extends FavoritesState {
  /// Creates a [FavoritesStateFailure] instance.
  const FavoritesStateFailure(this.message);

  /// The error message describing the failure to load user favorites.
  final String message;
}
