import '../repositories/pantry_repository.dart';
import '../../data/models/ingredient.dart';

class SaveIngredientUseCase {
  final PantryRepository repository;
  SaveIngredientUseCase(this.repository);

  Future<void> call(Ingredient ingredient) {
    return repository.saveIngredient(ingredient);
  }
}
