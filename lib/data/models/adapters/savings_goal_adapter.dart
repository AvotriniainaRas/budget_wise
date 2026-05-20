import 'package:hive_flutter/hive_flutter.dart';
import '../savings_goal_model.dart';

/// Adaptateur Hive pour [SavingsGoalModel].
class SavingsGoalAdapter extends TypeAdapter<SavingsGoalModel> {
  @override
  final int typeId = 2;

  @override
  SavingsGoalModel read(BinaryReader reader) {
    return SavingsGoalModel(
      id:            reader.readString(),
      title:         reader.readString(),
      targetAmount:  reader.readDouble(),
      currentAmount: reader.readDouble(),
      deadline:      DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      note:          reader.readBool() ? reader.readString() : null,
    );
  }

  @override
  void write(BinaryWriter writer, SavingsGoalModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeDouble(obj.targetAmount);
    writer.writeDouble(obj.currentAmount);
    writer.writeInt(obj.deadline.millisecondsSinceEpoch);

    if (obj.note != null) {
      writer.writeBool(true);
      writer.writeString(obj.note!);
    } else {
      writer.writeBool(false);
    }
  }
}