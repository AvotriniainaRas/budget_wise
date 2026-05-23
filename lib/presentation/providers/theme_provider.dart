import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/preferences_service.dart';

/// Notifier qui persiste le thème dans Hive.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Charge la préférence sauvegardée au démarrage
    return PreferencesService.instance.loadThemeMode();
  }

  /// Change le thème et le sauvegarde dans Hive.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await PreferencesService.instance.saveThemeMode(mode);
  }
}

/// Provider du thème — persiste dans Hive.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
