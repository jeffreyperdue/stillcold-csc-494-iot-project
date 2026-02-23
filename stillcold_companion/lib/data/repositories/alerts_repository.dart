import 'package:drift/drift.dart' as drift;

import '../local/app_database.dart';

class AlertsRepository {
  AlertsRepository(this._db);

  final AppDatabase _db;

  Future<void> addAlert({
    required String deviceId,
    required DateTime timestamp,
    required double temperatureC,
    double? humidityPercent,
    required bool isHighThreshold,
  }) {
    final entry = AlertEventsCompanion.insert(
      deviceId: deviceId,
      timestamp: timestamp,
      temperatureC: temperatureC,
      humidityPercent: drift.Value(humidityPercent),
      isHighThreshold: isHighThreshold,
    );
    return _db.insertAlert(entry);
  }

  Future<List<AlertEvent>> getAlertsSince(DateTime from) {
    return _db.getAlertsSince(from);
  }
}

