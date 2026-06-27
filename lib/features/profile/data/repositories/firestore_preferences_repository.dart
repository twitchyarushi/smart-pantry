import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/preferences.dart';
import '../../domain/repositories/preferences_repository.dart';

class FirestorePreferencesRepository implements PreferencesRepository {
  final FirebaseFirestore _firestore;

  FirestorePreferencesRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('preferences');

  @override
  Future<Preferences> loadPreferences() async {
    final snapshot = await _collection.doc('current').get();
    if (!snapshot.exists) {
      return const Preferences();
    }
    return Preferences.fromJson(snapshot.data() ?? {});
  }

  @override
  Future<void> savePreferences(Preferences preferences) async {
    await _collection.doc('current').set(preferences.toJson());
  }
}
