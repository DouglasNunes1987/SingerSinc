import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/utils/validators.dart';
import 'package:singersinc/features/auth/domain/entities/app_user.dart';
import 'package:singersinc/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para autenticar um professor com e-mail e senha.
class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AppUser>> call({
    required String email,
    required String password,
  }) async {
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      return Err(ValidationFailure(emailError));
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      return Err(ValidationFailure(passwordError));
    }

    return _repository.signInWithEmailPassword(
      email: email.trim(),
      password: password,
    );
  }
}

