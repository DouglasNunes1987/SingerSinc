import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para encerrar a sessão do usuário autenticado.
class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() {
    return _repository.signOut();
  }
}

