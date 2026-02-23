import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to StillCold'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monitor your cold storage with confidence.',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This companion app connects to your StillCold device over Bluetooth Low Energy (BLE) '
                'to show live temperature (and humidity) readings from your fridge, freezer, or lab space.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              _OnboardingCard(
                icon: Icons.bluetooth_searching,
                title: 'Bluetooth only, no cloud',
                body:
                    'Data stays on your phone. The app connects directly to your nearby StillCold device using BLE.',
              ),
              const SizedBox(height: 16),
              _OnboardingCard(
                icon: Icons.sensors,
                title: 'Live temperature & humidity',
                body:
                    'See current readings and trends so you know if your cold storage is staying in a safe range.',
              ),
              const SizedBox(height: 16),
              _OnboardingCard(
                icon: Icons.notifications_active,
                title: 'Threshold alerts',
                body:
                    'Configure high / low thresholds and get notified when temperatures drift out of range.',
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Get started',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go('/discovery'),
              ),
              const SizedBox(height: 8),
              Text(
                'You can change these settings later from the Settings screen.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

