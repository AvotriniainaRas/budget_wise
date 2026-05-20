// import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import '../models/transaction_model.dart';

/// Convertit [TransactionModel] ↔ [Transaction].
abstract final class TransactionMapper {
  /// Modèle Hive → Entité du domaine.
  static Transaction toEntity(TransactionModel model) {
    return Transaction(
      id:         model.id,
      title:      model.title,
      amount:     model.amount,
      type:       TransactionType.values[model.typeIndex],
      categoryId: model.categoryId,
      date:       model.date,
      note:       model.note,
    );
  }

  /// Entité du domaine → Modèle Hive.
  static TransactionModel toModel(Transaction entity) {
    return TransactionModel(
      id:         entity.id,
      title:      entity.title,
      amount:     entity.amount,
      typeIndex:  entity.type.index,
      categoryId: entity.categoryId,
      date:       entity.date,
      note:       entity.note,
    );
  }
}