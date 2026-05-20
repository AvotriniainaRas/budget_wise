import 'package:equatable/equatable.dart';

/// Représente un objectif d'épargne.
///
/// Exemple : "Achat téléphone" avec cible 500 000 Ar.
class SavingsGoal extends Equatable {
  const SavingsGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    this.note,
  });

  final String   id;
  final String   title;
  final double   targetAmount;
  final double   currentAmount;
  final DateTime deadline;
  final String?  note;

  /// Progression entre 0.0 et 1.0.
  double get progress =>
      (currentAmount / targetAmount).clamp(0.0, 1.0);

  /// Pourcentage lisible (ex: 67.5).
  double get progressPercent => progress * 100;

  /// Montant restant à épargner.
  double get remainingAmount =>
      (targetAmount - currentAmount).clamp(0.0, double.infinity);

  /// True si l'objectif est atteint.
  bool get isCompleted => currentAmount >= targetAmount;

  /// True si la date limite est dépassée sans atteindre l'objectif.
  bool get isOverdue =>
      !isCompleted && DateTime.now().isAfter(deadline);

  SavingsGoal copyWith({
    String?   id,
    String?   title,
    double?   targetAmount,
    double?   currentAmount,
    DateTime? deadline,
    String?   note,
  }) {
    return SavingsGoal(
      id:            id            ?? this.id,
      title:         title         ?? this.title,
      targetAmount:  targetAmount  ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline:      deadline      ?? this.deadline,
      note:          note          ?? this.note,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, targetAmount, currentAmount, deadline, note];
}