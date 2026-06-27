// ignore_for_file: invalid_annotation_target

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_pantry/features/shopping/data/repositories/firestore_shopping_repository.dart';
import 'package:smart_pantry/features/shopping/domain/repositories/shopping_repository.dart';
import 'package:smart_pantry/features/shopping/domain/usecases/add_shopping_item_usecase.dart';
import 'package:smart_pantry/features/shopping/domain/usecases/load_shopping_items_usecase.dart';
import 'package:smart_pantry/features/shopping/domain/usecases/remove_shopping_item_usecase.dart';
import 'package:smart_pantry/features/shopping/domain/usecases/update_shopping_item_usecase.dart';

final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  return FirestoreShoppingRepository();
});

final loadShoppingItemsUseCaseProvider = Provider<LoadShoppingItemsUseCase>((ref) {
  return LoadShoppingItemsUseCase(ref.watch(shoppingRepositoryProvider));
});

final addShoppingItemUseCaseProvider = Provider<AddShoppingItemUseCase>((ref) {
  return AddShoppingItemUseCase(ref.watch(shoppingRepositoryProvider));
});

final updateShoppingItemUseCaseProvider = Provider<UpdateShoppingItemUseCase>((ref) {
  return UpdateShoppingItemUseCase(ref.watch(shoppingRepositoryProvider));
});

final removeShoppingItemUseCaseProvider = Provider<RemoveShoppingItemUseCase>((ref) {
  return RemoveShoppingItemUseCase(ref.watch(shoppingRepositoryProvider));
});
