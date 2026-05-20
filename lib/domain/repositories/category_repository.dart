import '../entities/entities.dart';

/// Contrat du repository des catégories.
abstract interface class CategoryRepository {
  /// Retourne toutes les catégories disponibles.
  Future<List<Category>> getAll();

  /// Retourne une catégorie par son identifiant.
  Future<Category?> getById(String id);

  /// Sauvegarde une nouvelle catégorie personnalisée.
  Future<void> save(Category category);

  /// Met à jour une catégorie existante.
  Future<void> update(Category category);

  /// Supprime une catégorie.
  /// Les transactions liées gardent leur [categoryId]
  /// mais la catégorie n'apparaîtra plus dans les listes.
  Future<void> delete(String id);

  /// Initialise les catégories par défaut si absentes.
  /// Appelé une seule fois au premier lancement.
  Future<void> seedDefaults();
}