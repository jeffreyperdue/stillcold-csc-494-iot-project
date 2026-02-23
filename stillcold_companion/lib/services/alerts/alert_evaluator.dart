import '../notifications/local_notifications_service.dart';
import '../../data/repositories/alerts_repository.dart';
import '../../data/repositories/settings_repository.dart';

class AlertEvaluator {
  AlertEvaluator({
    required AlertsRepository alertsRepository,
    required SettingsRepository settingsRepository,
    required LocalNotificationsService notificationsService,
  })  : _alertsRepository = alertsRepository,
        _settingsRepository = settingsRepository,
        _notificationsService = notificationsService;

  final AlertsRepository _alertsRepository;
  final SettingsRepository _settingsRepository;
  final LocalNotificationsService _notificationsService;

  Future<void> evaluateAndAlert({
    required String deviceId,
    required double temperatureC,
    double? humidityPercent,
    required DateTime timestamp,
  }) async {
    final settings = await _settingsRepository.load();

    final low = settings.lowThresholdC;
    final high = settings.highThresholdC;

    final withinQuietHours = _isWithinQuietHours(
      timestamp,
      settings.quietHoursStartMinutes,
      settings.quietHoursEndMinutes,
    );

    if (withinQuietHours) {
      return;
    }

    bool? isHigh;
    if (temperatureC > high) {
      isHigh = true;
    } else if (temperatureC < low) {
      isHigh = false;
    }

    if (isHigh == null) {
      return;
    }

    await _alertsRepository.addAlert(
      deviceId: deviceId,
      timestamp: timestamp,
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
      isHighThreshold: isHigh,
    );

    await _notificationsService.showThresholdAlert(
      isHigh: isHigh,
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
      deviceLabel: null,
    );
  }

  bool _isWithinQuietHours(
    DateTime now,
    int? startMinutes,
    int? endMinutes,
  ) {
    if (startMinutes == null || endMinutes == null) {
      return false;
    }

    final minutesSinceMidnight = now.hour * 60 + now.minute;

    if (startMinutes <= endMinutes) {
      return minutesSinceMidnight >= startMinutes &&
          minutesSinceMidnight <= endMinutes;
    } else {
      // Quiet hours wrap around midnight.
      return minutesSinceMidnight >= startMinutes ||
          minutesSinceMidnight <= endMinutes;
    }
  }
}

