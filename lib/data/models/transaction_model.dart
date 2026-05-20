import 'package:hive_flutter/hive_flutter.dart';

/// Modèle Hive pour une transaction.
///
/// [typeId] doit être unique dans toute l'application.
/// Convention : 0 = Transaction, 1 = Category, 2 = SavingsGoal.
@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.typeIndex,
    required this.categoryId,
    required this.date,
    this.note,
  });

  @HiveField(0) String  id;
  @HiveField(1) String  title;
  @HiveField(2) double  amount;

  /// Index de l'enum [TransactionType] : 0 = income, 1 = expense.
  @HiveField(3) int     typeIndex;
  @HiveField(4) String  categoryId;
  @HiveField(5) DateTime date;
  @HiveField(6) String? note;
}