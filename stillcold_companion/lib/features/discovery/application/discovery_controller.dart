import 'dart:async';

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
  DiscoveryController(this._bleClient) : super(const DiscoveryState());

  final BleClient _bleClient;
  StreamSubscription<List<StillColdDevice>>? _scanSub;

  Future<void> startScan() async {
    if (state.isScanning) return;

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
        state = state.copyWith(
          isScanning: false,
          errorMessage: 'Scan failed: $error',
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

