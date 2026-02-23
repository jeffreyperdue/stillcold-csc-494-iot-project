import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/primary_button.dart';
import '../../../core/di/providers.dart';

final settingsFutureProvider = FutureProvider((ref) async {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.load();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncSettings = ref.watch(settingsFutureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: asyncSettings.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, _) =>
                  Center(child: Text('Failed to load settings: $error')),
          data: (settings) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Units & polling',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Use Fahrenheit'),
                        subtitle: const Text('Toggle between °C and °F.'),
                        value: settings.useFahrenheit,
                        onChanged: (value) async {
                          await ref
                              .read(settingsRepositoryProvider)
                              .update(useFahrenheit: value);
                          ref.invalidate(settingsFutureProvider);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Polling interval'),
                        subtitle: Text(
                          'Every ${settings.pollingIntervalSeconds}s',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final options = [5, 10, 15, 30];
                          final selected = await showModalBottomSheet<int>(
                            context: context,
                            builder: (context) {
                              return ListView(
                                shrinkWrap: true,
                                children: options
                                    .map(
                                      (v) => RadioListTile<int>(
                                        title: Text('Every ${v}s'),
                                        value: v,
                                        groupValue:
                                            settings.pollingIntervalSeconds,
                                        onChanged: (value) {
                                          Navigator.of(context).pop(value);
                                        },
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          );
                          if (selected != null &&
                              selected != settings.pollingIntervalSeconds) {
                            await ref
                                .read(settingsRepositoryProvider)
                                .update(pollingIntervalSeconds: selected);
                            ref.invalidate(settingsFutureProvider);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Thresholds & alerts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Temperature thresholds'),
                        subtitle: Text(
                          'Low: ${settings.lowThresholdC.toStringAsFixed(1)} °C, '
                          'High: ${settings.highThresholdC.toStringAsFixed(1)} °C',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final lowController = TextEditingController(
                            text: settings.lowThresholdC.toStringAsFixed(1),
                          );
                          final highController = TextEditingController(
                            text: settings.highThresholdC.toStringAsFixed(1),
                          );

                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    const Text('Temperature thresholds (°C)'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: lowController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        signed: false,
                                        decimal: true,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Low threshold (°C)',
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: highController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        signed: false,
                                        decimal: true,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'High threshold (°C)',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (result == true) {
                            final low = double.tryParse(lowController.text);
                            final high = double.tryParse(highController.text);
                            if (low != null && high != null) {
                              await ref
                                  .read(settingsRepositoryProvider)
                                  .update(
                                    lowThresholdC: low,
                                    highThresholdC: high,
                                  );
                              ref.invalidate(settingsFutureProvider);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter valid numeric thresholds.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Quiet hours'),
                        subtitle: Text(
                          settings.quietHoursStartMinutes != null &&
                                  settings.quietHoursEndMinutes != null
                              ? 'From ${_formatMinutesForDisplay(settings.quietHoursStartMinutes!)} '
                                  'to ${_formatMinutesForDisplay(settings.quietHoursEndMinutes!)}'
                              : 'Not set',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final start = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 22, minute: 0),
                          );
                          if (start == null) return;
                          final end = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 7, minute: 0),
                          );
                          if (end == null) return;

                          final startMinutes =
                              start.hour * 60 + start.minute;
                          final endMinutes = end.hour * 60 + end.minute;

                          await ref.read(settingsRepositoryProvider).update(
                                quietHoursStartMinutes: startMinutes,
                                quietHoursEndMinutes: endMinutes,
                              );
                          ref.invalidate(settingsFutureProvider);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Devices & history',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Device labels'),
                        subtitle: const Text(
                          'Assign names like “Kitchen fridge” (manage from discovery).',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/discovery'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Alert history'),
                        subtitle: const Text(
                          'Review when thresholds were crossed.',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/alerts'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Done',
                  icon: Icons.check,
                  onPressed: () => context.pop(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

String _formatMinutesForDisplay(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  final two = (int v) => v.toString().padLeft(2, '0');
  return '${two(h)}:${two(m)}';
}

