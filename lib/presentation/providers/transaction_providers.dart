import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/transaction/transaction_usecases.dart';
import 'repository_providers.dart';

// ── Use case providers ───────────────────────────────────

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

// ── State providers ──────────────────────────────────────

/// Date du mois actuellement affiché.
final selectedMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

/// Filtre actif sur le type de transaction.
final transactionTypeFilterProvider = StateProvider<TransactionType?>(
  (ref) => null, // null = tous
);

/// Filtre actif sur la catégorie.
final categoryFilterProvider = StateProvider<String?>(
  (ref) => null, // null = toutes
);

/// Texte de recherche.
final searchQueryProvider = StateProvider<String>(
  (ref) => '',
);

/// Liste brute des transactions du mois sélectionné.
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final date    = ref.watch(selectedMonthProvider);
  final usecase = ref.watch(getTransactionsByMonthProvider);
  return usecase(date.year, date.month);
});

/// Liste filtrée selon type, catégorie et recherche.
final filteredTransactionsProvider = Provider<AsyncValue<List<Transaction>>>(
  (ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final typeFilter        = ref.watch(transactionTypeFilterProvider);
    final categoryFilter    = ref.watch(categoryFilterProvider);
    final searchQuery       = ref.watch(searchQueryProvider).toLowerCase();

    return transactionsAsync.whenData((transactions) {
      var filtered = transactions;

      // Filtre par type
      if (typeFilter != null) {
        filtered = filtered
            .where((t) => t.type == typeFilter)
            .toList();
      }

      // Filtre par catégorie
      if (categoryFilter != null) {
        filtered = filtered
            .where((t) => t.categoryId == categoryFilter)
            .toList();
      }

      // Filtre par recherche
      if (searchQuery.isNotEmpty) {
        filtered = filtered
            .where((t) => t.title.toLowerCase().contains(searchQuery))
            .toList();
      }

      return filtered;
    });
  },
);

/// Résumé financier du mois sélectionné.
final monthlySummaryProvider = FutureProvider((ref) async {
  final date    = ref.watch(selectedMonthProvider);
  final usecase = ref.watch(getMonthlySummaryProvider);
  return usecase(date.year, date.month);
});

/// Solde total de toutes les transactions (tous les mois confondus).
final totalBalanceProvider = FutureProvider<double>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final all  = await repo.getAll();
  return all.fold<double>(0.0, (sum, t) => sum + t.signedAmount);
});