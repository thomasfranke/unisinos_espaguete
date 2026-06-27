import 'package:flutter_spaghetti/models/kline_model.dart';

/// A notifier class for managing the state of cryptocurrency klines.
sealed class KlineState {
  const KlineState();
}

/// A state representing that cryptocurrency klines are being loaded.
class KlineStateLoading extends KlineState {
  /// Creates a [KlineStateLoading] instance.
  const KlineStateLoading();
}

/// A state representing that cryptocurrency klines were successfully loaded.
class KlineStateSuccess extends KlineState {
  /// Creates a [KlineStateSuccess] instance.
  const KlineStateSuccess(this.klines);

  /// The list of cryptocurrency klines that were successfully loaded.
  final List<Kline> klines;
}

/// A state representing that there was an error loading cryptocurrency klines.
class KlineStateFailure extends KlineState {
  /// Creates a [KlineStateFailure] instance.
  const KlineStateFailure(this.message);

  /// The error message describing the failure to load cryptocurrency klines.
  final String message;
}
