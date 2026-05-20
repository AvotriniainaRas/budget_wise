import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Représente une catégorie de transaction.
///
/// Exemple : "Alimentation", "Salaire", "Loyer".
/// Chaque catégorie a une couleur et une icône pour l'UI.
class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isDefault = false,
  });

  final String  id;
  final String  name;

  /// Code du point Unicode de l'icône Material.
  final IconData icon;

  /// Couleur d'affichage dans l'interface.
  final Color   color;

  /// True pour les catégories fournies par défaut à l'installation.
  final bool    isDefault;

  Category copyWith({
    String?   id,
    String?   name,
    IconData? icon,
    Color?    color,
    bool?     isDefault,
  }) {
    return Category(
      id:        id        ?? this.id,
      name:      name      ?? this.name,
      icon:      icon      ?? this.icon,
      color:     color     ?? this.color,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, color, isDefault];
}