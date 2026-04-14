import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'data/local/app_database.dart';
import 'data/repositories/settings_repository.dart';
import 'features/alerts/presentation/alert_history_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/discovery/presentation/discovery_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/settings/presentation/settings_screen.dart';

// FR-5.5: First-run gate — users who have never connected see onboarding;
// everyone else goes directly to Discovery.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final settings = await SettingsRepository(db).load();
  await db.close();
  final initialRoute =
      settings.lastConnectedDeviceId != null ? '/discovery' : '/onboarding';
  runApp(ProviderScope(child: StillColdApp(initialRoute: initialRoute)));
}

class StillColdApp extends StatelessWidget {
  const StillColdApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/discovery',
          builder: (context, state) => const DiscoveryScreen(),
        ),
        GoRoute(
          path: '/dashboard/:deviceId',
          builder: (context, state) {
            final deviceId = state.pathParameters['deviceId']!;
            final rssi = state.extra as int?;
            return DashboardScreen(deviceId: deviceId, rssi: rssi);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/alerts',
          builder: (context, state) => const AlertHistoryScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'StillCold Companion',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }
}
