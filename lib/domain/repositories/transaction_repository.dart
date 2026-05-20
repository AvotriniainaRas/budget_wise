import '../entities/entities.dart';

/// Contrat du repository des transactions.
///
/// La couche domain définit CE QUE fait le repository.
/// La couche data l'implémente avec Hive.
///
/// Toutes les méthodes retournent un [Future] car
/// les opérations de stockage sont asynchrones.
abstract interface class TransactionRepository {
  /// Retourne toutes les transactions, triées par date décroissante.
  Future<List<Transaction>> getAll();

  /// Retourne les transactions d'un mois donné.
  Future<List<Transaction>> getByMonth(int year, int month);

  /// Retourne les transactions d'une catégorie donnée.
  Future<List<Transaction>> getByCategory(String categoryId);

  /// Retourne une transaction par son identifiant.
  /// Retourne [null] si introuvable.
  Future<Transaction?> getById(String id);

  /// Sauvegarde une nouvelle transaction.
  Future<void> save(Transaction transaction);

  /// Met à jour une transaction existante.
  Future<void> update(Transaction transaction);

  /// Supprime une transaction par son identifiant.
  Future<void> delete(String id);

  /// Retourne le total des revenus d'un mois donné.
  Future<double> getTotalIncome(int year, int month);

  /// Retourne le total des dépenses d'un mois donné.
  Future<double> getTotalExpense(int year, int month);
}