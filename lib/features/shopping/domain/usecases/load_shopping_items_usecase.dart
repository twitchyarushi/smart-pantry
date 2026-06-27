import '../repositories/shopping_repository.dart';
import '../../data/models/shopping_item.dart';

class LoadShoppingItemsUseCase {
  final ShoppingRepository repository;
  LoadShoppingItemsUseCase(this.repository);

  Future<List<ShoppingItem>> call() {
    return repository.loadItems();
  }
}
