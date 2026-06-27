import '../../data/models/user.dart';

abstract class AuthenticationRepository {
  Future<AppUser> login(String email, String password);
  Future<void> logout();
  Future<AppUser> signup(String email, String password, String? displayName);
}
