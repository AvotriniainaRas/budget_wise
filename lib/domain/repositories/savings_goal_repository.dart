import '../entities/entities.dart';

/// Contrat du repository des objectifs d'épargne.
abstract interface class SavingsGoalRepository {
  /// Retourne tous les objectifs d'épargne.
  Future<List<SavingsGoal>> getAll();

  /// Retourne les objectifs en cours (non complétés).
  Future<List<SavingsGoal>> getActive();

  /// Retourne les objectifs complétés.
  Future<List<SavingsGoal>> getCompleted();

  /// Retourne un objectif par son identifiant.
  Future<SavingsGoal?> getById(String id);

  /// Sauvegarde un nouvel objectif.
  Future<void> save(SavingsGoal goal);

  /// Met à jour un objectif existant.
  Future<void> update(SavingsGoal goal);

  /// Ajoute un montant à l'épargne courante d'un objectif.
  Future<void> addAmount(String id, double amount);

  /// Supprime un objectif.
  Future<void> delete(String id);
}