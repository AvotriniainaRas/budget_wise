import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

/// Ajoute une nouvelle transaction.
///
/// Règles métier appliquées :
/// - Le montant doit être strictement positif.
/// - Le titre ne peut pas être vide.
class AddTransaction {
  const AddTransaction(this._repository);

  final TransactionRepository _repository;

  Future<void> call(Transaction transaction) async {
    assert(
      transaction.amount > 0,
      'Le montant doit être strictement positif.',
    );
    assert(
      transaction.title.trim().isNotEmpty,
      'Le titre ne peut pas être vide.',
    );

    await _repository.save(transaction);
  }
}