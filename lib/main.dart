import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'data/datasources/local/hive_datasource.dart';
import 'data/models/models.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Désactive le téléchargement des polices en runtime.
  // Évite les crashes sur Android si pas de connexion internet.
  // Les polices système sont utilisées comme fallback.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Initialise les données de localisation française.
  await initializeDateFormatting('fr_FR', null);

  // Sur Android, Hive.initFlutter() sans argument trouve
  // automatiquement le bon dossier de l'application.
  // Sur Linux : getApplicationSupportDirectory() est utilisé
  // pour stocker dans ~/.local/share/budget_wise/
  final appDir = await getApplicationSupportDirectory();
  await Hive.initFlutter(appDir.path);

  // Enregistrement des TypeAdapters — doit être fait
  // AVANT d'ouvrir les boîtes Hive.
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(SavingsGoalAdapter());

  // Ouverture des boîtes — une boîte = une "table" de données.
  await Hive.openBox<TransactionModel>(HiveBoxNames.transactions);
  await Hive.openBox<CategoryModel>(HiveBoxNames.categories);
  await Hive.openBox<SavingsGoalModel>(HiveBoxNames.savingsGoals);

  // Boîte générique pour les préférences utilisateur
  // (thème, onboarding...) — sans TypeAdapter car types primitifs.
  await Hive.openBox('settings');

  runApp(
    const ProviderScope(
      child: BudgetWiseApp(),
    ),
  );
}