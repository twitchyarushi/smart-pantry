import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_pantry/core/services/gemini_service.dart';
import 'package:smart_pantry/core/widgets/widgets.dart';
import 'package:smart_pantry/features/pantry/presentation/providers/pantry_providers.dart';
import 'package:smart_pantry/features/recipes/data/models/recipe.dart';

final generatedRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final pantryIngredients = await ref.watch(loadIngredientsUseCaseProvider).call();
  if (pantryIngredients.isEmpty) {
    return [];
  }

  final ingredientNames = pantryIngredients.map((item) => item.name).toList();
  final response = await GeminiService().generateRecipeSuggestions(ingredientNames);
  final rawRecipes = response['recipes'];

  if (rawRecipes is! List) {
    throw StateError('Gemini did not return any recipes');
  }

  return rawRecipes
      .whereType<Map>()
      .map((item) => _recipeFromGeminiJson(Map<String, dynamic>.from(item)))
      .toList();
});

Recipe _recipeFromGeminiJson(Map<String, dynamic> json) {
  return Recipe(
    title: json['title']?.toString() ?? 'Untitled Recipe',
    description: json['description']?.toString() ?? '',
    prepTime: (json['prepTime'] as num?)?.toInt() ?? 10,
    cookTime: (json['cookTime'] as num?)?.toInt() ?? 20,
    macros: json['macros'] is Map
        ? Map<String, num>.from(json['macros'] as Map)
        : const {'calories': 0, 'protein': 0, 'fat': 0, 'carbs': 0},
    difficulty: json['difficulty']?.toString() ?? 'Easy',
    ingredients: (json['ingredients'] as List?)
            ?.map((item) => Map<String, dynamic>.from(item as Map))
            .toList() ??
        [],
    instructions:
        (json['instructions'] as List?)?.map((item) => item.toString()).toList() ?? [],
    cuisine: json['cuisine']?.toString() ?? '',
    tags: (json['tags'] as List?)?.map((item) => item.toString()).toList() ?? [],
  );
}

class RecipeListScreen extends ConsumerWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRecipes = ref.watch(generatedRecipesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: asyncRecipes.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return const EmptyStateView(
              message: 'Add ingredients to your pantry to generate recipe ideas',
              icon: Icons.receipt_long_outlined,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return _RecipeCard(recipe: recipe);
            },
          );
        },
        loading: () => const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('Generating recipes from your pantry...'),
            ),
            Expanded(child: LoadingSkeleton()),
          ],
        ),
        error: (error, _) => ErrorStateView(
          message: 'Could not generate recipes - tap to retry',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(generatedRecipesProvider),
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () => context.push('/recipes/${recipe.title}', extra: recipe),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                child: const Icon(Icons.restaurant_menu),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipe.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      recipe.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppChip(label: '${recipe.prepTime + recipe.cookTime} min', icon: Icons.schedule),
              AppChip(label: recipe.difficulty, icon: Icons.local_fire_department_outlined),
              if (recipe.cuisine.isNotEmpty) AppChip(label: recipe.cuisine, icon: Icons.public),
            ],
          ),
        ],
      ),
    );
  }
}
