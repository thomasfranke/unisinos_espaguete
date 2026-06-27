import 'package:flutter/material.dart';
import 'package:flutter_spaghetti/models/crypto_quote_model.dart';
import 'package:flutter_spaghetti/notifiers/crypto_quote_notifier.dart';
import 'package:flutter_spaghetti/notifiers/favorites_notifier.dart';
import 'package:flutter_spaghetti/screens/widgets/quote_list_tile.dart';
import 'package:flutter_spaghetti/states/favorites_state.dart';
import 'package:provider/provider.dart';

/// A tab that displays the user's favorite cryptocurrency quotes.
class FavoritesTab extends StatelessWidget {
  /// Creates a [FavoritesTab] widget with the given list of
  /// cryptocurrency quotes.
  const FavoritesTab({required this.quotes, super.key});

  /// The list of cryptocurrency quotes to be displayed in the tab.
  final List<CryptoQuote> quotes;

  @override
  Widget build(final BuildContext context) {
    final FavoritesState state = context.watch<FavoritesNotifier>().state;

    return switch (state) {
      FavoritesStateLoading() => const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      FavoritesStateFailure(:final String message) => Center(
        child: Text(message),
      ),
      FavoritesStateSuccess(:final List<String> favorites) => _buildList(
        context,
        favorites,
      ),
    };
  }

  Widget _buildList(final BuildContext context, final List<String> favorites) {
    final List<CryptoQuote> favoriteQuotes = quotes
        .where((final CryptoQuote q) => favorites.contains(q.symbol))
        .toList();

    if (favoriteQuotes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.star_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhum favorito ainda', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<CryptoQuoteNotifier>().fetchQuotes(),
      child: ListView.builder(
        itemCount: favoriteQuotes.length,
        itemBuilder: (_, int i) => QuoteTile(quote: favoriteQuotes[i]),
      ),
    );
  }
}
