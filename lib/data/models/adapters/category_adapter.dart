import 'package:hive_flutter/hive_flutter.dart';
import '../category_model.dart';

/// Adaptateur Hive pour [CategoryModel].
class CategoryAdapter extends TypeAdapter<CategoryModel> {
  @override
  final int typeId = 1;

  @override
  CategoryModel read(BinaryReader reader) {
    return CategoryModel(
      id:         reader.readString(),
      name:       reader.readString(),
      iconCode:   reader.readInt(),
      colorValue: reader.readInt(),
      isDefault:  reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.iconCode);
    writer.writeInt(obj.colorValue);
    writer.writeBool(obj.isDefault);
  }
}