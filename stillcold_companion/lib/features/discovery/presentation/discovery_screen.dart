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

final deviceLabelForIdProvider =
    FutureProvider.family<String?, String>((ref, String deviceId) async {
  final repo = ref.watch(deviceLabelsRepositoryProvider);
  final label = await repo.getLabelForDevice(deviceId);
  return label?.label;
});

class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(discoveryControllerProvider);
    final controller = ref.read(discoveryControllerProvider.notifier);
    final settingsAsync = ref.watch(settingsFutureProvider);

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
                          ? 'Looking for devices named “StillCold” nearby.'
                          : 'When you scan, StillCold devices in range will appear here. '
                              'You can assign friendly labels like “Kitchen fridge” later.',
                      primaryActionLabel:
                          state.isScanning ? 'Stop scan' : 'Scan for devices',
                      onPrimaryAction: () {
                        state.isScanning
                            ? controller.stopScan()
                            : controller.startScan();
                      },
                    )
                  : ListView.separated(
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
                            context.go(
                              DashboardScreen.routeForDevice(device.id),
                            );
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemCount: state.devices.length,
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


