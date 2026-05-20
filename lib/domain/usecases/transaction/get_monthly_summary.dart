import '../../repositories/repositories.dart';

/// Résultat du résumé mensuel.
///
/// Classe immuable transportant les totaux calculés.
class MonthlySummary {
  const MonthlySummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.year,
    required this.month,
  });

  final double totalIncome;
  final double totalExpense;
  final int    year;
  final int    month;

  /// Solde net du mois (revenus - dépenses).
  double get balance => totalIncome - totalExpense;

  /// True si le mois est excédentaire.
  bool get isPositive => balance >= 0;

  /// Taux d'épargne : pourcentage des revenus non dépensés.
  /// Retourne 0 si aucun revenu.
  double get savingsRate =>
      totalIncome == 0 ? 0 : (balance / totalIncome * 100).clamp(0, 100);
}

/// Calcule le résumé financier d'un mois donné.
class GetMonthlySummary {
  const GetMonthlySummary(this._repository);

  final TransactionRepository _repository;

  Future<MonthlySummary> call(int year, int month) async {
    final income  = await _repository.getTotalIncome(year, month);
    final expense = await _repository.getTotalExpense(year, month);

    return MonthlySummary(
      totalIncome:  income,
      totalExpense: expense,
      year:         year,
      month:        month,
    );
  }
}