import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/local/app_database.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

enum TrendRange { h1, h24, d7 }

enum TrendMetric { temperature, humidity }

// ---------------------------------------------------------------------------
// TrendParams — used as the family key; requires == / hashCode.
// ---------------------------------------------------------------------------

class TrendParams {
  const TrendParams({required this.deviceId, required this.range});

  final String deviceId;
  final TrendRange range;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendParams &&
          other.deviceId == deviceId &&
          other.range == range;

  @override
  int get hashCode => Object.hash(deviceId, range);
}

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class TrendPoint {
  const TrendPoint({
    required this.timestamp,
    required this.temperatureC,
    this.humidityPercent,
  });

  final DateTime timestamp;
  final double temperatureC;
  final double? humidityPercent;
}

class TrendData {
  const TrendData({
    required this.points,
    required this.range,
    required this.since,
    required this.isPartial,
  });

  /// Bucketed, gap-aware data points ready for charting.
  final List<TrendPoint> points;
  final TrendRange range;

  /// The earliest timestamp this range covers (used as the X-axis origin).
  final DateTime since;

  /// True when the first stored reading is newer than [since], meaning the
  /// app has not yet accumulated a full window of history.
  final bool isPartial;
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final trendDataProvider =
    StreamProvider.autoDispose.family<TrendData, TrendParams>(
  (ref, params) {
    final repo = ref.watch(readingsRepositoryProvider);
    final now = DateTime.now();
    final since = switch (params.range) {
      TrendRange.h1 => now.subtract(const Duration(hours: 1)),
      TrendRange.h24 => now.subtract(const Duration(hours: 24)),
      TrendRange.d7 => now.subtract(const Duration(days: 7)),
    };

    return repo
        .watchReadingsForDevice(params.deviceId, since)
        .map((readings) => _buildTrendData(readings, params.range, since));
  },
);

// ---------------------------------------------------------------------------
// Data processing helpers (pure functions — easy to unit-test separately)
// ---------------------------------------------------------------------------

TrendData _buildTrendData(
  List<Reading> raw,
  TrendRange range,
  DateTime since,
) {
  final bucketDuration = switch (range) {
    TrendRange.h1 => const Duration(minutes: 1),
    TrendRange.h24 => const Duration(minutes: 5),
    TrendRange.d7 => const Duration(hours: 1),
  };

  final clamped = raw.map(_clampReading).toList();
  final bucketed = _bucketAverage(clamped, bucketDuration);

  final isPartial = bucketed.isEmpty ||
      bucketed.first.timestamp.isAfter(since.add(bucketDuration * 2));

  return TrendData(
    points: bucketed,
    range: range,
    since: since,
    isPartial: isPartial,
  );
}

/// Clamp sensor values to physically reasonable ranges before charting so that
/// a glitched reading cannot blow out the Y-axis scale.
Reading _clampReading(Reading r) {
  final tempClamped = r.temperatureC.clamp(-50.0, 100.0);
  final humClamped = r.humidityPercent?.clamp(0.0, 100.0);
  if (tempClamped == r.temperatureC && humClamped == r.humidityPercent) {
    return r;
  }
  return Reading(
    id: r.id,
    deviceId: r.deviceId,
    timestamp: r.timestamp,
    temperatureC: tempClamped.toDouble(),
    humidityPercent: humClamped?.toDouble(),
  );
}

/// Average readings within fixed-size time buckets and return one
/// [TrendPoint] per bucket, ordered by time.
List<TrendPoint> _bucketAverage(List<Reading> readings, Duration bucketSize) {
  if (readings.isEmpty) return const [];

  final bucketMs = bucketSize.inMilliseconds;
  final Map<int, List<Reading>> buckets = {};

  for (final r in readings) {
    final key = r.timestamp.millisecondsSinceEpoch ~/ bucketMs;
    buckets.putIfAbsent(key, () => []).add(r);
  }

  final points = buckets.entries.map((entry) {
    final rows = entry.value;
    final avgTemp =
        rows.map((r) => r.temperatureC).reduce((a, b) => a + b) / rows.length;
    final hums =
        rows.map((r) => r.humidityPercent).whereType<double>().toList();
    final avgHum =
        hums.isEmpty ? null : hums.reduce((a, b) => a + b) / hums.length;
    final bucketStart =
        DateTime.fromMillisecondsSinceEpoch(entry.key * bucketMs);
    return TrendPoint(
      timestamp: bucketStart,
      temperatureC: avgTemp,
      humidityPercent: avgHum,
    );
  }).toList()
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  return points;
}

// ---------------------------------------------------------------------------
// fl_chart spot builder (used by TrendChartCard)
// ---------------------------------------------------------------------------

/// Converts [TrendData] into a list of [FlSpot] values for [fl_chart].
///
/// [toY] maps a [TrendPoint] to the Y value for the selected metric.
/// A [FlSpot] with `y = double.nan` is inserted between consecutive points
/// whose time gap exceeds the gap threshold, visually breaking the line
/// during periods when the device was disconnected.
List<FlSpot> buildSpots(
  TrendData data,
  double Function(TrendPoint p) toY,
) {
  final points = data.points;
  if (points.isEmpty) return const [];

  final gapThreshold = switch (data.range) {
    TrendRange.h1 => const Duration(minutes: 5),
    TrendRange.h24 => const Duration(minutes: 15),
    TrendRange.d7 => const Duration(hours: 3),
  };

  final spots = <FlSpot>[];

  for (var i = 0; i < points.length; i++) {
    final p = points[i];
    final x = p.timestamp.difference(data.since).inSeconds / 3600.0;
    final y = toY(p);

    // Insert a nan break if the gap to the previous point is too large.
    if (i > 0) {
      final gap = p.timestamp.difference(points[i - 1].timestamp);
      if (gap > gapThreshold) {
        final midX = (spots.last.x + x) / 2.0;
        spots.add(FlSpot(midX, double.nan));
      }
    }

    spots.add(FlSpot(x, y));
  }

  return spots;
}
