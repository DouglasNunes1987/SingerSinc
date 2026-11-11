import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singersinc/core/config/env_config.dart';
import 'package:singersinc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:singersinc/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:singersinc/features/auth/presentation/screens/login_screen.dart';
import 'package:singersinc/features/auth/presentation/screens/register_screen.dart';
import 'package:singersinc/features/songs/presentation/screens/songs_library_screen.dart';

/// Notifier auxiliar que notifica o [GoRouter] sempre que o estado de
/// autenticação (`isAuthenticated`) mudar no Riverpod.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen<bool>(
      authControllerProvider.select((state) => state.isAuthenticated),
      (_, __) => notifyListeners(),
    );
  }
}

/// Provider global de roteamento com proteção de rotas (Auth Guard).
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/songs',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isPublicAuthRoute = location == '/login' ||
          location == '/register' ||
          location == '/forgot-password';

      if (EnvConfig.bypassAuth) {
        if (isPublicAuthRoute) {
          return '/songs';
        }
        return null;
      }

      final isAuthenticated =
          ref.read(authControllerProvider).isAuthenticated;

      if (!isAuthenticated && !isPublicAuthRoute) {
        return '/login';
      }

      if (isAuthenticated && isPublicAuthRoute) {
        return '/songs';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/songs',
        builder: (context, state) => const SongsLibraryScreen(),
      ),
    ],
  );
});

