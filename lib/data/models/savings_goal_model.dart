import 'package:hive_flutter/hive_flutter.dart';

/// Modèle Hive pour un objectif d'épargne.
@HiveType(typeId: 2)
class SavingsGoalModel extends HiveObject {
  SavingsGoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    this.note,
  });

  @HiveField(0) String   id;
  @HiveField(1) String   title;
  @HiveField(2) double   targetAmount;
  @HiveField(3) double   currentAmount;
  @HiveField(4) DateTime deadline;
  @HiveField(5) String?  note;
}