import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../core/config/ble_config.dart';

class StillColdDevice {
  StillColdDevice({
    required this.id,
    required this.name,
    required this.rssi,
  });

  final String id;
  final String name;
  final int rssi;
}

class BleConnectionState {
  BleConnectionState({
    required this.deviceId,
    required this.connectionState,
    required this.rssi,
  });

  final String deviceId;
  final DeviceConnectionState connectionState;
  final int? rssi;
}

class BleClient {
  BleClient(this._ble);

  final FlutterReactiveBle _ble;

  BleStatus get bleStatus => _ble.status;

  Stream<BleStatus> get statusStream => _ble.statusStream;

  Stream<List<StillColdDevice>> scanForStillColdDevices() {
    return _ble
        .scanForDevices(
          withServices: const [],
          scanMode: ScanMode.lowLatency,
        )
        .where((device) => device.name == BleConfig.deviceName)
        .map(
          (device) => [
            StillColdDevice(
              id: device.id,
              name: device.name,
              rssi: device.rssi,
            ),
          ],
        );
  }

  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 15),
      // Providing exact service/characteristic UUIDs lets flutter_reactive_ble
      // skip the full GATT discovery phase on every connect, cutting 2–5 s of
      // connection overhead on Android.
      servicesWithCharacteristicsToDiscover: {
        Uuid.parse(BleConfig.serviceUuid): [
          Uuid.parse(BleConfig.temperatureCharacteristicUuid),
          Uuid.parse(BleConfig.humidityCharacteristicUuid),
        ],
      },
    );
  }

  Future<double?> readTemperature(String deviceId) async {
    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse(BleConfig.serviceUuid),
      characteristicId: Uuid.parse(BleConfig.temperatureCharacteristicUuid),
      deviceId: deviceId,
    );

    final value = await _ble.readCharacteristic(characteristic);
    final asString = String.fromCharCodes(value).trim();
    if (asString.isEmpty) return null;
    return double.tryParse(asString);
  }

  Future<double?> readHumidity(String deviceId) async {
    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse(BleConfig.serviceUuid),
      characteristicId: Uuid.parse(BleConfig.humidityCharacteristicUuid),
      deviceId: deviceId,
    );

    final value = await _ble.readCharacteristic(characteristic);
    final asString = String.fromCharCodes(value).trim();
    if (asString.isEmpty) return null;
    return double.tryParse(asString);
  }
}

