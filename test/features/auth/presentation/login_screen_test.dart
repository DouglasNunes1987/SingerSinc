import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/auth/domain/entities/app_user.dart';
import 'package:singersinc/features/auth/domain/repositories/auth_repository.dart';
import 'package:singersinc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:singersinc/features/auth/presentation/screens/login_screen.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository mockRepository;
  late StreamController<AppUser?> authStreamController;

  setUp(() {
    mockRepository = _MockAuthRepository();
    authStreamController = StreamController<AppUser?>.broadcast();

    when(() => mockRepository.currentUser).thenReturn(null);
    when(() => mockRepository.authStateChanges)
        .thenAnswer((_) => authStreamController.stream);
  });

  tearDown(() async {
    await authStreamController.close();
  });

  Widget createSubject() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  testWidgets('deve exibir mensagens de validação ao submeter campos vazios',
      (tester) async {
    await tester.pumpWidget(createSubject());

    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pump();

    expect(find.text('Informe o seu e-mail.'), findsOneWidget);
    expect(find.text('Informe a sua senha.'), findsOneWidget);
  });

  testWidgets('deve exibir banner de erro quando as credenciais falharem',
      (tester) async {
    when(
      () => mockRepository.signInWithEmailPassword(
        email: 'prof@singersinc.com',
        password: 'wrongpassword',
      ),
    ).thenAnswer(
      (_) async => const Err(AuthFailure('E-mail ou senha inválidos.')),
    );

    await tester.pumpWidget(createSubject());

    await tester.enterText(
      find.byKey(const Key('login_email_field')),
      'prof@singersinc.com',
    );
    await tester.enterText(
      find.byKey(const Key('login_password_field')),
      'wrongpassword',
    );

    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('E-mail ou senha inválidos.'), findsOneWidget);
  });
}

