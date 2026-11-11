import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/utils/validators.dart';
import 'package:singersinc/features/auth/domain/entities/app_user.dart';
import 'package:singersinc/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para cadastro de novo usuário.
class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AppUser>> call({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      return Err(ValidationFailure(emailError));
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      return Err(ValidationFailure(passwordError));
    }

    if (password != confirmPassword) {
      return const Err(
        ValidationFailure('A confirmação de senha não confere.'),
      );
    }

    return _repository.signUpWithEmailPassword(
      email: email.trim(),
      password: password,
    );
  }
}

