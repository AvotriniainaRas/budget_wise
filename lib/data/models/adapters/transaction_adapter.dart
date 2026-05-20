import 'package:hive_flutter/hive_flutter.dart';
import '../transaction_model.dart';

/// Adaptateur Hive pour [TransactionModel].
///
/// [typeId] doit correspondre exactement à celui
/// du modèle annoté (@HiveType(typeId: 0)).
class TransactionAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    return TransactionModel(
      id:         reader.readString(),
      title:      reader.readString(),
      amount:     reader.readDouble(),
      typeIndex:  reader.readInt(),
      categoryId: reader.readString(),
      date:       DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      note:       reader.readBool() ? reader.readString() : null,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeDouble(obj.amount);
    writer.writeInt(obj.typeIndex);
    writer.writeString(obj.categoryId);
    writer.writeInt(obj.date.millisecondsSinceEpoch);

    // Champ nullable : on écrit un bool pour indiquer la présence.
    if (obj.note != null) {
      writer.writeBool(true);
      writer.writeString(obj.note!);
    } else {
      writer.writeBool(false);
    }
  }
}