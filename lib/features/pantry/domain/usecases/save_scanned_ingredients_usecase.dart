import '../repositories/pantry_repository.dart';
import '../../data/models/ingredient.dart';

class SaveScannedIngredientsUseCase {
  final PantryRepository repository;
  SaveScannedIngredientsUseCase(this.repository);

  Future<void> call(List<Ingredient> ingredients, {Uri? imageUrl}) {
    return repository.saveScannedIngredients(ingredients, imageUrl: imageUrl);
  }
}
