import '../repositories/authentication_repository.dart';
import '../../data/models/user.dart';

class LoginUseCase {
  final AuthenticationRepository repository;
  LoginUseCase(this.repository);

  Future<AppUser> call(String email, String password) {
    return repository.login(email, password);
  }
}
