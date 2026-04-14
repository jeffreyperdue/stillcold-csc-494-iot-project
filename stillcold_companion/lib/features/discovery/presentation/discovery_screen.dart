import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/di/providers.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../settings/presentation/settings_screen.dart'
    show settingsFutureProvider;
import '../application/discovery_controller.dart';

class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(discoveryControllerProvider);
    final controller = ref.read(discoveryControllerProvider.notifier);
    final settingsAsync = ref.watch(settingsFutureProvider);

    // FR-1.6: Auto-navigate when the last-connected device first appears in scan results.
    // Only fires when the user has auto-connect enabled in Settings.
    ref.listen(discoveryControllerProvider, (prev, next) {
      final s = settingsAsync.maybeWhen(data: (s) => s, orElse: () => null);
      if (s == null || s.lastConnectedDeviceId == null) return;
      if (!s.autoConnectEnabled) return;
      if (!next.isScanning) return;
      final appearedNow = next.devices.any((d) => d.id == s.lastConnectedDeviceId) &&
          (prev == null || !prev.devices.any((d) => d.id == s.lastConnectedDeviceId));
      if (appearedNow) {
        final device = next.devices.firstWhere((d) => d.id == s.lastConnectedDeviceId);
        ref.read(selectedDeviceIdProvider.notifier).state = device.id;
        context.push(
          DashboardScreen.routeForDevice(device.id),
          extra: device.rssi,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover devices'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.bluetooth,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Make sure Bluetooth is enabled and your StillCold device is powered on.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            settingsAsync.maybeWhen(
              data: (settings) {
                final lastId = settings.lastConnectedDeviceId;
                if (lastId == null) return const SizedBox.shrink();
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.history, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Last connected device ID: $lastId\nTap it below to reconnect if it\'s in range.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
            if (state.errorMessage != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: state.devices.isEmpty
                  ? EmptyState(
                      icon: Icons.search,
                      title: state.isScanning
                          ? 'Scanning for StillCold devices...'
                          : 'No devices found yet',
                      message: state.isScanning
                          ? 'Looking for devices named "StillCold" nearby.'
                          : 'When you scan, StillCold devices in range will appear here. '
                              'Long-press a device to assign a label like "Kitchen fridge".',
                      primaryActionLabel:
                          state.isScanning ? 'Stop scan' : 'Scan for devices',
                      onPrimaryAction: () {
                        state.isScanning
                            ? controller.stopScan()
                            : controller.startScan();
                      },
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(24),
                            itemBuilder: (context, index) {
                              final device = state.devices[index];
                              final labelAsync =
                                  ref.watch(deviceLabelForIdProvider(device.id));
                              final fallbackName = device.name.isEmpty
                                  ? 'StillCold (${device.id.substring(0, 4)})'
                                  : device.name;
                              final titleText = labelAsync.maybeWhen(
                                data: (label) => label ?? fallbackName,
                                orElse: () => fallbackName,
                              );
                              return ListTile(
                                leading: Icon(
                                  Icons.sensors,
                                  color: theme.colorScheme.primary,
                                ),
                                title: Text(titleText),
                                subtitle: Text('RSSI: ${device.rssi} dBm'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  ref
                                      .read(selectedDeviceIdProvider.notifier)
                                      .state = device.id;
                                  context.push(
                                    DashboardScreen.routeForDevice(device.id),
                                    extra: device.rssi,
                                  );
                                },
                                // FR-1.8: Long-press to assign or update device label.
                                onLongPress: () async {
                                  final currentLabel = labelAsync.maybeWhen(
                                    data: (l) => l,
                                    orElse: () => null,
                                  );
                                  final textController =
                                      TextEditingController(text: currentLabel ?? '');
                                  final result = await showDialog<String?>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Device label'),
                                      content: TextField(
                                        controller: textController,
                                        autofocus: true,
                                        decoration: const InputDecoration(
                                          hintText: 'e.g. Kitchen fridge',
                                          labelText: 'Label',
                                        ),
                                        onSubmitted: (_) =>
                                            Navigator.pop(ctx, textController.text.trim()),
                                      ),
                                      actions: [
                                        if (currentLabel != null)
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx, ''),
                                            child: const Text('Remove'),
                                          ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, null),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              ctx, textController.text.trim()),
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (result == null) return;
                                  if (result.isEmpty) {
                                    await ref
                                        .read(deviceLabelsRepositoryProvider)
                                        .deleteLabel(device.id);
                                  } else {
                                    await ref
                                        .read(deviceLabelsRepositoryProvider)
                                        .upsertLabel(
                                          deviceId: device.id,
                                          label: result,
                                        );
                                  }
                                  ref.invalidate(deviceLabelForIdProvider(device.id));
                                },
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemCount: state.devices.length,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            'Long-press a device to assign a label.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: PrimaryButton(
          label: state.isScanning ? 'Stop scan' : 'Scan for devices',
          icon: state.isScanning ? Icons.stop : Icons.search,
          onPressed:
              state.isScanning ? controller.stopScan : controller.startScan,
        ),
      ),
    );
  }
}
