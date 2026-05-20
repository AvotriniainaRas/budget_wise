import '../../domain/entities/entities.dart';
import '../models/savings_goal_model.dart';

/// Convertit [SavingsGoalModel] ↔ [SavingsGoal].
abstract final class SavingsGoalMapper {
  static SavingsGoal toEntity(SavingsGoalModel model) {
    return SavingsGoal(
      id:            model.id,
      title:         model.title,
      targetAmount:  model.targetAmount,
      currentAmount: model.currentAmount,
      deadline:      model.deadline,
      note:          model.note,
    );
  }

  static SavingsGoalModel toModel(SavingsGoal entity) {
    return SavingsGoalModel(
      id:            entity.id,
      title:         entity.title,
      targetAmount:  entity.targetAmount,
      currentAmount: entity.currentAmount,
      deadline:      entity.deadline,
      note:          entity.note,
    );
  }
}