import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spaghetti/l10n/generated/app_localizations.dart';
import 'package:flutter_spaghetti/models/crypto_quote_model.dart';
import 'package:flutter_spaghetti/notifiers/crypto_quote_notifier.dart';
import 'package:flutter_spaghetti/screens/tabs/favorites_tab.dart';
import 'package:flutter_spaghetti/screens/tabs/quotes_tab.dart';
import 'package:flutter_spaghetti/screens/widgets/drawer_widget.dart';
import 'package:flutter_spaghetti/states/crypto_quote_state.dart';
import 'package:provider/provider.dart';

/// The home screen of the application.
@RoutePage()
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen] instance.
  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final CryptoQuoteState state = context.watch<CryptoQuoteNotifier>().state;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crypto Quotes'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.show_chart),
                text: AppLocalizations.of(context).quotes,
              ),
              Tab(
                icon: const Icon(Icons.star_outline),
                text: AppLocalizations.of(context).favorites,
              ),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: switch (state) {
          CryptoQuoteStateLoading() => const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          CryptoQuoteStateFailure(:final String message) => Center(
            child: Text(message),
          ),
          CryptoQuoteStateSuccess(
            :final List<CryptoQuote> quotes,
            :final bool fromCache,
          ) =>
            Column(
              children: <Widget>[
                if (fromCache) const _CacheBanner(),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      QuotesTab(quotes: quotes),
                      FavoritesTab(quotes: quotes),
                    ],
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}

class _CacheBanner extends StatelessWidget {
  const _CacheBanner();

  @override
  Widget build(final BuildContext context) => Container(
    width: double.infinity,
    color: Colors.amber.shade100,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: const Row(
      children: <Widget>[
        Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
        SizedBox(width: 8),
        Text(
          'Dados do cache — sem conexão',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
