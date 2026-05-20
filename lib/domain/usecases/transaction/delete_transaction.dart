import '../../repositories/repositories.dart';

/// Supprime une transaction par son identifiant.
class DeleteTransaction {
  const DeleteTransaction(this._repository);

  final TransactionRepository _repository;

  Future<void> call(String id) async {
    await _repository.delete(id);
  }
}