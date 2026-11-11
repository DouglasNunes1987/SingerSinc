/// Validadores puros de domínio (sem dependências de Flutter ou plugins).
class Validators {
  const Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Valida endereço de e-mail. Retorna mensagem de erro ou `null` se válido.
  static String? validateEmail(String? email) {
    final trimmed = email?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Informe o seu e-mail.';
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Informe um endereço de e-mail válido.';
    }
    return null;
  }

  /// Valida senha (mínimo de 6 caracteres exigido pelo Supabase Auth).
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Informe a sua senha.';
    }
    if (password.length < 6) {
      return 'A senha deve possuir pelo menos 6 caracteres.';
    }
    return null;
  }

  /// Valida título de música (entre 1 e 200 caracteres).
  static String? validateSongTitle(String? title) {
    final trimmed = title?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Informe o título da música.';
    }
    if (trimmed.length > 200) {
      return 'O título deve ter no máximo 200 caracteres.';
    }
    return null;
  }

  /// Valida se as coordenadas normalizadas do retângulo estão no intervalo [0..1].
  static bool isValidNormalizedRect({
    required double x,
    required double y,
    required double w,
    required double h,
  }) {
    const epsilon = 0.0001;
    if (x < 0.0 || x > 1.0) return false;
    if (y < 0.0 || y > 1.0) return false;
    if (w <= 0.0 || w > 1.0) return false;
    if (h <= 0.0 || h > 1.0) return false;
    if ((x + w) > 1.0 + epsilon) return false;
    if ((y + h) > 1.0 + epsilon) return false;
    return true;
  }
}

