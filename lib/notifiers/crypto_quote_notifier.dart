import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spaghetti/models/crypto_quote_model.dart';
import 'package:flutter_spaghetti/states/crypto_quote_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _cacheKey = 'cache_crypto_quotes';

/// A notifier class for managing the state of cryptocurrency quotes.
class CryptoQuoteNotifier extends ChangeNotifier {
  /// Creates a [CryptoQuoteNotifier] instance.
  CryptoQuoteNotifier() {
    unawaited(fetchQuotes());
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://data-api.binance.vision'));

  CryptoQuoteState _state = const CryptoQuoteStateLoading();

  /// Gets the current state of cryptocurrency quotes.
  CryptoQuoteState get state => _state;

  /// Fetches cryptocurrency quotes from the API.
  /// Falls back to cache if the request fails, setting fromCache to true.
  Future<void> fetchQuotes() async {
    _state = const CryptoQuoteStateLoading();
    notifyListeners();
    try {
      final Response<dynamic> response = await _dio.get('/api/v3/ticker/24hr');
      final List<CryptoQuote> quotes = (response.data as List<dynamic>)
          .map((dynamic e) => CryptoQuote.fromJson(e as Map<String, dynamic>))
          .toList();

      await _saveCache(quotes);

      _state = CryptoQuoteStateSuccess(quotes);
    } on Object catch (e, st) {
      debugPrint('Remote failed, falling back to cache: $e');
      debugPrintStack(stackTrace: st);

      final List<CryptoQuote> cached = await _loadCache();
      if (cached.isNotEmpty) {
        _state = CryptoQuoteStateSuccess(cached, fromCache: true);
      } else {
        _state = CryptoQuoteStateFailure(e.toString());
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> _saveCache(final List<CryptoQuote> quotes) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(
        quotes
            .map(
              (CryptoQuote q) => <String, dynamic>{
                'symbol': q.symbol,
                'lastPrice': q.lastPrice.toString(),
                'priceChange': q.priceChange.toString(),
                'priceChangePercent': q.priceChangePct.toString(),
                'highPrice': q.highPrice.toString(),
                'lowPrice': q.lowPrice.toString(),
                'volume': q.volume.toString(),
                'quoteVolume': q.quoteVolume.toString(),
              },
            )
            .toList(),
      );
      await prefs.setString(_cacheKey, encoded);
    } on Object catch (e, st) {
      debugPrint('Cache write error: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<List<CryptoQuote>> _loadCache() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString(_cacheKey);
      if (raw == null) {
        return <CryptoQuote>[];
      }
      return (jsonDecode(raw) as List<dynamic>)
          .map((dynamic e) => CryptoQuote.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object catch (e, st) {
      debugPrint('Cache read error: $e');
      debugPrintStack(stackTrace: st);
      return <CryptoQuote>[];
    }
  }
}
