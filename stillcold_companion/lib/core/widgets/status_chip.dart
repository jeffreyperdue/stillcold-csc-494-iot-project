import 'package:flutter/material.dart';

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  stale,
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
  });

  final ConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color background;
    Color dotColor;
    String label;

    switch (status) {
      case ConnectionStatus.connected:
        background = const Color(0xFFE6F5EA);
        dotColor = const Color(0xFF1EAF5D);
        label = 'Connected';
        break;
      case ConnectionStatus.connecting:
        background = const Color(0xFFFFF4E5);
        dotColor = const Color(0xFFFB8C00);
        label = 'Connecting';
        break;
      case ConnectionStatus.stale:
        background = const Color(0xFFFFF4E5);
        dotColor = const Color(0xFFFB8C00);
        label = 'Stale';
        break;
      case ConnectionStatus.disconnected:
        background = const Color(0xFFF0F3F7);
        dotColor = const Color(0xFF7B8A96);
        label = 'Disconnected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

