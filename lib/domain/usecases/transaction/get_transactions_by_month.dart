import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

/// Retourne la liste des transactions d'un mois donné.
class GetTransactionsByMonth {
  const GetTransactionsByMonth(this._repository);

  final TransactionRepository _repository;

  Future<List<Transaction>> call(int year, int month) async {
    return _repository.getByMonth(year, month);
  }
}