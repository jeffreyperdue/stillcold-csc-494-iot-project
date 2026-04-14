import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart'
    hide ConnectionStatus;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/widgets/status_chip.dart';
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
    this.connectionStatus = ConnectionStatus.disconnected,
    this.isLoading = false,
    this.reading,
    this.errorMessage,
    this.connectionLost = false,
    this.minTempC,
    this.maxTempC,
  });

  final ConnectionStatus connectionStatus;
  final bool isLoading;
  final DashboardReading? reading;
  final String? errorMessage;

  /// True when the device disconnected unexpectedly (not via explicit Disconnect).
  final bool connectionLost;

  /// Min temperature over the last 24 hours (null until first successful read).
  final double? minTempC;

  /// Max temperature over the last 24 hours (null until first successful read).
  final double? maxTempC;

  DashboardState copyWith({
    ConnectionStatus? connectionStatus,
    bool? isLoading,
    DashboardReading? reading,
    String? errorMessage,
    bool? connectionLost,
    double? minTempC,
    double? maxTempC,
  }) {
    return DashboardState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      isLoading: isLoading ?? this.isLoading,
      reading: reading ?? this.reading,
      errorMessage: errorMessage,
      connectionLost: connectionLost ?? this.connectionLost,
      minTempC: minTempC ?? this.minTempC,
      maxTempC: maxTempC ?? this.maxTempC,
    );
  }
}

final dashboardControllerProvider =
    StateNotifierProvider.autoDispose.family<DashboardController, DashboardState,
        String>((ref, deviceId) {
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
        super(const DashboardState()) {
    _initConnection();
  }

  final String deviceId;
  final BleClient _bleClient;
  final ReadingsRepository _readingsRepository;
  final AlertEvaluator _alertEvaluator;
  final SettingsRepository _settingsRepository;

  StreamSubscription<ConnectionStateUpdate>? _connectionSub;
  Timer? _pollingTimer;
  bool _intentionalDisconnect = false;
  int _currentPollingInterval = 15;

  void _initConnection() {
    if (!mounted) return;
    state = state.copyWith(connectionStatus: ConnectionStatus.connecting);

    _connectionSub = _bleClient.connectToDevice(deviceId).listen(
      (update) {
        if (!mounted) return;
        switch (update.connectionState) {
          case DeviceConnectionState.connecting:
            state =
                state.copyWith(connectionStatus: ConnectionStatus.connecting);
          case DeviceConnectionState.connected:
            state = state.copyWith(
              connectionStatus: ConnectionStatus.connected,
              connectionLost: false,
            );
            _startPolling();
          case DeviceConnectionState.disconnected:
            _stopPolling();
            if (!_intentionalDisconnect) {
              state = state.copyWith(
                connectionStatus: ConnectionStatus.disconnected,
                connectionLost: true,
              );
            } else {
              state = state.copyWith(
                connectionStatus: ConnectionStatus.disconnected,
              );
            }
          default:
            break;
        }
      },
      onError: (_) {
        if (!mounted) return;
        _stopPolling();
        state = state.copyWith(
          connectionStatus: ConnectionStatus.disconnected,
          errorMessage:
              'Connection failed. Move closer to the device and try again.',
        );
      },
    );
  }

  Future<void> _startPolling() async {
    _pollingTimer?.cancel();
    if (!mounted) return;
    final settings = await _settingsRepository.load();
    if (!mounted) return;
    // Trigger an immediate first read on connect.
    refresh();
    _scheduleNextPoll(settings.pollingIntervalSeconds);
  }

  /// Self-rescheduling one-shot timer so interval changes in Settings take
  /// effect on the very next cycle without needing a reconnect.
  void _scheduleNextPoll(int intervalSeconds) {
    _currentPollingInterval = intervalSeconds;
    _pollingTimer?.cancel();
    if (!mounted) return;
    _pollingTimer = Timer(Duration(seconds: intervalSeconds), () async {
      if (!mounted) return;
      await refresh();
      if (!mounted) return;
      final settings = await _settingsRepository.load();
      if (mounted) _scheduleNextPoll(settings.pollingIntervalSeconds);
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Checks whether the most recent reading is older than 2× the polling
  /// interval and updates connectionStatus to stale/connected accordingly.
  void _checkStaleness() {
    if (!mounted || state.reading == null) return;
    if (state.connectionStatus != ConnectionStatus.connected &&
        state.connectionStatus != ConnectionStatus.stale) return;
    final age = DateTime.now()
        .difference(state.reading!.timestamp)
        .inSeconds;
    final isStale = age > _currentPollingInterval * 2;
    state = state.copyWith(
      connectionStatus:
          isStale ? ConnectionStatus.stale : ConnectionStatus.connected,
    );
  }

  /// Explicitly disconnects from the device. Call before navigating to Discovery.
  Future<void> disconnect() async {
    _intentionalDisconnect = true;
    _stopPolling();
    await _connectionSub?.cancel();
    _connectionSub = null;
    if (mounted) {
      state = state.copyWith(connectionStatus: ConnectionStatus.disconnected);
    }
  }

  /// Re-initiates connection after an unexpected drop.
  Future<void> reconnect() async {
    _intentionalDisconnect = false;
    _stopPolling();
    await _connectionSub?.cancel();
    _connectionSub = null;
    if (mounted) {
      state = state.copyWith(connectionLost: false);
      _initConnection();
    }
  }

  Future<void> refresh() async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final temp = await _bleClient.readTemperature(deviceId);
      final humidity = await _bleClient.readHumidity(deviceId);

      if (!mounted) return;

      if (temp == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Could not read temperature from device.',
        );
        _checkStaleness();
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

      // Query 24h min/max after storing the new reading.
      final since = now.subtract(const Duration(hours: 24));
      final minTemp = await _readingsRepository.getMinTemperatureSince(since);
      final maxTemp = await _readingsRepository.getMaxTemperatureSince(since);

      if (!mounted) return;
      // A fresh read is never stale — force back to connected before staleness check.
      state = state.copyWith(
        isLoading: false,
        reading: reading,
        connectionLost: false,
        connectionStatus: ConnectionStatus.connected,
        minTempC: minTemp,
        maxTempC: maxTemp,
      );
      _checkStaleness();
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to refresh: $e',
      );
      _checkStaleness();
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _connectionSub?.cancel();
    super.dispose();
  }
}
