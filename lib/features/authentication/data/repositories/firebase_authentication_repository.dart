import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../data/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  final fb_auth.FirebaseAuth _auth;

  FirebaseAuthenticationRepository({fb_auth.FirebaseAuth? auth}) : _auth = auth ?? fb_auth.FirebaseAuth.instance;

  @override
  Future<AppUser> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = result.user!;
    return AppUser(
      id: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<AppUser> signup(String email, String password, String? displayName) async {
    final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = result.user!;
    if (displayName != null && displayName.isNotEmpty) {
      await user.updateDisplayName(displayName);
      await user.reload();
    }
    return AppUser(
      id: user.uid,
      displayName: displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }
}
