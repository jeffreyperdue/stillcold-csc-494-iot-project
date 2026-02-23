import 'package:flutter/material.dart';
import 'primary_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.primaryActionLabel,
    this.onPrimaryAction,
  });

  final String title;
  final String message;
  final IconData? icon;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 56,
                color: theme.colorScheme.primary.withOpacity(0.75),
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            if (primaryActionLabel != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                label: primaryActionLabel!,
                onPressed: onPrimaryAction,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

