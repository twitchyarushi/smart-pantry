// ignore_for_file: invalid_annotation_target

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_pantry/features/profile/data/repositories/firestore_preferences_repository.dart';
import 'package:smart_pantry/features/profile/domain/repositories/preferences_repository.dart';
import 'package:smart_pantry/features/profile/domain/usecases/load_preferences_usecase.dart';
import 'package:smart_pantry/features/profile/domain/usecases/save_preferences_usecase.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return FirestorePreferencesRepository();
});

final loadPreferencesUseCaseProvider = Provider<LoadPreferencesUseCase>((ref) {
  return LoadPreferencesUseCase(ref.watch(preferencesRepositoryProvider));
});

final savePreferencesUseCaseProvider = Provider<SavePreferencesUseCase>((ref) {
  return SavePreferencesUseCase(ref.watch(preferencesRepositoryProvider));
});
