import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
abstract class Recipe with _$Recipe {
  const factory Recipe({
    required String title,
    required String description,
    required int prepTime,
    required int cookTime,
    required Map<String, num> macros,
    required String difficulty,
    required List<Map<String, dynamic>> ingredients,
    required List<String> instructions,
    required String cuisine,
    required List<String> tags,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
