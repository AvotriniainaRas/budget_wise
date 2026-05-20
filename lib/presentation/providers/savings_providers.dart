import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/savings/savings_usecases.dart';
import 'repository_providers.dart';

// ── Use case providers ───────────────────────────────

final addSavingsGoalProvider = Provider(
  (ref) => AddSavingsGoal(ref.watch(savingsGoalRepositoryProvider)),
);

final deleteSavingsGoalProvider = Provider(
  (ref) => DeleteSavingsGoal(ref.watch(savingsGoalRepositoryProvider)),
);

final updateSavingsProgressProvider = Provider(
  (ref) => UpdateSavingsProgress(ref.watch(savingsGoalRepositoryProvider)),
);

// ── State providers ──────────────────────────────────

/// Tous les objectifs d'épargne.
final savingsGoalsProvider = FutureProvider<List<SavingsGoal>>((ref) async {
  final repo = ref.watch(savingsGoalRepositoryProvider);
  return repo.getAll();
});

/// Objectifs en cours uniquement.
final activeSavingsGoalsProvider =
    FutureProvider<List<SavingsGoal>>((ref) async {
  final repo = ref.watch(savingsGoalRepositoryProvider);
  return repo.getActive();
});