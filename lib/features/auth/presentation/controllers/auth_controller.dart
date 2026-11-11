import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singersinc/core/config/env_config.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/services/supabase_provider.dart';
import 'package:singersinc/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:singersinc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:singersinc/features/auth/domain/entities/app_user.dart';
import 'package:singersinc/features/auth/domain/repositories/auth_repository.dart';
import 'package:singersinc/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:singersinc/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:singersinc/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:singersinc/features/auth/domain/usecases/sign_up_usecase.dart';

/// Providers de Injeção de Dependência da feature `auth`.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthDataSource(client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
});

/// StreamProvider que acompanha em tempo real o usuário autenticado.
final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

/// Estado imutável da camada de apresentação de Autenticação.
class AuthUiState {
  const AuthUiState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.infoMessage,
  });

  final AppUser? user;
  final bool isLoading;
  final String? errorMessage;
  final String? infoMessage;

  bool get isAuthenticated => user != null;

  AuthUiState copyWith({
    AppUser? Function()? user,
    bool? isLoading,
    String? Function()? errorMessage,
    String? Function()? infoMessage,
  }) {
    return AuthUiState(
      user: user != null ? user() : this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      infoMessage: infoMessage != null ? infoMessage() : this.infoMessage,
    );
  }
}

/// Controller (Notifier) responsável por coordenar ações de login, cadastro,
/// recuperação de senha e logout na interface.
class AuthController extends Notifier<AuthUiState> {
  StreamSubscription<AppUser?>? _authSubscription;

  static const defaultDevUser = AppUser(
    id: EnvConfig.devUserId,
    email: EnvConfig.devUserEmail,
  );

  @override
  AuthUiState build() {
    final repo = ref.watch(authRepositoryProvider);
    _authSubscription?.cancel();
    _authSubscription = repo.authStateChanges.listen((user) {
      if (user != null) {
        state = state.copyWith(user: () => user);
      } else if (EnvConfig.bypassAuth) {
        state = state.copyWith(user: () => defaultDevUser);
      } else {
        state = state.copyWith(user: () => null);
      }
    });

    ref.onDispose(() {
      _authSubscription?.cancel();
    });

    final currentUser = repo.currentUser;
    if (currentUser != null) {
      return AuthUiState(user: currentUser);
    }
    if (EnvConfig.bypassAuth) {
      return const AuthUiState(user: defaultDevUser);
    }
    return const AuthUiState();
  }

  void clearMessages() {
    state = state.copyWith(
      errorMessage: () => null,
      infoMessage: () => null,
    );
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      infoMessage: () => null,
    );

    final result = await ref.read(signInUseCaseProvider)(
      email: email,
      password: password,
    );

    return result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      onSuccess: (AppUser user) {
        state = state.copyWith(
          isLoading: false,
          user: () => user,
          errorMessage: () => null,
        );
        return true;
      },
    );
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      infoMessage: () => null,
    );

    final result = await ref.read(signUpUseCaseProvider)(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    return result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      onSuccess: (AppUser user) {
        state = state.copyWith(
          isLoading: false,
          user: () => ref.read(authRepositoryProvider).currentUser ?? user,
          infoMessage: () =>
              'Conta criada com sucesso! Caso necessário, confirme seu e-mail.',
        );
        return true;
      },
    );
  }

  Future<bool> sendPasswordReset({required String email}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      infoMessage: () => null,
    );

    final result = await ref.read(resetPasswordUseCaseProvider)(email: email);

    return result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      onSuccess: (_) {
        state = state.copyWith(
          isLoading: false,
          infoMessage: () =>
              'Enviamos as instruções de recuperação para o seu e-mail.',
        );
        return true;
      },
    );
  }

  Future<void> signOut() async {
    if (EnvConfig.bypassAuth) {
      state = state.copyWith(
        isLoading: false,
        user: () => defaultDevUser,
      );
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    final result = await ref.read(signOutUseCaseProvider)();
    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
      },
      onSuccess: (_) {
        state = state.copyWith(
          isLoading: false,
          user: () => null,
        );
      },
    );
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthUiState>(AuthController.new);

