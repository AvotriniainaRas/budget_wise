import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/local/hive_datasource.dart';
import '../mappers/mappers.dart';

/// Implémentation Hive de [TransactionRepository].
///
/// Cette classe est la seule à connaître [HiveDatasource].
/// Le domaine ne voit que l'interface [TransactionRepository].
class HiveTransactionRepository implements TransactionRepository {
  HiveTransactionRepository(this._datasource);

  final HiveDatasource _datasource;

  @override
  Future<List<Transaction>> getAll() async {
    final models = _datasource.getAllTransactions();
    final entities = models.map(TransactionMapper.toEntity).toList();

    // Tri par date décroissante (plus récent en premier).
    entities.sort((a, b) => b.date.compareTo(a.date));
    return entities;
  }

  @override
  Future<List<Transaction>> getByMonth(int year, int month) async {
    final all = await getAll();
    return all
        .where(
          (t) => t.date.year == year && t.date.month == month,
        )
        .toList();
  }

  @override
  Future<List<Transaction>> getByCategory(String categoryId) async {
    final all = await getAll();
    return all.where((t) => t.categoryId == categoryId).toList();
  }

  @override
  Future<Transaction?> getById(String id) async {
    final model = _datasource.getTransactionById(id);
    return model != null ? TransactionMapper.toEntity(model) : null;
  }

  @override
  Future<void> save(Transaction transaction) async {
    final model = TransactionMapper.toModel(transaction);
    await _datasource.saveTransaction(model);
  }

  @override
  Future<void> update(Transaction transaction) async {
    final model = TransactionMapper.toModel(transaction);
    await _datasource.saveTransaction(model);
  }

  @override
  Future<void> delete(String id) async {
    await _datasource.deleteTransaction(id);
  }

  // Après
  @override
  Future<double> getTotalIncome(int year, int month) async {
    final transactions = await getByMonth(year, month);
    return transactions
        .where((t) => t.isIncome)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  Future<double> getTotalExpense(int year, int month) async {
    final transactions = await getByMonth(year, month);
    return transactions
        .where((t) => t.isExpense)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }
}
