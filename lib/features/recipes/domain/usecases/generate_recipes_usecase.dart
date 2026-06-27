import '../repositories/recipe_repository.dart';
import '../../data/models/recipe.dart';

class GenerateRecipesUseCase {
  final RecipeRepository repository;
  GenerateRecipesUseCase(this.repository);

  Future<List<Recipe>> call(List<String> ingredients) {
    return repository.generateRecipes(ingredients);
  }
}
