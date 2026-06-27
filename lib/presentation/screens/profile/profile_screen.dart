import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_pantry/core/data/models/preferences.dart';
import 'package:smart_pantry/core/widgets/widgets.dart';
import 'package:smart_pantry/features/profile/presentation/providers/profile_providers.dart';

final preferencesProvider = FutureProvider<Preferences>((ref) async {
  final useCase = ref.watch(loadPreferencesUseCaseProvider);
  return useCase.call();
});

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncPreferences = ref.watch(preferencesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: asyncPreferences.when(
        data: (preferences) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Preferences', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              _PreferenceCard(
                icon: Icons.language,
                label: 'Locale',
                value: preferences.locale ?? 'default',
              ),
              _PreferenceCard(
                icon: Icons.dark_mode_outlined,
                label: 'Dark mode',
                value: '${preferences.darkMode ?? false}',
              ),
              _PreferenceCard(
                icon: Icons.straighten,
                label: 'Units',
                value: preferences.defaultUnits ?? 'default',
              ),
            ],
          );
        },
        loading: () => const LoadingSkeleton(itemCount: 3),
        error: (_, __) => ErrorStateView(
          message: 'Could not load preferences - tap to retry',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(preferencesProvider),
        ),
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
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
                Text(label, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
