import 'package:singersinc/core/errors/app_exception.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:singersinc/features/auth/domain/entities/app_user.dart';
import 'package:singersinc/features/auth/domain/repositories/auth_repository.dart';

/// Implementação concreta de [AuthRepository] que converte exceções da camada
/// de dados em objetos [Failure] seguros para a camada de Domínio.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  AppUser? get currentUser => _remoteDataSource.currentUser;

  @override
  Stream<AppUser?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<Result<AppUser>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      return Success(user);
    } on AuthServerException catch (e) {
      return Err(AuthFailure(e.message, code: e.code));
    } catch (_) {
      return const Err(
        AuthFailure('Ocorreu um erro inesperado ao entrar na sua conta.'),
      );
    }
  }

  @override
  Future<Result<AppUser>> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
      );
      return Success(user);
    } on AuthServerException catch (e) {
      return Err(AuthFailure(e.message, code: e.code));
    } catch (_) {
      return const Err(
        AuthFailure('Ocorreu um erro inesperado ao criar sua conta.'),
      );
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email: email);
      return const Success(null);
    } on AuthServerException catch (e) {
      return Err(AuthFailure(e.message, code: e.code));
    } catch (_) {
      return const Err(
        AuthFailure('Não foi possível enviar o e-mail de recuperação.'),
      );
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Success(null);
    } on AuthServerException catch (e) {
      return Err(AuthFailure(e.message, code: e.code));
    } catch (_) {
      return const Err(
        AuthFailure('Não foi possível encerrar a sessão.'),
      );
    }
  }
}

