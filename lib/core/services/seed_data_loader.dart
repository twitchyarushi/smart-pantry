import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/seed_data.dart';

class SeedDataLoader {
  SeedDataLoader._();
  static final _instance = SeedDataLoader._();
  factory SeedDataLoader() => _instance;

  final _storage = const FlutterSecureStorage();
  final _firestore = FirebaseFirestore.instance;

  Future<void> initializeDemoData() async {
    const key = 'seed_data_loaded';
    if (!kIsWeb) {
      final loaded = await _storage.read(key: key);
      if (loaded == 'true') return;
    }

    final pantryBatch = _firestore.batch();
    final shoppingBatch = _firestore.batch();
    final recipesBatch = _firestore.batch();

    final pantryCollection = _firestore.collection('pantry');
    for (final ingredient in demoPantryIngredients) {
      pantryBatch.set(pantryCollection.doc(), ingredient);
    }

    final shoppingCollection = _firestore.collection('shopping');
    for (final item in demoShoppingItems) {
      shoppingBatch.set(shoppingCollection.doc(), item);
    }

    final recipesCollection = _firestore.collection('recipes');
    for (final recipe in demoRecipes) {
      recipesBatch.set(recipesCollection.doc(), recipe);
    }

    await Future.wait([
      pantryBatch.commit(),
      shoppingBatch.commit(),
      recipesBatch.commit(),
    ]);
    if (!kIsWeb) {
      await _storage.write(key: key, value: 'true');
    }
  }
}
