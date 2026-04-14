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
  }) {
    final entry = ReadingsCompanion.insert(
      deviceId: deviceId,
      timestamp: timestamp,
      temperatureC: temperatureC,
      humidityPercent: drift.Value(humidityPercent),
    );
    return _db.insertReading(entry);
  }

  Future<List<Reading>> getReadingsSince(DateTime from) {
    return _db.getReadingsSince(from);
  }

  Future<double?> getMinTemperatureSince(DateTime from) async {
    final minExpr = _db.readings.temperatureC.min();
    final query = _db.readings.selectOnly()
      ..addColumns([minExpr])
      ..where(_db.readings.timestamp.isBiggerOrEqualValue(from));
    final row = await query.getSingleOrNull();
    return row?.read(minExpr);
  }

  Future<double?> getMaxTemperatureSince(DateTime from) async {
    final maxExpr = _db.readings.temperatureC.max();
    final query = _db.readings.selectOnly()
      ..addColumns([maxExpr])
      ..where(_db.readings.timestamp.isBiggerOrEqualValue(from));
    final row = await query.getSingleOrNull();
    return row?.read(maxExpr);
  }
}

