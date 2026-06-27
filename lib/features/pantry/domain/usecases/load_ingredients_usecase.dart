import '../repositories/pantry_repository.dart';
import '../../data/models/ingredient.dart';

class LoadIngredientsUseCase {
  final PantryRepository repository;
  LoadIngredientsUseCase(this.repository);

  Future<List<Ingredient>> call() {
    return repository.loadIngredients();
  }
}
