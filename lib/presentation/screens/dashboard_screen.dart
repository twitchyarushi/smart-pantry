import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_pantry/core/routes/app_router.dart';
import 'package:smart_pantry/core/widgets/widgets.dart';
import 'package:smart_pantry/features/authentication/presentation/providers/authentication_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final logoutUseCase = ref.watch(logoutUseCaseProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await logoutUseCase.call();
              if (context.mounted) {
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: authState.when(
        data: (user) {
          final name = user?.displayName ?? user?.email ?? 'user';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                user == null ? 'Welcome' : 'Welcome back, $name',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Keep your pantry, recipes, and shopping list moving together.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _NavCard(
                title: 'Pantry',
                subtitle: 'View and add ingredients',
                route: '/pantry',
                icon: Icons.kitchen,
              ),
              _NavCard(
                title: 'Pantry Scanner',
                subtitle: 'Scan receipts and save ingredients',
                route: '/pantry/scanner',
                icon: Icons.camera_alt,
              ),
              _NavCard(
                title: 'Recipes',
                subtitle: 'Generate recipe ideas',
                route: '/recipes',
                icon: Icons.receipt_long,
              ),
              _NavCard(
                title: 'Shopping',
                subtitle: 'Track what to buy',
                route: '/shopping',
                icon: Icons.shopping_cart,
              ),
              _NavCard(
                title: 'Profile',
                subtitle: 'Preferences and account',
                route: '/profile',
                icon: Icons.person,
              ),
            ],
          );
        },
        loading: () => const LoadingSkeleton(itemCount: 5),
        error: (_, __) => const ErrorStateView(message: 'Could not load dashboard state'),
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String route;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () => context.go(route),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            child: Icon(icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
