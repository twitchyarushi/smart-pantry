import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

@freezed
abstract class Ingredient with _$Ingredient {
  @JsonSerializable()
  const factory Ingredient({
    required String name,
    required String category,
    required num quantity,
    required String unit,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime expiration,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

DateTime _dateTimeFromJson(Object value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is DateTime) {
    return value;
  }
  if (value is String) {
    return DateTime.parse(value);
  }

  throw ArgumentError.value(
    value,
    'value',
    'Expected Timestamp, DateTime, or ISO date string',
  );
}

String _dateTimeToJson(DateTime value) => value.toIso8601String();
