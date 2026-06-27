import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spaghetti/models/kline_model.dart';
import 'package:flutter_spaghetti/states/kline_state.dart';

/// A notifier class for managing the state of cryptocurrency klines.
class KlineNotifier extends ChangeNotifier {
  /// Creates a [KlineNotifier] instance and loads the initial klines for the
  KlineNotifier({required String symbol}) {
    unawaited(loadKlines(symbol: symbol, interval: _interval));
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://data-api.binance.vision'));

  KlineState _state = const KlineStateLoading();

  /// Gets the current state of cryptocurrency klines.
  KlineState get state => _state;

  String _interval = '1h';

  /// Gets the current interval for cryptocurrency klines.
  String get currentInterval => _interval;

  /// Loads the cryptocurrency klines from the API for the given
  /// symbol and interval,
  Future<void> loadKlines({
    required final String symbol,
    required final String interval,
  }) async {
    _state = const KlineStateLoading();
    _interval = interval;
    notifyListeners();
    try {
      final Response<dynamic> response = await _dio.get(
        '/api/v3/klines',
        queryParameters: <String, dynamic>{
          'symbol': symbol,
          'interval': interval,
          'limit': 24,
        },
      );
      _state = KlineStateSuccess(
        (response.data as List<dynamic>)
            .map((dynamic e) => Kline.fromList(e as List<dynamic>))
            .toList(),
      );
    } on Object catch (e) {
      _state = KlineStateFailure(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Switches the interval for cryptocurrency klines and reloads the klines
  /// for the given symbol and new interval.
  Future<void> switchInterval({
    required final String symbol,
    required final String interval,
  }) => loadKlines(symbol: symbol, interval: interval);
}
