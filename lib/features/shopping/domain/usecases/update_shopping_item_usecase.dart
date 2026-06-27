import '../repositories/shopping_repository.dart';
import '../../data/models/shopping_item.dart';

class UpdateShoppingItemUseCase {
  final ShoppingRepository repository;
  UpdateShoppingItemUseCase(this.repository);

  Future<void> call(ShoppingItem item) {
    return repository.updateItem(item);
  }
}
