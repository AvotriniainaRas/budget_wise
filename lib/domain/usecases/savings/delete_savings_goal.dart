import '../../repositories/repositories.dart';

/// Supprime un objectif d'épargne.
class DeleteSavingsGoal {
  const DeleteSavingsGoal(this._repository);

  final SavingsGoalRepository _repository;

  Future<void> call(String id) async {
    await _repository.delete(id);
  }
}