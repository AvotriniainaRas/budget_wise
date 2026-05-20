import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/entities.dart';
import 'repository_providers.dart';

/// Liste de toutes les catégories disponibles.
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.watch(categoryRepositoryProvider);

  // Initialise les catégories par défaut si nécessaire.
  await repo.seedDefaults();
  return repo.getAll();
});

/// Catégories de type revenu (les 3 premières par défaut).
final incomeCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final categories = await ref.watch(categoriesProvider.future);
  return categories
      .where((c) => _isIncomeCategory(c.name))
      .toList();
});

/// Catégories de type dépense.
final expenseCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final categories = await ref.watch(categoriesProvider.future);
  return categories
      .where((c) => !_isIncomeCategory(c.name))
      .toList();
});

/// Détermine si une catégorie est un revenu par son nom.
bool _isIncomeCategory(String name) =>
    ['Salaire', 'Freelance', 'Autres revenus'].contains(name);