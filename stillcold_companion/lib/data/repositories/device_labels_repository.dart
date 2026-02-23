import 'package:drift/drift.dart' as drift;

import '../local/app_database.dart';

class DeviceLabelsRepository {
  DeviceLabelsRepository(this._db);

  final AppDatabase _db;

  Future<List<dynamic>> getAllLabels() {
    return _db.select(_db.deviceLabels).get();
  }

  Future<dynamic> getLabelForDevice(String deviceId) {
    return (_db.select(_db.deviceLabels)
          ..where((tbl) => tbl.deviceId.equals(deviceId)))
        .getSingleOrNull();
  }

  Future<void> upsertLabel({
    required String deviceId,
    required String label,
  }) async {
    await _db.into(_db.deviceLabels).insertOnConflictUpdate(
          DeviceLabelsCompanion(
            deviceId: drift.Value(deviceId),
            label: drift.Value(label),
          ),
        );
  }

  Future<void> deleteLabel(String deviceId) async {
    await (_db.delete(_db.deviceLabels)
          ..where((tbl) => tbl.deviceId.equals(deviceId)))
        .go();
  }
}

