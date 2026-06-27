import '../repositories/shopping_repository.dart';

class RemoveShoppingItemUseCase {
  final ShoppingRepository repository;
  RemoveShoppingItemUseCase(this.repository);

  Future<void> call(String itemId) {
    return repository.removeItem(itemId);
  }
}
