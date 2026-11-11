import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/auth/domain/entities/app_user.dart';

/// Contrato (interface) do repositório de autenticação na camada de Domínio.
/// Desacopla as regras de negócio da implementação do Supabase Auth.
abstract interface class AuthRepository {
  /// Usuário atualmente autenticado na sessão local/remota, ou `null`.
  AppUser? get currentUser;

  /// Stream reativa de mudanças no estado de autenticação.
  Stream<AppUser?> get authStateChanges;

  /// Realiza login com e-mail e senha.
  Future<Result<AppUser>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Cadastra um novo usuário com e-mail e senha.
  Future<Result<AppUser>> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  /// Envia e-mail de recuperação de senha.
  Future<Result<void>> sendPasswordResetEmail({
    required String email,
  });

  /// Encerra a sessão atual.
  Future<Result<void>> signOut();
}

