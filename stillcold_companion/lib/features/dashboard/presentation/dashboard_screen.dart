import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart' show deviceLabelForIdProvider;
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_chip.dart';
import '../../settings/presentation/settings_screen.dart'
    show settingsFutureProvider;
import '../application/dashboard_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    super.key,
    required this.deviceId,
    this.rssi,
  });

  final String deviceId;

  /// Signal strength at the time the device was selected in Discovery.
  final int? rssi;

  static String routeForDevice(String deviceId) => '/dashboard/$deviceId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(dashboardControllerProvider(deviceId));
    final controller =
        ref.read(dashboardControllerProvider(deviceId).notifier);
    final settingsAsync = ref.watch(settingsFutureProvider);
    final labelAsync = ref.watch(deviceLabelForIdProvider(deviceId));
    final deviceTitle = labelAsync.maybeWhen(
      data: (label) => label ?? 'StillCold device',
      orElse: () => 'StillCold device',
    );

    final isConnected = state.connectionStatus == ConnectionStatus.connected ||
        state.connectionStatus == ConnectionStatus.stale;
    final isStale = state.connectionStatus == ConnectionStatus.stale;

    return Scaffold(
      appBar: AppBar(
        title: const Text('StillCold'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
          IconButton(
            tooltip: 'Disconnect',
            icon: const Icon(Icons.link_off),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Disconnect?'),
                  content: const Text(
                    'Are you sure you want to disconnect from this device?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Disconnect'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await controller.disconnect();
                if (context.mounted) context.go('/discovery');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (state.connectionLost)
              _ConnectionLostBanner(
                onReconnect: () => controller.reconnect(),
                onGoToDiscovery: () => context.go('/discovery'),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deviceTitle,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  StatusChip(status: state.connectionStatus),
                                  if (rssi != null) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      'Signal: $rssi dBm',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Last updated',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.reading == null
                                  ? 'Not yet'
                                  : _formatTimeAgo(state.reading!.timestamp),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isStale ? Colors.amber.shade700 : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (state.reading == null && state.errorMessage != null)
                      Expanded(
                        child: EmptyState(
                          icon: Icons.thermostat,
                          title: 'No reading yet',
                          message: state.errorMessage!,
                          primaryActionLabel: isConnected ? 'Refresh' : null,
                          onPrimaryAction:
                              isConnected ? () => controller.refresh() : null,
                        ),
                      )
                    else ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Temperature',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              _formatTemperature(
                                                state.reading?.temperatureC,
                                                settingsAsync,
                                              ),
                                              style: theme
                                                  .textTheme.displayMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Text(
                                                _temperatureUnit(settingsAsync),
                                                style: theme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Humidity',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            state.reading?.humidityPercent
                                                    ?.toStringAsFixed(0) ??
                                                '--',
                                            style: theme
                                                .textTheme.headlineMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              '%',
                                              style: theme
                                                  .textTheme.titleMedium
                                                  ?.copyWith(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (state.minTempC != null &&
                                  state.maxTempC != null) ...[
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    const Icon(Icons.arrow_downward,
                                        size: 16, color: Colors.blueAccent),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_formatTemperature(state.minTempC, settingsAsync)} ${_temperatureUnit(settingsAsync)}',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.arrow_upward,
                                        size: 16, color: Colors.redAccent),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_formatTemperature(state.maxTempC, settingsAsync)} ${_temperatureUnit(settingsAsync)}',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '24h range',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Trends (mock)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'Trend chart placeholder\n(24h / 7d)',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Opacity(
        opacity: (state.isLoading || !isConnected) ? 0.4 : 1.0,
        child: FloatingActionButton.extended(
          onPressed: (state.isLoading || !isConnected)
              ? null
              : () => controller.refresh(),
          icon: const Icon(Icons.refresh),
          label: Text(
            state.isLoading
                ? 'Refreshing...'
                : (!isConnected ? 'Not connected' : 'Refresh'),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 10) return 'Just now';
    if (diff.inMinutes < 1) return '${diff.inSeconds}s ago';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  String _formatTemperature(
    double? tempC,
    AsyncValue<dynamic> settingsAsync,
  ) {
    if (tempC == null) return '--';
    final useF = settingsAsync.maybeWhen(
      data: (s) => s.useFahrenheit as bool,
      orElse: () => false,
    );
    final value = useF ? (tempC * 9 / 5 + 32) : tempC;
    return value.toStringAsFixed(1);
  }

  String _temperatureUnit(AsyncValue<dynamic> settingsAsync) {
    final useF = settingsAsync.maybeWhen(
      data: (s) => s.useFahrenheit as bool,
      orElse: () => false,
    );
    return useF ? '°F' : '°C';
  }
}

class _ConnectionLostBanner extends StatelessWidget {
  const _ConnectionLostBanner({
    required this.onReconnect,
    required this.onGoToDiscovery,
  });

  final VoidCallback onReconnect;
  final VoidCallback onGoToDiscovery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.errorContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            size: 20,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Connection lost',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onErrorContainer,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            onPressed: onReconnect,
            child: const Text('Reconnect'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onErrorContainer,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            onPressed: onGoToDiscovery,
            child: const Text('Scan'),
          ),
        ],
      ),
    );
  }
}
