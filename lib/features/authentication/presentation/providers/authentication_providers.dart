// ignore_for_file: invalid_annotation_target

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_pantry/features/authentication/data/repositories/firebase_authentication_repository.dart';
import 'package:smart_pantry/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:smart_pantry/features/authentication/domain/usecases/login_usecase.dart';
import 'package:smart_pantry/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:smart_pantry/features/authentication/domain/usecases/signup_usecase.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return FirebaseAuthenticationRepository();
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authenticationRepositoryProvider));
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(ref.watch(authenticationRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authenticationRepositoryProvider));
});
