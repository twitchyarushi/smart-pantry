import '../repositories/pantry_repository.dart';
import '../../data/models/ingredient.dart';

class UpdateIngredientUseCase {
  final PantryRepository repository;
  UpdateIngredientUseCase(this.repository);

  Future<void> call(Ingredient ingredient) {
    return repository.updateIngredient(ingredient);
  }
}
