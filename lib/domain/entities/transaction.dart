import 'package:equatable/equatable.dart';
import 'transaction_type.dart';

/// Représente une transaction financière (revenu ou dépense).
///
/// Entité immuable du domaine — aucune dépendance externe.
/// [Equatable] permet la comparaison par valeur : deux
/// transactions avec les mêmes champs sont considérées égales.
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note,
  });

  final String          id;
  final String          title;

  /// Toujours positif. Le [type] détermine si c'est un revenu ou dépense.
  final double          amount;
  final TransactionType type;
  final String          categoryId;
  final DateTime        date;
  final String?         note;

  /// Retourne true si c'est un revenu.
  bool get isIncome  => type == TransactionType.income;

  /// Retourne true si c'est une dépense.
  bool get isExpense => type == TransactionType.expense;

  /// Montant signé : positif pour revenu, négatif pour dépense.
  double get signedAmount => isIncome ? amount : -amount;

  /// Crée une copie avec certains champs modifiés.
  Transaction copyWith({
    String?          id,
    String?          title,
    double?          amount,
    TransactionType? type,
    String?          categoryId,
    DateTime?        date,
    String?          note,
  }) {
    return Transaction(
      id:         id         ?? this.id,
      title:      title      ?? this.title,
      amount:     amount     ?? this.amount,
      type:       type       ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      date:       date       ?? this.date,
      note:       note       ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, type, categoryId, date, note];
}