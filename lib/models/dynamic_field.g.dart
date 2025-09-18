// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_field.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DynamicFieldAdapter extends TypeAdapter<DynamicField> {
  @override
  final int typeId = 1;

  @override
  DynamicField read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DynamicField(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as FieldType,
      value: fields[3] as String?,
      isRequired: fields[4] as bool,
      placeholder: fields[5] as String?,
      hint: fields[6] as String?,
      order: fields[7] as int,
      options: (fields[8] as Map?)?.cast<String, dynamic>(),
      validation: (fields[9] as Map?)?.cast<String, dynamic>(),
      isVisible: fields[10] as bool,
      defaultValue: fields[11] as String?,
      minValue: fields[12] as double?,
      maxValue: fields[13] as double?,
      maxLength: fields[14] as int?,
      currency: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DynamicField obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.value)
      ..writeByte(4)
      ..write(obj.isRequired)
      ..writeByte(5)
      ..write(obj.placeholder)
      ..writeByte(6)
      ..write(obj.hint)
      ..writeByte(7)
      ..write(obj.order)
      ..writeByte(8)
      ..write(obj.options)
      ..writeByte(9)
      ..write(obj.validation)
      ..writeByte(10)
      ..write(obj.isVisible)
      ..writeByte(11)
      ..write(obj.defaultValue)
      ..writeByte(12)
      ..write(obj.minValue)
      ..writeByte(13)
      ..write(obj.maxValue)
      ..writeByte(14)
      ..write(obj.maxLength)
      ..writeByte(15)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamicFieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
