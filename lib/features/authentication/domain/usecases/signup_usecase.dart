import '../repositories/authentication_repository.dart';
import '../../data/models/user.dart';

class SignupUseCase {
  final AuthenticationRepository repository;
  SignupUseCase(this.repository);

  Future<AppUser> call(String email, String password, String? displayName) {
    return repository.signup(email, password, displayName);
  }
}
