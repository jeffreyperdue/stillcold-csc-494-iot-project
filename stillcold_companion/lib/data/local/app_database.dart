import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Readings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get temperatureC => real()();
  RealColumn get humidityPercent => real().nullable()();
}

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get useFahrenheit => boolean().withDefault(const Constant(false))();
  RealColumn get lowThresholdC => real().withDefault(const Constant(0.0))();
  RealColumn get highThresholdC => real().withDefault(const Constant(4.0))();
  IntColumn get pollingIntervalSeconds =>
      integer().withDefault(const Constant(15))();
  IntColumn get quietHoursStartMinutes => integer().nullable()();
  IntColumn get quietHoursEndMinutes => integer().nullable()();
  TextColumn get lastConnectedDeviceId => text().nullable()();
  BoolColumn get autoConnectEnabled =>
      boolean().withDefault(const Constant(true))();
}

class AlertEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get temperatureC => real()();
  RealColumn get humidityPercent => real().nullable()();
  BoolColumn get isHighThreshold => boolean()();
}

class DeviceLabels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text().unique()();
  TextColumn get label => text()();
}

@DriftDatabase(
  tables: [
    Readings,
    Settings,
    AlertEvents,
    DeviceLabels,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from <= 1) {
            // v1 → v2: recreate data tables that may have stale or missing columns.
            // The 'settings' table is intentionally left intact to preserve user data.
            await m.drop(readings);
            await m.drop(alertEvents);
            await m.drop(deviceLabels);
            await m.createTable(readings);
            await m.createTable(alertEvents);
            await m.createTable(deviceLabels);
          }
          if (from <= 2) {
            // v2 → v3: add autoConnectEnabled column to settings.
            await m.addColumn(settings, settings.autoConnectEnabled);
          }
        },
      );

  Future<int> insertReading(ReadingsCompanion entry) =>
      into(readings).insert(entry);

  Future<List<Reading>> getReadingsSince(DateTime from) =>
      (select(readings)..where((tbl) => tbl.timestamp.isBiggerOrEqualValue(from)))
          .get();

  Future<Setting?> loadSettings() async {
    final all = await select(settings).get();
    if (all.isEmpty) {
      final id = await into(settings).insert(SettingsCompanion.insert());
      return (select(settings)..where((tbl) => tbl.id.equals(id)))
          .getSingle();
    }
    return all.first;
  }

  Future<void> saveSettings(SettingsCompanion data) async {
    final existing = await select(settings).get();
    if (existing.isEmpty) {
      await into(settings).insert(data);
    } else {
      await (update(settings)..where((tbl) => tbl.id.equals(existing.first.id)))
          .write(data);
    }
  }

  Future<int> insertAlert(AlertEventsCompanion entry) =>
      into(alertEvents).insert(entry);

  Future<List<AlertEvent>> getAlertsSince(DateTime from) =>
      (select(alertEvents)
            ..where((tbl) => tbl.timestamp.isBiggerOrEqualValue(from)))
          .get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'stillcold.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

