import 'dart:math' show log, pow, ln10;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/empty_state.dart';
import '../../settings/presentation/settings_screen.dart'
    show settingsFutureProvider;
import '../application/trend_provider.dart';

class TrendChartCard extends ConsumerStatefulWidget {
  const TrendChartCard({super.key, required this.deviceId});

  final String deviceId;

  @override
  ConsumerState<TrendChartCard> createState() => _TrendChartCardState();
}

class _TrendChartCardState extends ConsumerState<TrendChartCard> {
  TrendRange _range = TrendRange.h24;
  TrendMetric _metric = TrendMetric.temperature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final params = TrendParams(deviceId: widget.deviceId, range: _range);
    final trendAsync = ref.watch(trendDataProvider(params));
    final settingsAsync = ref.watch(settingsFutureProvider);
    final useFahrenheit = settingsAsync.maybeWhen(
      data: (s) => s.useFahrenheit,
      orElse: () => false,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Range toggle — full width
            SegmentedButton<TrendRange>(
              segments: const [
                ButtonSegment(value: TrendRange.h1, label: Text('1h')),
                ButtonSegment(value: TrendRange.h24, label: Text('24h')),
                ButtonSegment(value: TrendRange.d7, label: Text('7d')),
              ],
              selected: {_range},
              onSelectionChanged: (s) => setState(() => _range = s.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(height: 8),
            // Metric toggle — full width
            SegmentedButton<TrendMetric>(
              segments: const [
                ButtonSegment(
                  value: TrendMetric.temperature,
                  label: Text('Temperature'),
                ),
                ButtonSegment(
                  value: TrendMetric.humidity,
                  label: Text('Humidity'),
                ),
              ],
              selected: {_metric},
              onSelectionChanged: (s) => setState(() => _metric = s.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),

            // Partial-data notice
            trendAsync.maybeWhen(
              data: (data) => data.isPartial && data.points.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Showing partial data — not enough history yet',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.amber.shade700,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              orElse: () => const SizedBox.shrink(),
            ),

            const SizedBox(height: 12),

            // Chart area
            Expanded(
              child: trendAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Could not load trend data',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                data: (data) {
                  if (data.points.isEmpty) {
                    return EmptyState(
                      icon: Icons.show_chart,
                      title: 'No data yet',
                      message:
                          'Connect your device to start collecting readings.',
                    );
                  }
                  if (data.points.length < 2) {
                    return EmptyState(
                      icon: Icons.show_chart,
                      title: 'Not enough data',
                      message:
                          'Keep the device connected to build up history.',
                    );
                  }
                  return _buildChart(
                    context,
                    data,
                    useFahrenheit: useFahrenheit,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    TrendData data, {
    required bool useFahrenheit,
  }) {
    final theme = Theme.of(context);

    double toY(TrendPoint p) {
      if (_metric == TrendMetric.humidity) {
        return p.humidityPercent ?? double.nan;
      }
      return useFahrenheit ? (p.temperatureC * 9 / 5 + 32) : p.temperatureC;
    }

    final spots = buildSpots(data, toY);

    // Y-axis bounds from valid (non-nan) values with ±10% padding.
    final validY =
        spots.where((s) => !s.y.isNaN).map((s) => s.y).toList();
    if (validY.isEmpty) {
      return EmptyState(
        icon: Icons.show_chart,
        title: 'No data for this metric',
        message: 'Humidity readings are not available for this period.',
      );
    }
    final yMin = validY.reduce((a, b) => a < b ? a : b);
    final yMax = validY.reduce((a, b) => a > b ? a : b);

    // Compute a nice interval from the raw data range, then SNAP the axis
    // bounds to the interval grid.  This guarantees every label position
    // coincides with a grid line and eliminates the fractional-edge crowding
    // that fl_chart produces when minY/maxY fall between interval steps.
    final yInterval = _niceInterval(yMax - yMin);
    var yBottom = (yMin / yInterval).floor() * yInterval;
    var yTop = (yMax / yInterval).ceil() * yInterval;

    // Ensure at least one interval of visual breathing room above and below
    // the data (handles flat data and floating-point edge cases).
    if (yTop - yBottom < yInterval * 1.5) {
      yBottom -= yInterval;
      yTop += yInterval;
    }

    final totalHours = switch (data.range) {
      TrendRange.h1 => 1.0,
      TrendRange.h24 => 24.0,
      TrendRange.d7 => 7.0 * 24.0,
    };
    // X-axis label spacing in hours.
    final xInterval = switch (data.range) {
      TrendRange.h1 => 0.25, // every 15 min
      TrendRange.h24 => 6.0,
      TrendRange.d7 => 24.0,
    };

    final unitLabel = _metric == TrendMetric.temperature
        ? (useFahrenheit ? '°F' : '°C')
        : '%';

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: totalHours,
        minY: yBottom,
        maxY: yTop,
        clipData: const FlClipData.all(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            preventCurveOverShooting: true,
            color: _metric == TrendMetric.temperature
                ? theme.colorScheme.primary
                : Colors.blueAccent,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: (_metric == TrendMetric.temperature
                      ? theme.colorScheme.primary
                      : Colors.blueAccent)
                  .withValues(alpha: 0.08),
            ),
          ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: yInterval,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (_) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: yInterval,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  value.toStringAsFixed(
                    _metric == TrendMetric.humidity ? 0 : 1,
                  ),
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: Colors.grey.shade600),
                ),
              ),
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: xInterval,
              getTitlesWidget: (value, meta) {
                final label = _xAxisLabel(value, data);
                if (label == null) return const SizedBox.shrink();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
              if (spot.y.isNaN) return null;
              final pointTime =
                  data.since.add(Duration(seconds: (spot.x * 3600).round()));
              final timeStr = DateFormat('MMM d, h:mm a').format(pointTime);
              return LineTooltipItem(
                '${spot.y.toStringAsFixed(_metric == TrendMetric.humidity ? 0 : 1)}$unitLabel\n',
                theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: timeStr,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
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

  /// Returns a human-readable X-axis label for [hoursOffset] from [data.since],
  /// or null if the tick should be suppressed.
  String? _xAxisLabel(double hoursOffset, TrendData data) {
    switch (data.range) {
      case TrendRange.h1:
        // Labels every 15 minutes: "2:00", "2:15", etc.
        final totalMinutes = (hoursOffset * 60).round();
        if (totalMinutes % 15 != 0) return null;
        final pointTime =
            data.since.add(Duration(minutes: totalMinutes));
        return DateFormat('h:mm').format(pointTime);
      case TrendRange.h24:
        // Wall-clock hour labels every 6 h: "6 AM", "12 PM".
        final pointTime =
            data.since.add(Duration(minutes: (hoursOffset * 60).round()));
        return DateFormat('h a').format(pointTime);
      case TrendRange.d7:
        // Day-name labels at each 24-hour boundary.
        if (hoursOffset % 24 != 0) return null;
        final pointTime =
            data.since.add(Duration(hours: hoursOffset.round()));
        return DateFormat('E').format(pointTime);
    }
  }
}

/// Rounds [range / 4] up to the nearest "nice" number (1, 2, 5, 10, …) so
/// Y-axis labels always fall on round values and never crowd each other,
/// regardless of how small the data range is.
double _niceInterval(double range) {
  if (range <= 0) return 1.0;
  final raw = range / 4.0;
  final magnitude = pow(10, (log(raw) / ln10).floor()).toDouble();
  final normalized = raw / magnitude;
  final double niceFactor;
  if (normalized < 1.5) {
    niceFactor = 1.0;
  } else if (normalized < 3.5) {
    niceFactor = 2.0;
  } else if (normalized < 7.5) {
    niceFactor = 5.0;
  } else {
    niceFactor = 10.0;
  }
  return niceFactor * magnitude;
}
