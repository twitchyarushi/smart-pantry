import '../repositories/preferences_repository.dart';
import '../../../../core/data/models/preferences.dart';

class SavePreferencesUseCase {
  final PreferencesRepository repository;
  SavePreferencesUseCase(this.repository);

  Future<void> call(Preferences preferences) {
    return repository.savePreferences(preferences);
  }
}
