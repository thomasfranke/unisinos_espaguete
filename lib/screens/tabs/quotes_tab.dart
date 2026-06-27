import 'package:flutter/material.dart';
import 'package:flutter_spaghetti/l10n/generated/app_localizations.dart';
import 'package:flutter_spaghetti/models/crypto_quote_model.dart';
import 'package:flutter_spaghetti/notifiers/crypto_quote_notifier.dart';
import 'package:flutter_spaghetti/screens/widgets/quote_list_tile.dart';
import 'package:provider/provider.dart';

/// A tab widget that displays a list of cryptocurrency quotes with
/// a filter option.
class QuotesTab extends StatefulWidget {
  /// Creates a [QuotesTab] widget with the given list of cryptocurrency quotes.
  const QuotesTab({required this.quotes, super.key});

  /// The list of cryptocurrency quotes to be displayed in the tab.
  final List<CryptoQuote> quotes;

  @override
  State<QuotesTab> createState() => _QuotesTabState();
}

class _QuotesTabState extends State<QuotesTab> {
  final TextEditingController _controller = TextEditingController();
  List<CryptoQuote> _filtered = <CryptoQuote>[];

  @override
  void initState() {
    super.initState();
    _filtered = widget.quotes;
    _controller.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    final String query = _controller.text.trim().toUpperCase();
    setState(() {
      _filtered = query.isEmpty
          ? widget.quotes
          : widget.quotes
                .where((final CryptoQuote q) => q.symbol.contains(query))
                .toList();
    });
  }

  @override
  Widget build(final BuildContext context) => Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _controller,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).filterBySymbol,
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: () => context.read<CryptoQuoteNotifier>().fetchQuotes(),
          child: ListView.builder(
            itemCount: _filtered.length,
            itemBuilder: (_, int i) => QuoteTile(quote: _filtered[i]),
          ),
        ),
      ),
    ],
  );
}
