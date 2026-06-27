import '../../data/models/ingredient.dart';

abstract class PantryRepository {
  Future<void> saveIngredient(Ingredient ingredient);
  Future<void> updateIngredient(Ingredient ingredient);
  Future<void> deleteIngredient(String ingredientId);
  Future<List<Ingredient>> loadIngredients();
  Future<void> saveScannedIngredients(List<Ingredient> ingredients, {Uri? imageUrl});
}
