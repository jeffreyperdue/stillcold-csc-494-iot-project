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
    final query = _db.readings
        .createAlias('r')
        .selectOnly()
      ..addColumns([_db.readings.temperatureC.min()]);
    query.where(_db.readings.timestamp.isBiggerOrEqualValue(from));
    final row = await query.getSingleOrNull();
    return row?.read(_db.readings.temperatureC.min());
  }

  Future<double?> getMaxTemperatureSince(DateTime from) async {
    final query = _db.readings
        .createAlias('r2')
        .selectOnly()
      ..addColumns([_db.readings.temperatureC.max()]);
    query.where(_db.readings.timestamp.isBiggerOrEqualValue(from));
    final row = await query.getSingleOrNull();
    return row?.read(_db.readings.temperatureC.max());
  }
}

