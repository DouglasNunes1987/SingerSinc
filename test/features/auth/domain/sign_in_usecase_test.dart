import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/auth/domain/entities/app_user.dart';
import 'package:singersinc/features/auth/domain/repositories/auth_repository.dart';
import 'package:singersinc/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:singersinc/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:singersinc/features/auth/domain/usecases/sign_up_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository mockRepository;
  late SignInUseCase signInUseCase;
  late SignUpUseCase signUpUseCase;
  late ResetPasswordUseCase resetPasswordUseCase;

  const testUser = AppUser(
    id: 'user-123',
    email: 'professor@singersinc.com',
  );

  setUp(() {
    mockRepository = _MockAuthRepository();
    signInUseCase = SignInUseCase(mockRepository);
    signUpUseCase = SignUpUseCase(mockRepository);
    resetPasswordUseCase = ResetPasswordUseCase(mockRepository);
  });

  group('SignInUseCase', () {
    test('deve retornar ValidationFailure quando o e-mail for inválido',
        () async {
      final result = await signInUseCase(
        email: 'email-invalido',
        password: 'password123',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      verifyZeroInteractions(mockRepository);
    });

    test('deve retornar ValidationFailure quando a senha tiver menos de 6 caracteres',
        () async {
      final result = await signInUseCase(
        email: 'professor@singersinc.com',
        password: '123',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      verifyZeroInteractions(mockRepository);
    });

    test('deve autenticar e retornar AppUser quando credenciais forem válidas',
        () async {
      when(
        () => mockRepository.signInWithEmailPassword(
          email: 'professor@singersinc.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => const Success(testUser));

      final result = await signInUseCase(
        email: '  professor@singersinc.com  ',
        password: 'password123',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(testUser));
      verify(
        () => mockRepository.signInWithEmailPassword(
          email: 'professor@singersinc.com',
          password: 'password123',
        ),
      ).called(1);
    });
  });

  group('SignUpUseCase', () {
    test('deve retornar ValidationFailure quando confirmação de senha divergir',
        () async {
      final result = await signUpUseCase(
        email: 'professor@singersinc.com',
        password: 'password123',
        confirmPassword: 'password999',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      verifyZeroInteractions(mockRepository);
    });
  });

  group('ResetPasswordUseCase', () {
    test('deve chamar sendPasswordResetEmail com e-mail higienizado', () async {
      when(
        () => mockRepository.sendPasswordResetEmail(
          email: 'professor@singersinc.com',
        ),
      ).thenAnswer((_) async => const Success(null));

      final result = await resetPasswordUseCase(
        email: ' professor@singersinc.com ',
      );

      expect(result.isSuccess, isTrue);
      verify(
        () => mockRepository.sendPasswordResetEmail(
          email: 'professor@singersinc.com',
        ),
      ).called(1);
    });
  });
}

