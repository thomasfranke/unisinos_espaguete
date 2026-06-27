import 'package:flutter_spaghetti/models/crypto_quote_model.dart';

/// A notifier class for managing the state of cryptocurrency quotes.
sealed class CryptoQuoteState {
  const CryptoQuoteState();
}

/// A state representing that cryptocurrency quotes are being loaded.
class CryptoQuoteStateLoading extends CryptoQuoteState {
  /// Creates a [CryptoQuoteStateLoading] instance.
  const CryptoQuoteStateLoading();
}

/// A state representing that cryptocurrency quotes were successfully loaded.
class CryptoQuoteStateSuccess extends CryptoQuoteState {
  /// Creates a [CryptoQuoteStateSuccess] instance.
  const CryptoQuoteStateSuccess(this.quotes, {this.fromCache = false});

  /// The list of cryptocurrency quotes that were successfully loaded.
  final List<CryptoQuote> quotes;

  /// Indicates whether the quotes were loaded from cache.
  final bool fromCache;
}

/// A state representing that there was an error loading cryptocurrency quotes.
class CryptoQuoteStateFailure extends CryptoQuoteState {
  /// Creates a [CryptoQuoteStateFailure] instance.
  const CryptoQuoteStateFailure(this.message);

  /// The error message describing the failure to load cryptocurrency quotes.
  final String message;
}
