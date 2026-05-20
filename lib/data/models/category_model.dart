import 'package:hive_flutter/hive_flutter.dart';

/// Modèle Hive pour une catégorie.
@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
    required this.isDefault,
  });

  @HiveField(0) String id;
  @HiveField(1) String name;

  /// Code Unicode de l'icône Material (IconData.codePoint).
  @HiveField(2) int    iconCode;

  /// Valeur ARGB de la couleur (Color.value).
  @HiveField(3) int    colorValue;
  @HiveField(4) bool   isDefault;
}