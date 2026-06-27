import '../repositories/pantry_repository.dart';

class DeleteIngredientUseCase {
  final PantryRepository repository;
  DeleteIngredientUseCase(this.repository);

  Future<void> call(String ingredientId) {
    return repository.deleteIngredient(ingredientId);
  }
}
