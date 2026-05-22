import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import 'repository_providers.dart';

/// Données des 6 derniers mois pour les graphiques.
final monthlyStatsProvider = FutureProvider<List<MonthlyData>>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final now  = DateTime.now();
  final data = <MonthlyData>[];

  for (int i = 5; i >= 0; i--) {
    final date   = DateTime(now.year, now.month - i);
    final income  = await repo.getTotalIncome(date.year, date.month);
    final expense = await repo.getTotalExpense(date.year, date.month);

    data.add(MonthlyData(
      date:    date,
      income:  income,
      expense: expense,
    ));
  }

  return data;
});

/// Répartition des dépenses par catégorie pour le mois courant.
final expensesByCategoryProvider =
    FutureProvider<List<CategoryData>>((ref) async {
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final categoryRepo    = ref.watch(categoryRepositoryProvider);
  final now             = DateTime.now();

  final transactions = await transactionRepo.getByMonth(now.year, now.month);
  final categories   = await categoryRepo.getAll();

  final expenses = transactions.where((t) => t.isExpense).toList();
  final totalExpense = expenses.fold<double>(
    0, (sum, t) => sum + t.amount,
  );

  if (totalExpense == 0) return [];

  // Groupe par catégorie
  final Map<String, double> grouped = {};
  for (final t in expenses) {
    grouped[t.categoryId] = (grouped[t.categoryId] ?? 0) + t.amount;
  }

  return grouped.entries.map((entry) {
    final category = categories.firstWhere(
      (c) => c.id == entry.key,
      orElse: () => const Category(
        id:    '',
        name:  'Autre',
        icon:  IconData(0),
        color: Color(0xFF78909C),
      ),
    );

    return CategoryData(
      category:   category,
      amount:     entry.value,
      percentage: entry.value / totalExpense * 100,
    );
  }).toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));
});

/// Données mensuelles pour un mois.
class MonthlyData {
  const MonthlyData({
    required this.date,
    required this.income,
    required this.expense,
  });

  final DateTime date;
  final double   income;
  final double   expense;

  double get balance => income - expense;
}

/// Données d'une catégorie pour le camembert.
class CategoryData {
  const CategoryData({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  final Category category;
  final double   amount;
  final double   percentage;
}