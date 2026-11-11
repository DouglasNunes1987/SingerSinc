/// Exceções tipadas lançadas pela camada de acesso a dados (Data Layer).
sealed class AppException implements Exception {
  const AppException(this.message, {this.code, this.cause});

  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() =>
      '$runtimeType(message: $message, code: $code, cause: $cause)';
}

final class AuthServerException extends AppException {
  const AuthServerException(super.message, {super.code, super.cause});
}

final class LocalDatabaseException extends AppException {
  const LocalDatabaseException(super.message, {super.code, super.cause});
}

final class RemoteServerException extends AppException {
  const RemoteServerException(super.message, {super.code, super.cause});
}

final class StorageFileException extends AppException {
  const StorageFileException(super.message, {super.code, super.cause});
}

final class SyncConflictException extends AppException {
  const SyncConflictException(super.message, {super.code, super.cause});
}

