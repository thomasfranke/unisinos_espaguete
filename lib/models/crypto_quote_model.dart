/// Model class representing a cryptocurrency quote.
class CryptoQuote {
  /// Creates a [CryptoQuote] with the given parameters.
  CryptoQuote({
    required this.symbol,
    required this.lastPrice,
    required this.priceChange,
    required this.priceChangePct,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    required this.quoteVolume,
  });

  /// Creates a [CryptoQuote] from a JSON map.
  factory CryptoQuote.fromJson(Map<String, dynamic> json) => CryptoQuote(
    symbol: json['symbol'] as String? ?? '',
    lastPrice: double.tryParse(json['lastPrice'] as String? ?? '') ?? 0.0,
    priceChange: double.tryParse(json['priceChange'] as String? ?? '') ?? 0.0,
    priceChangePct:
        double.tryParse(json['priceChangePercent'] as String? ?? '') ?? 0.0,
    highPrice: double.tryParse(json['highPrice'] as String? ?? '') ?? 0.0,
    lowPrice: double.tryParse(json['lowPrice'] as String? ?? '') ?? 0.0,
    volume: double.tryParse(json['volume'] as String? ?? '') ?? 0.0,
    quoteVolume: double.tryParse(json['quoteVolume'] as String? ?? '') ?? 0.0,
  );

  /// The symbol of the cryptocurrency (e.g., "BTCUSDT").
  final String symbol;

  /// The last traded price of the cryptocurrency.
  final double lastPrice;

  /// The absolute price change since the last update.
  final double priceChange;

  /// The percentage price change since the last update.
  final double priceChangePct;

  /// The highest price of the cryptocurrency in the last 24 hours.
  final double highPrice;

  /// The lowest price of the cryptocurrency in the last 24 hours.
  final double lowPrice;

  /// The trading volume of the cryptocurrency in the last 24 hours.
  final double volume;

  /// The quote volume of the cryptocurrency in the last 24 hours.
  final double quoteVolume;
}
