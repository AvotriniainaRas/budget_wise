import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

/// Crée un nouvel objectif d'épargne.
///
/// Règles métier :
/// - Le montant cible doit être supérieur à zéro.
/// - La date limite doit être dans le futur.
class AddSavingsGoal {
  const AddSavingsGoal(this._repository);

  final SavingsGoalRepository _repository;

  Future<void> call(SavingsGoal goal) async {
    assert(
      goal.targetAmount > 0,
      'Le montant cible doit être supérieur à zéro.',
    );
    assert(
      goal.deadline.isAfter(DateTime.now()),
      'La date limite doit être dans le futur.',
    );

    await _repository.save(goal);
  }
}