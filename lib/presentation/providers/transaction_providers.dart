import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/transaction/transaction_usecases.dart';
import 'repository_providers.dart';

// ── Use case providers ───────────────────────────────

final addTransactionProvider = Provider(
  (ref) => AddTransaction(ref.watch(transactionRepositoryProvider)),
);

final updateTransactionProvider = Provider(
  (ref) => UpdateTransaction(ref.watch(transactionRepositoryProvider)),
);

final deleteTransactionProvider = Provider(
  (ref) => DeleteTransaction(ref.watch(transactionRepositoryProvider)),
);

final getMonthlySummaryProvider = Provider(
  (ref) => GetMonthlySummary(ref.watch(transactionRepositoryProvider)),
);

final getTransactionsByMonthProvider = Provider(
  (ref) => GetTransactionsByMonth(ref.watch(transactionRepositoryProvider)),
);

// ── State providers ──────────────────────────────────

/// Date du mois actuellement affiché dans le dashboard.
final selectedMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

/// Liste des transactions du mois sélectionné.
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final date     = ref.watch(selectedMonthProvider);
  final usecase  = ref.watch(getTransactionsByMonthProvider);
  return usecase(date.year, date.month);
});

/// Résumé financier du mois sélectionné.
final monthlySummaryProvider = FutureProvider((ref) async {
  final date    = ref.watch(selectedMonthProvider);
  final usecase = ref.watch(getMonthlySummaryProvider);
  return usecase(date.year, date.month);
});