import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'data/datasources/local/hive_datasource.dart';
import 'data/models/models.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise les données de localisation française.
  await initializeDateFormatting('fr_FR', null);

  // getApplicationSupportDirectory() retourne un dossier
  // caché dédié à l'app — propre sur Linux, macOS et Windows.
  // Sur Linux : ~/.local/share/budget_wise/
  final appDir = await getApplicationSupportDirectory();
  await Hive.initFlutter(appDir.path);

  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(SavingsGoalAdapter());

  await Hive.openBox<TransactionModel>(HiveBoxNames.transactions);
  await Hive.openBox<CategoryModel>(HiveBoxNames.categories);
  await Hive.openBox<SavingsGoalModel>(HiveBoxNames.savingsGoals);

  runApp(
    const ProviderScope(
      child: BudgetWiseApp(),
    ),
  );
}