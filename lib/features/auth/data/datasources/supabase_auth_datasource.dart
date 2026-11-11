import 'package:singersinc/core/errors/app_exception.dart';
import 'package:singersinc/features/auth/domain/entities/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Contrato da fonte de dados remota de autenticação.
abstract interface class AuthRemoteDataSource {
  AppUser? get currentUser;
  Stream<AppUser?> get authStateChanges;

  Future<AppUser> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AppUser> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();
}

/// Implementação da fonte de dados remota utilizando Supabase Auth (`GoTrueClient`).
class SupabaseAuthDataSource implements AuthRemoteDataSource {
  const SupabaseAuthDataSource(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  AppUser? get currentUser {
    final user = _supabaseClient.auth.currentUser;
    return user != null ? _mapUser(user) : null;
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((authState) {
      final user = authState.session?.user;
      return user != null ? _mapUser(user) : null;
    });
  }

  @override
  Future<AppUser> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw const AuthServerException(
          'Não foi possível recuperar a sessão do usuário.',
        );
      }
      return _mapUser(user);
    } on AuthException catch (e) {
      throw AuthServerException(
        _translateAuthError(e.message),
        code: e.statusCode,
        cause: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthServerException(
        'Erro de comunicação ao realizar login.',
        cause: e,
      );
    }
  }

  @override
  Future<AppUser> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw const AuthServerException(
          'Não foi possível concluir o cadastro do usuário.',
        );
      }
      return _mapUser(user);
    } on AuthException catch (e) {
      throw AuthServerException(
        _translateAuthError(e.message),
        code: e.statusCode,
        cause: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthServerException(
        'Erro de comunicação ao realizar cadastro.',
        cause: e,
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthServerException(
        _translateAuthError(e.message),
        code: e.statusCode,
        cause: e,
      );
    } catch (e) {
      throw AuthServerException(
        'Erro ao solicitar redefinição de senha.',
        cause: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw AuthServerException(
        _translateAuthError(e.message),
        code: e.statusCode,
        cause: e,
      );
    } catch (e) {
      throw AuthServerException(
        'Erro ao encerrar a sessão.',
        cause: e,
      );
    }
  }

  AppUser _mapUser(User user) {
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  String _translateAuthError(String rawMessage) {
    final lower = rawMessage.toLowerCase();
    if (lower.contains('invalid login credentials')) {
      return 'E-mail ou senha inválidos.';
    }
    if (lower.contains('email not confirmed')) {
      return 'E-mail ainda não confirmado. Verifique sua caixa de entrada.';
    }
    if (lower.contains('user already registered')) {
      return 'Este e-mail já está cadastrado.';
    }
    if (lower.contains('rate limit')) {
      return 'Muitas tentativas. Aguarde alguns instantes e tente novamente.';
    }
    return rawMessage;
  }
}

