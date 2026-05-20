import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

/// Met à jour une transaction existante.
class UpdateTransaction {
  const UpdateTransaction(this._repository);

  final TransactionRepository _repository;

  Future<void> call(Transaction transaction) async {
    assert(
      transaction.amount > 0,
      'Le montant doit être strictement positif.',
    );
    await _repository.update(transaction);
  }
}