import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_chip.dart';
import '../../settings/presentation/settings_screen.dart'
    show settingsFutureProvider;
import '../application/dashboard_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key, required this.deviceId});

  final String deviceId;

  static String routeForDevice(String deviceId) => '/dashboard/$deviceId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(dashboardControllerProvider(deviceId));
    final controller =
        ref.read(dashboardControllerProvider(deviceId).notifier);
    final settingsAsync = ref.watch(settingsFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StillCold'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
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
                          'StillCold device',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const StatusChip(status: ConnectionStatus.connected),
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
                        style: theme.textTheme.bodyMedium,
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
                    primaryActionLabel: 'Refresh',
                    onPrimaryAction: () => controller.refresh(),
                  ),
                )
              else ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Temperature',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _formatTemperature(
                                      state.reading?.temperatureC,
                                      settingsAsync,
                                    ),
                                    style: theme.textTheme.displayMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      _temperatureUnit(settingsAsync),
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Humidity',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  state.reading?.humidityPercent
                                          ?.toStringAsFixed(0) ??
                                      '--',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    '%',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isLoading ? null : () => controller.refresh(),
        icon: const Icon(Icons.refresh),
        label: Text(state.isLoading ? 'Refreshing...' : 'Refresh'),
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


