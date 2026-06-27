import '../../data/models/shopping_item.dart';

abstract class ShoppingRepository {
  Future<void> addItem(ShoppingItem item);
  Future<void> updateItem(ShoppingItem item);
  Future<void> removeItem(String itemId);
  Future<List<ShoppingItem>> loadItems();
}
