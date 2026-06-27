import '../repositories/recipe_repository.dart';

class DeleteRecipeUseCase {
  final RecipeRepository repository;
  DeleteRecipeUseCase(this.repository);

  Future<void> call(String recipeId) {
    return repository.deleteRecipe(recipeId);
  }
}
