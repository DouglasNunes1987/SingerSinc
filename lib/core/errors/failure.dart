/// Representa falhas tratadas na camada de Domínio (Domain Layer),
/// desacopladas de exceções específicas de pacotes externos.
sealed class Failure {
  const Failure(this.message, {this.code});

  final String message;
  final String? code;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => Object.hash(runtimeType, message, code);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

final class ConflictFailure extends Failure {
  const ConflictFailure(super.message, {super.code});
}

/// Resultado funcional tipado (Success ou Err) para evitar uso de exceções
/// no controle de fluxo das regras de negócio (Use Cases e Repositories).
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;

  T? get dataOrNull => switch (this) {
        Success<T>(:final value) => value,
        Err<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Err<T>(:final failure) => failure,
      };

  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T value) onSuccess,
  }) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      Err<T>(:final failure) => onFailure(failure),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}

