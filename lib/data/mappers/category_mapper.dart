import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import '../models/category_model.dart';

/// Convertit [CategoryModel] ↔ [Category].
abstract final class CategoryMapper {
  static Category toEntity(CategoryModel model) {
    return Category(
      id:        model.id,
      name:      model.name,
      icon:      IconData(model.iconCode, fontFamily: 'MaterialIcons'),
      color:     Color(model.colorValue),
      isDefault: model.isDefault,
    );
  }

  static CategoryModel toModel(Category entity) {
    return CategoryModel(
      id:         entity.id,
      name:       entity.name,
      iconCode:   entity.icon.codePoint,
      colorValue: entity.color.toARGB32(),
      isDefault:  entity.isDefault,
    );
  }
}