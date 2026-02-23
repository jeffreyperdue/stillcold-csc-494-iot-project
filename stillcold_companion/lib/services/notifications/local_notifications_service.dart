import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  LocalNotificationsService() {
    _init();
  }

  final _plugin = FlutterLocalNotificationsPlugin();
  static const _channelId = 'stillcold_alerts';

  Future<void> _init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      'StillCold alerts',
      description: 'Notifications when thresholds are crossed.',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> showThresholdAlert({
    required bool isHigh,
    required double temperatureC,
    double? humidityPercent,
    String? deviceLabel,
  }) async {
    final title =
        isHigh ? 'Temperature is too warm' : 'Temperature is too cold';

    final deviceText =
        deviceLabel != null && deviceLabel.isNotEmpty ? ' ($deviceLabel)' : '';

    final humidityText = humidityPercent != null
        ? ', humidity ${humidityPercent.toStringAsFixed(0)}%'
        : '';

    final body =
        'Current temperature$deviceText is ${temperatureC.toStringAsFixed(1)} °C$humidityText.';

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      'StillCold alerts',
      channelDescription: 'Notifications when thresholds are crossed.',
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.alarm,
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      title,
      body,
      details,
    );
  }
}

