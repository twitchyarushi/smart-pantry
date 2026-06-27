import '../../../../core/data/models/preferences.dart';

abstract class PreferencesRepository {
  Future<Preferences> loadPreferences();
  Future<void> savePreferences(Preferences preferences);
}
