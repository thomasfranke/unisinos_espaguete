import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spaghetti/models/crypto_quote_model.dart';
import 'package:flutter_spaghetti/notifiers/favorites_notifier.dart';
import 'package:flutter_spaghetti/routes/app_router.dart';
import 'package:provider/provider.dart';

/// A ListTile widget to display a crypto quote with price, change,
/// and favorite status.
class QuoteTile extends StatelessWidget {
  /// Creates a QuoteTile for the given [CryptoQuote].
  const QuoteTile({required this.quote, super.key});

  /// The crypto quote to display in this tile.
  final CryptoQuote quote;

  @override
  Widget build(final BuildContext context) {
    final bool isPositive = quote.priceChangePct >= 0;
    final bool isFavorite = context.watch<FavoritesNotifier>().isFavorite(
      quote.symbol,
    );

    return ListTile(
      title: Text(quote.symbol),
      subtitle: Text('Vol: ${quote.quoteVolume.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                quote.lastPrice.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '''${isPositive ? '+' : ''}${quote.priceChangePct.toStringAsFixed(2)}%''',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_outline,
              color: isFavorite ? Colors.amber : Colors.grey,
            ),
            onPressed: () =>
                context.read<FavoritesNotifier>().toggleFavorite(quote.symbol),
          ),
        ],
      ),
      onTap: () => context.router.push(DetailRoute(quote: quote)),
    );
  }
}
