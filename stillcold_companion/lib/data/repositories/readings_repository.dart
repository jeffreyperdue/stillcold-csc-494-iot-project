import 'package:drift/drift.dart' as drift;

import '../local/app_database.dart';

class ReadingsRepository {
  ReadingsRepository(this._db);

  final AppDatabase _db;

  Future<void> addReading({
    required String deviceId,
    required DateTime timestamp,
    required double temperatureC,
    double? humidityPercent,
  }) async {
    final entry = ReadingsCompanion.insert(
      deviceId: deviceId,
      timestamp: timestamp,
      temperatureC: temperatureC,
      humidityPercent: drift.Value(humidityPercent),
    );
    await _db.insertReading(entry);
    // Lazily prune rows older than 30 days on every insert.
    await pruneOlderThan(timestamp.subtract(const Duration(days: 30)));
  }

  Future<void> pruneOlderThan(DateTime cutoff) =>
      _db.deleteReadingsOlderThan(cutoff);

  Future<List<Reading>> getReadingsSince(DateTime from, String deviceId) =>
      _db.getReadingsSince(from, deviceId);

  Stream<List<Reading>> watchReadingsForDevice(
    String deviceId,
    DateTime from,
  ) =>
      _db.watchReadingsSince(from, deviceId);

  Future<double?> getMinTemperatureSince(
    DateTime from,
    String deviceId,
  ) async {
    final minExpr = _db.readings.temperatureC.min();
    final query = _db.readings.selectOnly()
      ..addColumns([minExpr])
      ..where(
        _db.readings.timestamp.isBiggerOrEqualValue(from) &
            _db.readings.deviceId.equals(deviceId),
      );
    final row = await query.getSingleOrNull();
    return row?.read(minExpr);
  }

  Future<double?> getMaxTemperatureSince(
    DateTime from,
    String deviceId,
  ) async {
    final maxExpr = _db.readings.temperatureC.max();
    final query = _db.readings.selectOnly()
      ..addColumns([maxExpr])
      ..where(
        _db.readings.timestamp.isBiggerOrEqualValue(from) &
            _db.readings.deviceId.equals(deviceId),
      );
    final row = await query.getSingleOrNull();
    return row?.read(maxExpr);
  }
}
