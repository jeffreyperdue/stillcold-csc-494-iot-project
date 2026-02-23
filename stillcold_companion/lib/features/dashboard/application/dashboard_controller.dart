import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/repositories/readings_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../services/alerts/alert_evaluator.dart';
import '../../../services/ble/ble_client.dart';

class DashboardReading {
  const DashboardReading({
    required this.temperatureC,
    this.humidityPercent,
    required this.timestamp,
  });

  final double temperatureC;
  final double? humidityPercent;
  final DateTime timestamp;
}

class DashboardState {
  const DashboardState({
    this.isLoading = false,
    this.reading,
    this.errorMessage,
  });

  final bool isLoading;
  final DashboardReading? reading;
  final String? errorMessage;

  DashboardState copyWith({
    bool? isLoading,
    DashboardReading? reading,
    String? errorMessage,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      reading: reading ?? this.reading,
      errorMessage: errorMessage,
    );
  }
}

final dashboardControllerProvider = StateNotifierProvider.family<
    DashboardController, DashboardState, String>((ref, deviceId) {
  final bleClient = ref.watch(bleClientProvider);
  final readingsRepo = ref.watch(readingsRepositoryProvider);
  final alertEvaluator = ref.watch(alertEvaluatorProvider);
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return DashboardController(
    deviceId: deviceId,
    bleClient: bleClient,
    readingsRepository: readingsRepo,
    alertEvaluator: alertEvaluator,
    settingsRepository: settingsRepo,
  );
});

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController({
    required this.deviceId,
    required BleClient bleClient,
    required ReadingsRepository readingsRepository,
    required AlertEvaluator alertEvaluator,
    required SettingsRepository settingsRepository,
  })  : _bleClient = bleClient,
        _readingsRepository = readingsRepository,
        _alertEvaluator = alertEvaluator,
        _settingsRepository = settingsRepository,
        super(const DashboardState());

  final String deviceId;
  final BleClient _bleClient;
  final ReadingsRepository _readingsRepository;
  final AlertEvaluator _alertEvaluator;
  final SettingsRepository _settingsRepository;

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final temp = await _bleClient.readTemperature(deviceId);
      final humidity = await _bleClient.readHumidity(deviceId);

      if (temp == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Could not read temperature from device.',
        );
        return;
      }

      final now = DateTime.now();
      final reading = DashboardReading(
        temperatureC: temp,
        humidityPercent: humidity,
        timestamp: now,
      );

      await _readingsRepository.addReading(
        deviceId: deviceId,
        timestamp: now,
        temperatureC: temp,
        humidityPercent: humidity,
      );

      await _settingsRepository.update(
        lastConnectedDeviceId: deviceId,
      );

      await _alertEvaluator.evaluateAndAlert(
        deviceId: deviceId,
        temperatureC: temp,
        humidityPercent: humidity,
        timestamp: now,
      );

      state = DashboardState(isLoading: false, reading: reading);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to refresh: $e',
      );
    }
  }
}

