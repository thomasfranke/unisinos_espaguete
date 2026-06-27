import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spaghetti/l10n/generated/app_localizations.dart';
import 'package:flutter_spaghetti/models/crypto_quote_model.dart';
import 'package:flutter_spaghetti/models/kline_model.dart';
import 'package:flutter_spaghetti/notifiers/favorites_notifier.dart';
import 'package:flutter_spaghetti/notifiers/kline_notifier.dart';
import 'package:flutter_spaghetti/states/kline_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// A screen that displays detailed information about a specific
/// cryptocurrency quote.
@RoutePage()
class DetailScreen extends StatefulWidget {
  /// Creates a [DetailScreen] widget with the given cryptocurrency quote.
  const DetailScreen({required this.quote, super.key});

  /// The cryptocurrency quote for which the details are being displayed.
  final CryptoQuote quote;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final KlineNotifier _klineNotifier;

  @override
  void initState() {
    super.initState();
    _klineNotifier = KlineNotifier(symbol: widget.quote.symbol);
  }

  @override
  void dispose() {
    _klineNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final CryptoQuote quote = widget.quote;
    final bool isPositive = quote.priceChangePct >= 0;
    final Color changeColor = isPositive ? Colors.green : Colors.red;
    final String changeSign = isPositive ? '+' : '';
    final AppLocalizations l10n = AppLocalizations.of(context);

    final bool isFavorite = context.watch<FavoritesNotifier>().isFavorite(
      quote.symbol,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(quote.symbol),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_outline,
              color: isFavorite ? Colors.amber : null,
            ),
            onPressed: () =>
                context.read<FavoritesNotifier>().toggleFavorite(quote.symbol),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            quote.symbol,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            quote.lastPrice.toStringAsFixed(8),
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: changeColor.withAlpha(31),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: changeColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '$changeSign${quote.priceChangePct.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: changeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildRangeBar(quote),
          const SizedBox(height: 24),
          _buildSectionCard(
            title: 'Histórico de Preço',
            child: _KlineChart(notifier: _klineNotifier, symbol: quote.symbol),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: l10n.priceChange24h,
            child: Column(
              children: <Widget>[
                _buildDetailRow(
                  l10n.absoluteChange,
                  '$changeSign${quote.priceChange.toStringAsFixed(8)}',
                  valueColor: changeColor,
                ),
                _buildDetailRow(
                  l10n.high24h,
                  quote.highPrice.toStringAsFixed(8),
                ),
                _buildDetailRow(l10n.low24h, quote.lowPrice.toStringAsFixed(8)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: l10n.baseVolume,
            child: Column(
              children: <Widget>[
                _buildDetailRow(
                  l10n.baseVolume,
                  quote.volume.toStringAsFixed(4),
                ),
                _buildDetailRow(
                  l10n.quoteVolume,
                  quote.quoteVolume.toStringAsFixed(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeBar(final CryptoQuote quote) {
    final double range = quote.highPrice - quote.lowPrice;
    final double progress = range > 0
        ? ((quote.lastPrice - quote.lowPrice) / range).clamp(0.0, 1.0)
        : 0.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Range 24h',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.red.withAlpha(31),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              quote.lowPrice.toStringAsFixed(4),
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
            Text(
              quote.highPrice.toStringAsFixed(4),
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) =>
      Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.withAlpha(31)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      );

  Widget _buildDetailRow(
    final String label,
    final String value, {
    Color? valueColor,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    ),
  );
}

class _KlineChart extends StatelessWidget {
  const _KlineChart({required this.notifier, required this.symbol});

  final KlineNotifier notifier;
  final String symbol;

  @override
  Widget build(final BuildContext context) => ListenableBuilder(
    listenable: notifier,
    builder: (final BuildContext context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <String>['15m', '1h', '4h', '1d']
              .map(
                (final String interval) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(interval),
                    selected: notifier.currentInterval == interval,
                    onSelected: (_) => notifier.switchInterval(
                      symbol: symbol,
                      interval: interval,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: switch (notifier.state) {
            KlineStateLoading() => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            KlineStateFailure(:final String message) => Center(
              child: Text(message, style: const TextStyle(color: Colors.grey)),
            ),
            KlineStateSuccess(:final List<Kline> klines) =>
              klines.isEmpty
                  ? const Center(
                      child: Text(
                        'Sem dados',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : _buildChart(klines),
          },
        ),
      ],
    ),
  );

  Widget _buildChart(final List<Kline> klines) {
    final List<FlSpot> spots = klines
        .asMap()
        .entries
        .map(
          (final MapEntry<int, Kline> e) =>
              FlSpot(e.key.toDouble(), e.value.close),
        )
        .toList();

    final double minY = klines
        .map((Kline k) => k.low)
        .reduce((double a, double b) => a < b ? a : b);
    final double maxY = klines
        .map((Kline k) => k.high)
        .reduce((double a, double b) => a > b ? a : b);
    final bool isPositive = klines.last.close >= klines.first.close;
    final Color lineColor = isPositive ? Colors.green : Colors.red;

    return LineChart(
      LineChartData(
        minY: minY * 0.999,
        maxY: maxY * 1.001,
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: Colors.grey.withAlpha(31), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (final double value, final TitleMeta meta) =>
                  Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (klines.length / 4).ceilToDouble(),
              getTitlesWidget: (final double value, final TitleMeta meta) {
                final int index = value.toInt();
                if (index < 0 || index >= klines.length) {
                  return const SizedBox.shrink();
                }
                return Text(
                  DateFormat('HH:mm').format(klines[index].closeTime),
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: lineColor.withAlpha(31),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (final List<LineBarSpot> spots) =>
                spots.map((final LineBarSpot spot) {
                  final Kline kline = klines[spot.x.toInt()];
                  return LineTooltipItem(
                    '${kline.close.toStringAsFixed(4)}\n',
                    TextStyle(
                      color: lineColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: DateFormat('dd/MM HH:mm').format(kline.closeTime),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
