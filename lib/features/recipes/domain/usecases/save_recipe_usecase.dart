import '../repositories/recipe_repository.dart';
import '../../data/models/recipe.dart';

class SaveRecipeUseCase {
  final RecipeRepository repository;
  SaveRecipeUseCase(this.repository);

  Future<void> call(Recipe recipe) {
    return repository.saveRecipe(recipe);
  }
}
