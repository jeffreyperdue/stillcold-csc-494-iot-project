class BleConfig {
  BleConfig._();

  // TODO: Replace these with the actual UUIDs from the embedded implementation.
  static const String deviceName = 'StillCold';

  static const String serviceUuid = '12345678-1234-1234-1234-1234567890ab';
  static const String temperatureCharacteristicUuid =
      'abcd1234-5678-1234-5678-abcdef123456';
  static const String humidityCharacteristicUuid =
      'abcd5678-1234-5678-1234-abcdef654321';
}
