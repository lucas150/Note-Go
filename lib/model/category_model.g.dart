// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseCategoryAdapter extends TypeAdapter<ExpenseCategory> {
  @override
  final int typeId = 4;

  @override
  ExpenseCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseCategory(
      expenseCategoryName: fields[0] as String,
      subExpenseCategory: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.expenseCategoryName)
      ..writeByte(1)
      ..write(obj.subExpenseCategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
