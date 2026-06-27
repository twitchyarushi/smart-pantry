import 'package:firebase_core/firebase_core.dart';
import 'package:smart_pantry/firebase_options.dart';

class FirebaseService {
  FirebaseService._();
  static final instance = FirebaseService._();

  Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
