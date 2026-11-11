import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singersinc/core/config/env_config.dart';
import 'package:singersinc/core/router/app_router.dart';
import 'package:singersinc/core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      publishableKey: EnvConfig.supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Supabase não conectado ou operando em modo offline: $e');
  }

  runApp(
    const ProviderScope(
      child: SingerSincApp(),
    ),
  );
}

class SingerSincApp extends ConsumerWidget {
  const SingerSincApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'SingerSinc',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
