import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/local/hive_datasource.dart';
import '../mappers/mappers.dart';

/// Implémentation Hive de [SavingsGoalRepository].
class HiveSavingsGoalRepository implements SavingsGoalRepository {
  HiveSavingsGoalRepository(this._datasource);

  final HiveDatasource _datasource;

  @override
  Future<List<SavingsGoal>> getAll() async {
    final models = _datasource.getAllSavingsGoals();
    return models.map(SavingsGoalMapper.toEntity).toList();
  }

  @override
  Future<List<SavingsGoal>> getActive() async {
    final all = await getAll();
    return all.where((g) => !g.isCompleted).toList();
  }

  @override
  Future<List<SavingsGoal>> getCompleted() async {
    final all = await getAll();
    return all.where((g) => g.isCompleted).toList();
  }

  @override
  Future<SavingsGoal?> getById(String id) async {
    final model = _datasource.getSavingsGoalById(id);
    return model != null ? SavingsGoalMapper.toEntity(model) : null;
  }

  @override
  Future<void> save(SavingsGoal goal) async {
    final model = SavingsGoalMapper.toModel(goal);
    await _datasource.saveSavingsGoal(model);
  }

  @override
  Future<void> update(SavingsGoal goal) async {
    final model = SavingsGoalMapper.toModel(goal);
    await _datasource.saveSavingsGoal(model);
  }

  @override
  Future<void> addAmount(String id, double amount) async {
    final goal = await getById(id);
    if (goal == null) return;

    final updated = goal.copyWith(
      currentAmount: goal.currentAmount + amount,
    );
    await update(updated);
  }

  @override
  Future<void> delete(String id) async {
    await _datasource.deleteSavingsGoal(id);
  }
}