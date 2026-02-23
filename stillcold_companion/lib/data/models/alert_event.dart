class AlertEvent {
  AlertEvent({
    required this.id,
    required this.deviceId,
    required this.timestamp,
    required this.temperatureC,
    this.humidityPercent,
    required this.isHighThreshold,
  });

  final int id;
  final String deviceId;
  final DateTime timestamp;
  final double temperatureC;
  final double? humidityPercent;
  final bool isHighThreshold;
}

