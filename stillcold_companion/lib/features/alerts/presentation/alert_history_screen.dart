import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';

final alertHistoryProvider = FutureProvider((ref) async {
  final repo = ref.watch(alertsRepositoryProvider);
  // Show last 7 days by default.
  final from = DateTime.now().subtract(const Duration(days: 7));
  final alerts = await repo.getAlertsSince(from);
  alerts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return alerts;
});

class AlertHistoryScreen extends ConsumerWidget {
  const AlertHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncAlerts = ref.watch(alertHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert history'),
      ),
      body: SafeArea(
        child: asyncAlerts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Failed to load alert history: $error'),
          ),
          data: (alerts) {
            if (alerts.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No alerts recorded in the last 7 days.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(24),
              itemBuilder: (context, index) {
                final alert = alerts[index];
                final when = _formatTimestamp(alert.timestamp);
                final direction = alert.isHighThreshold ? 'High' : 'Low';
                final valueText =
                    '${alert.temperatureC.toStringAsFixed(1)} °C';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: alert.isHighThreshold
                        ? Colors.red.shade50
                        : Colors.blue.shade50,
                    child: Icon(
                      alert.isHighThreshold
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: alert.isHighThreshold
                          ? Colors.redAccent
                          : Colors.blueAccent,
                    ),
                  ),
                  title: Text('$direction threshold crossed'),
                  subtitle: Text('$valueText • $when'),
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: alerts.length,
            );
          },
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime ts) {
    final now = DateTime.now();
    final diff = now.difference(ts);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inDays < 1) return '${diff.inHours} h ago';
    return '${ts.year}-${_two(ts.month)}-${_two(ts.day)} ${_two(ts.hour)}:${_two(ts.minute)}';
  }

  String _two(int v) => v.toString().padLeft(2, '0');
}

