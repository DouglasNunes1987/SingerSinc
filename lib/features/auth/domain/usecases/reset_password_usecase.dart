import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/utils/validators.dart';
import 'package:singersinc/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para solicitar envio de e-mail de redefinição de senha.
class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call({required String email}) async {
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      return Err(ValidationFailure(emailError));
    }

    return _repository.sendPasswordResetEmail(email: email.trim());
  }
}

