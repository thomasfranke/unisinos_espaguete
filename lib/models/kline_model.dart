/// A model class representing a Kline (candlestick) data point.
class Kline {
  /// Creates a [Kline] instance with the given parameters.
  Kline({
    required this.openTime,
    required this.closeTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.numberOfTrades,
  });

  /// Creates a [Kline] instance from a list of dynamic values.
  factory Kline.fromList(List<dynamic> list) => Kline(
    openTime: DateTime.fromMillisecondsSinceEpoch(list[0] as int),
    closeTime: DateTime.fromMillisecondsSinceEpoch(list[6] as int),
    open: double.tryParse(list[1] as String) ?? 0.0,
    high: double.tryParse(list[2] as String) ?? 0.0,
    low: double.tryParse(list[3] as String) ?? 0.0,
    close: double.tryParse(list[4] as String) ?? 0.0,
    volume: double.tryParse(list[5] as String) ?? 0.0,
    numberOfTrades: list[8] as int,
  );

  /// The time when the Kline opened.
  final DateTime openTime;

  /// The time when the Kline closed.
  final DateTime closeTime;

  /// The opening price of the Kline.
  final double open;

  /// The highest price of the Kline.
  final double high;

  /// The lowest price of the Kline.
  final double low;

  /// The closing price of the Kline.
  final double close;

  /// The trading volume during the Kline period.
  final double volume;

  /// The number of trades during the Kline period.
  final int numberOfTrades;
}
