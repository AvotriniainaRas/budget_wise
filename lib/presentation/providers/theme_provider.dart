import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Gère le mode clair / sombre de l'application.
///
/// Persiste le choix en mémoire pour cette session.
/// On ajoutera la persistance Hive plus tard.
final themeModeProvider = StateProvider<ThemeMode>(
  (ref) => ThemeMode.system,
);