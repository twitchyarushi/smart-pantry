import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/gemini_service.dart';
import '../../data/models/ingredient.dart';
import '../../domain/repositories/pantry_repository.dart';

class FirestorePantryRepository implements PantryRepository {
  final FirebaseFirestore _firestore;
  final GeminiService _geminiService;

  FirestorePantryRepository({FirebaseFirestore? firestore, GeminiService? geminiService})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _geminiService = geminiService ?? GeminiService();

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('pantry');

  @override
  Future<void> saveIngredient(Ingredient ingredient) async {
    await _collection.add(ingredient.toJson());
  }

  @override
  Future<void> updateIngredient(Ingredient ingredient) async {
    await _collection.doc(ingredient.name).set(ingredient.toJson());
  }

  @override
  Future<void> deleteIngredient(String ingredientId) async {
    await _collection.doc(ingredientId).delete();
  }

  @override
  Future<List<Ingredient>> loadIngredients() async {
    final snapshot = await _collection.get();
    final ingredients = <Ingredient>[];

    for (final doc in snapshot.docs) {
      try {
        ingredients.add(Ingredient.fromJson(doc.data()));
      } catch (_) {}
    }

    return ingredients;
  }

  @override
  Future<void> saveScannedIngredients(List<Ingredient> ingredients, {Uri? imageUrl}) async {
    if (imageUrl != null) {
      try {
        await _geminiService.identifyIngredientFromImage(imageUrl);
      } catch (_) {}
    }
    for (final ingredient in ingredients) {
      await _collection.add(ingredient.toJson());
    }
  }
}
