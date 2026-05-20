import '../../repositories/repositories.dart';

/// Ajoute un montant à la progression d'un objectif d'épargne.
///
/// Règle métier : le montant ajouté doit être positif.
class UpdateSavingsProgress {
  const UpdateSavingsProgress(this._repository);

  final SavingsGoalRepository _repository;

  Future<void> call(String goalId, double amount) async {
    assert(amount > 0, 'Le montant ajouté doit être positif.');
    await _repository.addAmount(goalId, amount);
  }
}