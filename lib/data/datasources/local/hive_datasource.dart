import 'package:hive_flutter/hive_flutter.dart';
import '../../models/models.dart';

/// Noms des boîtes Hive — centralisés pour éviter les fautes de frappe.
abstract final class HiveBoxNames {
  static const String transactions = 'transactions';
  static const String categories   = 'categories';
  static const String savingsGoals = 'savings_goals';
}

/// Datasource locale — accès direct aux boîtes Hive.
///
/// Chaque méthode travaille avec les modèles Hive uniquement.
/// La conversion vers les entités du domaine est faite
/// dans les repositories via les mappers.
class HiveDatasource {
  HiveDatasource._();

  static final HiveDatasource instance = HiveDatasource._();

  // ── Boîtes Hive ─────────────────────────────────────
  Box<TransactionModel>  get _transactions =>
      Hive.box<TransactionModel>(HiveBoxNames.transactions);

  Box<CategoryModel>     get _categories =>
      Hive.box<CategoryModel>(HiveBoxNames.categories);

  Box<SavingsGoalModel>  get _savingsGoals =>
      Hive.box<SavingsGoalModel>(HiveBoxNames.savingsGoals);

  // ── Transactions ─────────────────────────────────────

  List<TransactionModel> getAllTransactions() =>
      _transactions.values.toList();

  TransactionModel? getTransactionById(String id) =>
      _transactions.get(id);

  Future<void> saveTransaction(TransactionModel model) =>
      _transactions.put(model.id, model);

  Future<void> deleteTransaction(String id) =>
      _transactions.delete(id);

  // ── Categories ───────────────────────────────────────

  List<CategoryModel> getAllCategories() =>
      _categories.values.toList();

  CategoryModel? getCategoryById(String id) =>
      _categories.get(id);

  Future<void> saveCategory(CategoryModel model) =>
      _categories.put(model.id, model);

  Future<void> deleteCategory(String id) =>
      _categories.delete(id);

  bool get hasCategories => _categories.isNotEmpty;

  // ── Savings Goals ────────────────────────────────────

  List<SavingsGoalModel> getAllSavingsGoals() =>
      _savingsGoals.values.toList();

  SavingsGoalModel? getSavingsGoalById(String id) =>
      _savingsGoals.get(id);

  Future<void> saveSavingsGoal(SavingsGoalModel model) =>
      _savingsGoals.put(model.id, model);

  Future<void> deleteSavingsGoal(String id) =>
      _savingsGoals.delete(id);
}