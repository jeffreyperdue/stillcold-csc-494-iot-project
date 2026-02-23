import 'package:drift/drift.dart' as drift;

import '../local/app_database.dart';

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Future<Setting> load() async {
    final settings = await _db.loadSettings();
    if (settings == null) {
      final id = await _db.into(_db.settings).insert(SettingsCompanion.insert());
      return (await (_db.select(_db.settings)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingle());
    }
    return settings;
  }

  Future<void> update({
    bool? useFahrenheit,
    double? lowThresholdC,
    double? highThresholdC,
    int? pollingIntervalSeconds,
    int? quietHoursStartMinutes,
    int? quietHoursEndMinutes,
    String? lastConnectedDeviceId,
  }) async {
    final current = await load();
    final companion = SettingsCompanion(
      id: drift.Value(current.id),
      useFahrenheit: useFahrenheit != null
          ? drift.Value(useFahrenheit)
          : const drift.Value.absent(),
      lowThresholdC: lowThresholdC != null
          ? drift.Value(lowThresholdC)
          : const drift.Value.absent(),
      highThresholdC: highThresholdC != null
          ? drift.Value(highThresholdC)
          : const drift.Value.absent(),
      pollingIntervalSeconds: pollingIntervalSeconds != null
          ? drift.Value(pollingIntervalSeconds)
          : const drift.Value.absent(),
      quietHoursStartMinutes: quietHoursStartMinutes != null
          ? drift.Value(quietHoursStartMinutes)
          : const drift.Value.absent(),
      quietHoursEndMinutes: quietHoursEndMinutes != null
          ? drift.Value(quietHoursEndMinutes)
          : const drift.Value.absent(),
      lastConnectedDeviceId: lastConnectedDeviceId != null
          ? drift.Value(lastConnectedDeviceId)
          : const drift.Value.absent(),
    );

    await _db.saveSettings(companion);
  }
}

