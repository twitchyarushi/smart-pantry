import 'package:flutter/material.dart';
import 'package:smart_pantry/core/widgets/widgets.dart';
import 'package:smart_pantry/features/recipes/data/models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, this.recipe});

  final Recipe? recipe;

  @override
  Widget build(BuildContext context) {
    final selectedRecipe = recipe;
    if (selectedRecipe == null) {
      return const Scaffold(
        body: EmptyStateView(
          message: 'No recipe selected',
          icon: Icons.receipt_long_outlined,
        ),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(selectedRecipe.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedRecipe.description, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppChip(label: 'Prep: ${selectedRecipe.prepTime} min'),
                    AppChip(label: 'Cook: ${selectedRecipe.cookTime} min'),
                    AppChip(label: selectedRecipe.difficulty),
                    AppChip(label: selectedRecipe.cuisine),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text('Ingredients', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ...selectedRecipe.ingredients.map(
            (item) => AppCard(
              child: Text(
                item['name']?.toString() ?? 'Ingredient',
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Instructions', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          ...selectedRecipe.instructions.asMap().entries.map(
                (entry) => AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                        child: Text('${entry.key + 1}'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(entry.value, style: theme.textTheme.bodyLarge),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
