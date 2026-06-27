import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_pantry/core/widgets/widgets.dart';
import 'package:smart_pantry/features/pantry/data/models/ingredient.dart';
import 'package:smart_pantry/features/pantry/presentation/providers/pantry_providers.dart';

final pantryIngredientsProvider = FutureProvider<List<Ingredient>>((ref) async {
  final useCase = ref.watch(loadIngredientsUseCaseProvider);
  return useCase.call();
});

class PantryListScreen extends ConsumerWidget {
  const PantryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncIngredients = ref.watch(pantryIngredientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantry'),
        actions: [
          IconButton(
            onPressed: () => context.push('/pantry/scanner'),
            icon: const Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: asyncIngredients.when(
        data: (ingredients) {
          if (ingredients.isEmpty) {
            return EmptyStateView(
              message: 'No ingredients yet - scan your pantry',
              icon: Icons.kitchen_outlined,
              actionLabel: 'Scan pantry',
              onAction: () => context.push('/pantry/scanner'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return _IngredientCard(ingredient: ingredient);
            },
          );
        },
        loading: () => const LoadingSkeleton(),
        error: (_, __) => ErrorStateView(
          message: 'Could not load pantry - tap to retry',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(pantryIngredientsProvider),
        ),
      ),
    );
  }
}

class _IngredientCard extends StatelessWidget {
  const _IngredientCard({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            child: Text(ingredient.name.characters.first.toUpperCase()),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ingredient.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppChip(label: '${ingredient.quantity} ${ingredient.unit}'),
                    AppChip(label: ingredient.category, icon: Icons.category_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
