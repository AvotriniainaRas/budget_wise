import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service de persistance des préférences utilisateur.
///
/// Utilise une boîte Hive générique (sans TypeAdapter)
/// pour stocker des valeurs primitives simples.
class PreferencesService {
  PreferencesService._();

  static final PreferencesService instance = PreferencesService._();

  // Clés des préférences — centralisées pour éviter les fautes de frappe
  static const String _themeKey = 'theme_mode';

  Box get _box => Hive.box('settings');

  // ── Thème ────────────────────────────────────────────

  /// Sauvegarde le mode de thème choisi par l'utilisateur.
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _box.put(_themeKey, mode.index);
    // ThemeMode.system  = 0
    // ThemeMode.light   = 1
    // ThemeMode.dark    = 2
  }

  /// Charge le mode de thème sauvegardé.
  /// Retourne ThemeMode.system si aucune préférence enregistrée.
  ThemeMode loadThemeMode() {
    final index = _box.get(_themeKey, defaultValue: 0) as int;
    return ThemeMode.values[index];
  }

  static const String _onboardingKey = 'onboarding_done';

  /// Retourne true si l'onboarding a déjà été vu.
  bool isOnboardingDone() {
    return _box.get(_onboardingKey, defaultValue: false) as bool;
  }

  /// Marque l'onboarding comme terminé.
  Future<void> setOnboardingDone([bool done = true]) async {
    await _box.put(_onboardingKey, done);
  }
}
