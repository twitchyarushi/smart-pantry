import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_pantry/core/constants/seed_data.dart';
import '../../../../core/services/gemini_service.dart';
import '../../data/models/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';

class FirestoreRecipeRepository implements RecipeRepository {
  final FirebaseFirestore _firestore;
  final GeminiService _geminiService;

  FirestoreRecipeRepository({FirebaseFirestore? firestore, GeminiService? geminiService})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _geminiService = geminiService ?? GeminiService();

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('recipes');

  @override
  Future<List<Recipe>> generateRecipes(List<String> ingredients) async {
    try {
      final response = await _geminiService.generateRecipeSuggestions(ingredients);
      if (response['recipes'] is List) {
        return (response['recipes'] as List).map((item) => Recipe.fromJson(Map<String, dynamic>.from(item))).toList();
      }
    } catch (_) {}
    return _demoRecipes();
  }

  @override
  Future<List<Recipe>> loadRecipes() async {
    try {
      final snapshot = await _collection.get();
      final recipes = snapshot.docs.map((doc) => Recipe.fromJson(doc.data())).toList();
      return recipes.isEmpty ? _demoRecipes() : recipes;
    } catch (_) {
      return _demoRecipes();
    }
  }

  List<Recipe> _demoRecipes() {
    return demoRecipes.map((item) => Recipe.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    await _collection.add(recipe.toJson());
  }

  @override
  Future<void> deleteRecipe(String recipeId) async {
    await _collection.doc(recipeId).delete();
  }
}
