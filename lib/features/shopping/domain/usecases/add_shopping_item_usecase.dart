import '../repositories/shopping_repository.dart';
import '../../data/models/shopping_item.dart';

class AddShoppingItemUseCase {
  final ShoppingRepository repository;
  AddShoppingItemUseCase(this.repository);

  Future<void> call(ShoppingItem item) {
    return repository.addItem(item);
  }
}
