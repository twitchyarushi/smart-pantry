import '../repositories/recipe_repository.dart';
import '../../data/models/recipe.dart';

class LoadRecipesUseCase {
  final RecipeRepository repository;
  LoadRecipesUseCase(this.repository);

  Future<List<Recipe>> call() {
    return repository.loadRecipes();
  }
}
