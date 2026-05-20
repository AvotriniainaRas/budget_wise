import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/datasources/local/hive_datasource.dart';
import 'data/models/models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive dans le répertoire de l'application.
  await Hive.initFlutter();

  // Enregistrement des TypeAdapters.
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(SavingsGoalAdapter());

  // Ouverture des boîtes avant le lancement de l'app.
  await Hive.openBox<TransactionModel>(HiveBoxNames.transactions);
  await Hive.openBox<CategoryModel>(HiveBoxNames.categories);
  await Hive.openBox<SavingsGoalModel>(HiveBoxNames.savingsGoals);

  runApp(
    const ProviderScope(
      child: BudgetWiseApp(),
    ),
  );
}