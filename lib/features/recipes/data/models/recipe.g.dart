// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
  title: json['title'] as String,
  description: json['description'] as String,
  prepTime: (json['prepTime'] as num).toInt(),
  cookTime: (json['cookTime'] as num).toInt(),
  macros: Map<String, num>.from(json['macros'] as Map),
  difficulty: json['difficulty'] as String,
  ingredients: (json['ingredients'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  instructions: (json['instructions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  cuisine: json['cuisine'] as String,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'prepTime': instance.prepTime,
  'cookTime': instance.cookTime,
  'macros': instance.macros,
  'difficulty': instance.difficulty,
  'ingredients': instance.ingredients,
  'instructions': instance.instructions,
  'cuisine': instance.cuisine,
  'tags': instance.tags,
};
