import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/local/hive_datasource.dart';
import '../mappers/mappers.dart';

/// Implémentation Hive de [CategoryRepository].
class HiveCategoryRepository implements CategoryRepository {
  HiveCategoryRepository(this._datasource);

  final HiveDatasource _datasource;
  final _uuid = const Uuid();

  @override
  Future<List<Category>> getAll() async {
    final models = _datasource.getAllCategories();
    return models.map(CategoryMapper.toEntity).toList();
  }

  @override
  Future<Category?> getById(String id) async {
    final model = _datasource.getCategoryById(id);
    return model != null ? CategoryMapper.toEntity(model) : null;
  }

  @override
  Future<void> save(Category category) async {
    final model = CategoryMapper.toModel(category);
    await _datasource.saveCategory(model);
  }

  @override
  Future<void> update(Category category) async {
    final model = CategoryMapper.toModel(category);
    await _datasource.saveCategory(model);
  }

  @override
  Future<void> delete(String id) async {
    await _datasource.deleteCategory(id);
  }

  @override
  Future<void> seedDefaults() async {
    // Ne rien faire si les catégories existent déjà.
    if (_datasource.hasCategories) return;

    final defaults = _defaultCategories();
    for (final category in defaults) {
      await save(category);
    }
  }

  /// Catégories fournies par défaut à l'installation.
  List<Category> _defaultCategories() => [
    // ── Revenus ──────────────────────────────────────
    Category(
      id:        _uuid.v4(),
      name:      'Salaire',
      icon:      Icons.work_rounded,
      color:     const Color(0xFF66BB6A),
      isDefault: true,
    ),
    Category(
      id:        _uuid.v4(),
      name:      'Freelance',
      icon:      Icons.laptop_rounded,
      color:     const Color(0xFF42A5F5),
      isDefault: true,
    ),
    Category(
      id:        _uuid.v4(),
      name:      'Autres revenus',
      icon:      Icons.add_circle_rounded,
      color:     const Color(0xFF26A69A),
      isDefault: true,
    ),

    // ── Dépenses ─────────────────────────────────────
    Category(
      id:        _uuid.v4(),
      name:      'Alimentation',
      icon:      Icons.restaurant_rounded,
      color:     const Color(0xFFEF5350),
      isDefault: true,
    ),
    Category(
      id:        _uuid.v4(),
      name:      'Transport',
      icon:      Icons.directions_car_rounded,
      color:     const Color(0xFFFF7043),
      isDefault: true,
    ),
    Category(
      id:        _uuid.v4(),
      name:      'Logement',
      icon:      Icons.home_rounded,
      color:     const Color(0xFFAB47BC),
      isDefault: true,
    ),
    Category(
      id:        _uuid.v4(),
      name:      'Santé',
      icon:      Icons.local_hospital_rounded,
      color:     const Color(0xFFEC407A),
      isDefault: true,
    ),
    Category(
      id:        _uuid.v4(),
      name:      'Loisirs',
      icon:      Icons.sports_esports_rounded,
      color:     const Color(0xFFFFB300),
      isDefault: true,
    ),
    Category(
      id:        _uuid.v4(),
      name:      'Éducation',
      icon:      Icons.school_rounded,
      color:     const Color(0xFF5C6BC0),
      isDefault: true,
    ),
    Category(
      id:        _uuid.v4(),
      name:      'Autres dépenses',
      icon:      Icons.more_horiz_rounded,
      color:     const Color(0xFF78909C),
      isDefault: true,
    ),
  ];
}