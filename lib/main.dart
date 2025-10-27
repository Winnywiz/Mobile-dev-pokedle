import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'providers/game_provider.dart';
import 'providers/theme_controller.dart';
import 'services/pokemon_repository.dart';
import 'services/storage_service.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PokedleApp());
}

class PokedleApp extends StatelessWidget {
  const PokedleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameProvider(
            repo: PokemonRepository(),
            storage: StorageService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ThemeController()..load()),
      ],
      child: Consumer<ThemeController>(
        builder: (_, tc, __) => MaterialApp(
          title: 'Pokedle',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(), // system light fallback
          darkTheme: AppTheme.dark(), // system dark fallback
          themeMode: switch (tc.mode) {
            AppThemeMode.light => ThemeMode.light,
            AppThemeMode.dark => ThemeMode.dark,
            AppThemeMode.system => ThemeMode.system,
          },
          home: const HomePage(),
        ),
      ),
    );
  }
}
