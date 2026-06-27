import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/routes/app_router.dart';
import 'core/services/firebase_service.dart';
import 'core/services/seed_data_loader.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

final appStartupProvider = FutureProvider<void>((ref) async {
  try {
    await dotenv.load(fileName: '.env', isOptional: true);
  } catch (_) {
    // Ignore if .env is not present on first launch.
  }
  await FirebaseService.instance.initialize();
  try {
    await SeedDataLoader().initializeDemoData();
  } catch (_) {}
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(appStartupProvider);

    return MaterialApp.router(
      title: 'Smart Pantry',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: startup.when(
        data: (_) => ref.watch(appRouterProvider),
        loading: () => _startupRouter,
        error: (error, _) => _startupRouter,
      ),
      builder: (context, child) {
        return startup.when(
          data: (_) => child ?? const SizedBox.shrink(),
          loading: () => const _StartupLoadingView(),
          error: (error, _) => _StartupErrorView(message: error.toString()),
        );
      },
    );
  }
}

final GoRouter _startupRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SizedBox.shrink(),
    ),
  ],
);

class _StartupLoadingView extends StatelessWidget {
  const _StartupLoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.kitchen_outlined, size: 48, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text('Starting Smart Pantry', style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                const SizedBox(
                  width: 240,
                  height: 92,
                  child: LoadingSkeleton(itemCount: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StartupErrorView extends StatelessWidget {
  const _StartupErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorStateView(
        message: 'Could not start Smart Pantry: $message',
      ),
    );
  }
}
