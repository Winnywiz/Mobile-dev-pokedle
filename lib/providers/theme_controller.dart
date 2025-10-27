import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_theme.dart';

enum AppThemeMode { system, light, dark }

class ThemeController extends ChangeNotifier {
  static const _kMode = 'theme_mode';
  static const _kLightSeed = 'light_seed';
  static const _kDarkSeed = 'dark_seed';

  AppThemeMode mode = AppThemeMode.system;
  Color lightSeed = const Color(0xFF64B5F6);
  Color darkSeed = const Color(0xFF0D47A1);

  ThemeData get theme {
    final brightness = switch (mode) {
      AppThemeMode.light => Brightness.light,
      AppThemeMode.dark => Brightness.dark,
      AppThemeMode.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness,
    };
    return brightness == Brightness.dark
        ? AppTheme.dark(seed: darkSeed)
        : AppTheme.light(seed: lightSeed);
  }

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    mode = AppThemeMode.values[sp.getInt(_kMode) ?? 0];
    lightSeed = Color(sp.getInt(_kLightSeed) ?? lightSeed.value);
    darkSeed = Color(sp.getInt(_kDarkSeed) ?? darkSeed.value);
    notifyListeners();
  }

  Future<void> setMode(AppThemeMode m) async {
    mode = m;
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kMode, m.index);
  }

  Future<void> setSeeds({Color? light, Color? dark}) async {
    if (light != null) lightSeed = light;
    if (dark != null) darkSeed = dark;
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kLightSeed, lightSeed.value);
    await sp.setInt(_kDarkSeed, darkSeed.value);
  }
}
