// ignore_for_file: invalid_annotation_target

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_pantry/features/recipes/data/repositories/firestore_recipe_repository.dart';
import 'package:smart_pantry/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:smart_pantry/features/recipes/domain/usecases/delete_recipe_usecase.dart';
import 'package:smart_pantry/features/recipes/domain/usecases/generate_recipes_usecase.dart';
import 'package:smart_pantry/features/recipes/domain/usecases/load_recipes_usecase.dart';
import 'package:smart_pantry/features/recipes/domain/usecases/save_recipe_usecase.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return FirestoreRecipeRepository();
});

final loadRecipesUseCaseProvider = Provider<LoadRecipesUseCase>((ref) {
  return LoadRecipesUseCase(ref.watch(recipeRepositoryProvider));
});

final saveRecipeUseCaseProvider = Provider<SaveRecipeUseCase>((ref) {
  return SaveRecipeUseCase(ref.watch(recipeRepositoryProvider));
});

final deleteRecipeUseCaseProvider = Provider<DeleteRecipeUseCase>((ref) {
  return DeleteRecipeUseCase(ref.watch(recipeRepositoryProvider));
});

final generateRecipesUseCaseProvider = Provider<GenerateRecipesUseCase>((ref) {
  return GenerateRecipesUseCase(ref.watch(recipeRepositoryProvider));
});
