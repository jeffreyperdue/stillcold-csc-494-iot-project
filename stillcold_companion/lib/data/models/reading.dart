class Reading {
  Reading({
    required this.id,
    required this.deviceId,
    required this.timestamp,
    required this.temperatureC,
    this.humidityPercent,
  });

  final int id;
  final String deviceId;
  final DateTime timestamp;
  final double temperatureC;
  final double? humidityPercent;
}

