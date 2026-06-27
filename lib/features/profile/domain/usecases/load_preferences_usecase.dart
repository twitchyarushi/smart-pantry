import '../repositories/preferences_repository.dart';
import '../../../../core/data/models/preferences.dart';

class LoadPreferencesUseCase {
  final PreferencesRepository repository;
  LoadPreferencesUseCase(this.repository);

  Future<Preferences> call() {
    return repository.loadPreferences();
  }
}
