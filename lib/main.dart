import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

/// Point d'entrée de l'application BudgetWise.
///
/// Initialise Hive (base de données locale) avant
/// de lancer l'application Flutter.
Future<void> main() async {
  // Garantit que les bindings Flutter sont prêts
  // avant tout appel asynchrone.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive dans le répertoire de l'application.
  await Hive.initFlutter();

  // ProviderScope est le conteneur global de Riverpod.
  // Il doit envelopper toute l'application.
  runApp(
    const ProviderScope(
      child: BudgetWiseApp(),
    ),
  );
}