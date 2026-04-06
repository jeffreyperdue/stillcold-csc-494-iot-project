import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart'
    show BleStatus;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/di/providers.dart';
import '../../../services/ble/ble_client.dart';

class DiscoveryState {
  const DiscoveryState({
    this.isScanning = false,
    this.devices = const [],
    this.errorMessage,
  });

  final bool isScanning;
  final List<StillColdDevice> devices;
  final String? errorMessage;

  DiscoveryState copyWith({
    bool? isScanning,
    List<StillColdDevice>? devices,
    String? errorMessage,
  }) {
    return DiscoveryState(
      isScanning: isScanning ?? this.isScanning,
      devices: devices ?? this.devices,
      errorMessage: errorMessage,
    );
  }
}

final selectedDeviceIdProvider = StateProvider<String?>((ref) => null);

final discoveryControllerProvider =
    StateNotifierProvider<DiscoveryController, DiscoveryState>((ref) {
  final bleClient = ref.watch(bleClientProvider);
  return DiscoveryController(bleClient);
});

class DiscoveryController extends StateNotifier<DiscoveryState> {
  DiscoveryController(this._bleClient) : super(const DiscoveryState()) {
    _btStatusSub = _bleClient.statusStream.listen((status) {
      if (!mounted) return;
      if (status == BleStatus.poweredOff ||
          status == BleStatus.locationServicesDisabled) {
        _scanSub?.cancel();
        _scanSub = null;
        state = state.copyWith(
          isScanning: false,
          errorMessage:
              'Bluetooth is turned off. Please enable it in your device settings and try again.',
        );
      } else if (status == BleStatus.ready) {
        state = state.copyWith(errorMessage: null);
      }
    });
  }

  final BleClient _bleClient;
  StreamSubscription<List<StillColdDevice>>? _scanSub;
  StreamSubscription<BleStatus>? _btStatusSub;

  Future<void> startScan() async {
    if (state.isScanning) return;

    final btStatus = _bleClient.bleStatus;
    if (btStatus == BleStatus.poweredOff) {
      state = state.copyWith(
        isScanning: false,
        errorMessage:
            'Bluetooth is turned off. Please enable it in your device settings and try again.',
      );
      return;
    }
    if (btStatus == BleStatus.unauthorized) {
      state = state.copyWith(
        isScanning: false,
        errorMessage:
            'Bluetooth access is not authorized. Please grant Bluetooth permission to this app in Settings.',
      );
      return;
    }
    if (btStatus == BleStatus.unsupported) {
      state = state.copyWith(
        isScanning: false,
        errorMessage: 'This device does not support Bluetooth Low Energy.',
      );
      return;
    }

    final hasPermissions = await _ensurePermissions();
    if (!hasPermissions) {
      state = state.copyWith(
        isScanning: false,
        errorMessage:
            'Bluetooth / Location permissions are required to scan for StillCold devices.',
      );
      return;
    }

    state = state.copyWith(
      isScanning: true,
      devices: [],
      errorMessage: null,
    );

    _scanSub?.cancel();
    _scanSub = _bleClient.scanForStillColdDevices().listen(
      (devices) {
        // Merge devices by id to avoid duplicates.
        final merged = Map<String, StillColdDevice>.fromEntries(
          state.devices.map((d) => MapEntry(d.id, d)),
        );
        for (final d in devices) {
          merged[d.id] = d;
        }
        state = state.copyWith(devices: merged.values.toList());
      },
      onError: (error, _) {
        final msg = error.toString().toLowerCase();
        final friendlyMessage = msg.contains('bluetooth disabled') ||
                msg.contains('bluetooth is not available') ||
                msg.contains('bluetooth is off')
            ? 'Bluetooth is turned off. Please enable it in your device settings and try again.'
            : 'Scan failed: $error';
        state = state.copyWith(
          isScanning: false,
          errorMessage: friendlyMessage,
        );
      },
      onDone: () {
        state = state.copyWith(isScanning: false);
      },
    );
  }

  Future<void> stopScan() async {
    await _scanSub?.cancel();
    _scanSub = null;
    state = state.copyWith(isScanning: false);
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _btStatusSub?.cancel();
    super.dispose();
  }

  Future<bool> _ensurePermissions() async {
    final permissionsToRequest = <Permission>[
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ];

    final statuses = await permissionsToRequest.request();
    return statuses.values.every((status) => status.isGranted);
  }
}

