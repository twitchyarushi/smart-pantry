// ignore_for_file: invalid_annotation_target

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_pantry/features/pantry/data/repositories/firestore_pantry_repository.dart';
import 'package:smart_pantry/features/pantry/domain/repositories/pantry_repository.dart';
import 'package:smart_pantry/features/pantry/domain/usecases/delete_ingredient_usecase.dart';
import 'package:smart_pantry/features/pantry/domain/usecases/load_ingredients_usecase.dart';
import 'package:smart_pantry/features/pantry/domain/usecases/save_ingredient_usecase.dart';
import 'package:smart_pantry/features/pantry/domain/usecases/save_scanned_ingredients_usecase.dart';
import 'package:smart_pantry/features/pantry/domain/usecases/update_ingredient_usecase.dart';

final pantryRepositoryProvider = Provider<PantryRepository>((ref) {
  return FirestorePantryRepository();
});

final loadIngredientsUseCaseProvider = Provider<LoadIngredientsUseCase>((ref) {
  return LoadIngredientsUseCase(ref.watch(pantryRepositoryProvider));
});

final saveIngredientUseCaseProvider = Provider<SaveIngredientUseCase>((ref) {
  return SaveIngredientUseCase(ref.watch(pantryRepositoryProvider));
});

final saveScannedIngredientsUseCaseProvider = Provider<SaveScannedIngredientsUseCase>((ref) {
  return SaveScannedIngredientsUseCase(ref.watch(pantryRepositoryProvider));
});

final updateIngredientUseCaseProvider = Provider<UpdateIngredientUseCase>((ref) {
  return UpdateIngredientUseCase(ref.watch(pantryRepositoryProvider));
});

final deleteIngredientUseCaseProvider = Provider<DeleteIngredientUseCase>((ref) {
  return DeleteIngredientUseCase(ref.watch(pantryRepositoryProvider));
});
