// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Preferences _$PreferencesFromJson(Map<String, dynamic> json) => _Preferences(
  locale: json['locale'] as String?,
  darkMode: json['darkMode'] as bool?,
  defaultUnits: json['defaultUnits'] as String?,
);

Map<String, dynamic> _$PreferencesToJson(_Preferences instance) =>
    <String, dynamic>{
      'locale': instance.locale,
      'darkMode': instance.darkMode,
      'defaultUnits': instance.defaultUnits,
    };
