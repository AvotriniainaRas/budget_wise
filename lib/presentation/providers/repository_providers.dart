import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/data_repositories.dart';
import '../../domain/repositories/repositories.dart';
import 'infrastructure_providers.dart';

/// Fournit l'implémentation de [TransactionRepository].
final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => HiveTransactionRepository(
    ref.watch(hiveDatasourceProvider),
  ),
);

/// Fournit l'implémentation de [CategoryRepository].
final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => HiveCategoryRepository(
    ref.watch(hiveDatasourceProvider),
  ),
);

/// Fournit l'implémentation de [SavingsGoalRepository].
final savingsGoalRepositoryProvider = Provider<SavingsGoalRepository>(
  (ref) => HiveSavingsGoalRepository(
    ref.watch(hiveDatasourceProvider),
  ),
);