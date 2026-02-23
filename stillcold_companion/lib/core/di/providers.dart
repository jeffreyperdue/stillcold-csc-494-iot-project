import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';
import '../../data/repositories/alerts_repository.dart';
import '../../data/repositories/device_labels_repository.dart';
import '../../data/repositories/readings_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/alerts/alert_evaluator.dart';
import '../../services/ble/ble_client.dart';
import '../../services/notifications/local_notifications_service.dart';

final flutterReactiveBleProvider = Provider<FlutterReactiveBle>((ref) {
  return FlutterReactiveBle();
});

final bleClientProvider = Provider<BleClient>((ref) {
  final ble = ref.watch(flutterReactiveBleProvider);
  return BleClient(ble);
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final readingsRepositoryProvider = Provider<ReadingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReadingsRepository(db);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SettingsRepository(db);
});

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AlertsRepository(db);
});

final deviceLabelsRepositoryProvider =
    Provider<DeviceLabelsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DeviceLabelsRepository(db);
});

final localNotificationsServiceProvider =
    Provider<LocalNotificationsService>((ref) {
  final service = LocalNotificationsService();
  return service;
});

final alertEvaluatorProvider = Provider<AlertEvaluator>((ref) {
  final alertsRepo = ref.watch(alertsRepositoryProvider);
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final notifications = ref.watch(localNotificationsServiceProvider);
  return AlertEvaluator(
    alertsRepository: alertsRepo,
    settingsRepository: settingsRepo,
    notificationsService: notifications,
  );
});

