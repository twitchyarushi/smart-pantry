import '../../data/models/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> loadRecipes();
  Future<void> saveRecipe(Recipe recipe);
  Future<void> deleteRecipe(String recipeId);
  Future<List<Recipe>> generateRecipes(List<String> ingredients);
}
