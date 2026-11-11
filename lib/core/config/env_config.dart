/// Configurações de ambiente da aplicação carregadas via `--dart-define`
/// ou valores configurados do projeto Supabase Cloud do SingerSinc.
///
/// Nunca armazene a chave `service_role` do Supabase no aplicativo.
class EnvConfig {
  const EnvConfig._();

  static const String _rawSupabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xptkzbhcbcqlugdpwosj.supabase.co',
  );

  /// Retorna a URL base do projeto Supabase (removendo sufixos como `/rest/v1/` caso informados).
  static String get supabaseUrl {
    var url = _rawSupabaseUrl.trim();
    if (url.endsWith('/rest/v1/')) {
      url = url.substring(0, url.length - '/rest/v1/'.length);
    } else if (url.endsWith('/rest/v1')) {
      url = url.substring(0, url.length - '/rest/v1'.length);
    } else if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_X49C3UwF6pIiXaTAlpICOw_G7xsBlaO',
  );

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty &&
      !supabaseUrl.contains('placeholder-project.supabase.co') &&
      supabaseAnonKey.isNotEmpty &&
      supabaseAnonKey != 'placeholder-anon-key';

  /// Se verdadeiro, oculta a tela de autenticação e permite testar o app
  /// diretamente no modo local/offline com um usuário simulado.
  static const bool bypassAuth = bool.fromEnvironment(
    'BYPASS_AUTH',
    defaultValue: true,
  );

  static const String devUserId = 'local-dev-user';
  static const String devUserEmail = 'professor@singersinc.local';
}
