class AppSettings {
  AppSettings({
    required this.id,
    required this.useFahrenheit,
    required this.lowThresholdC,
    required this.highThresholdC,
    required this.pollingIntervalSeconds,
    this.quietHoursStartMinutes,
    this.quietHoursEndMinutes,
    this.lastConnectedDeviceId,
  });

  final int id;
  final bool useFahrenheit;
  final double lowThresholdC;
  final double highThresholdC;
  final int pollingIntervalSeconds;
  final int? quietHoursStartMinutes;
  final int? quietHoursEndMinutes;
  final String? lastConnectedDeviceId;
}

