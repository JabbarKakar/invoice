// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FieldTypeAdapter extends TypeAdapter<FieldType> {
  @override
  final int typeId = 0;

  @override
  FieldType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FieldType.text;
      case 1:
        return FieldType.number;
      case 2:
        return FieldType.email;
      case 3:
        return FieldType.phone;
      case 4:
        return FieldType.date;
      case 5:
        return FieldType.time;
      case 6:
        return FieldType.datetime;
      case 7:
        return FieldType.dropdown;
      case 8:
        return FieldType.checkbox;
      case 9:
        return FieldType.radio;
      case 10:
        return FieldType.textarea;
      case 11:
        return FieldType.currency;
      case 12:
        return FieldType.percentage;
      case 13:
        return FieldType.url;
      case 14:
        return FieldType.multilineText;
      default:
        return FieldType.text;
    }
  }

  @override
  void write(BinaryWriter writer, FieldType obj) {
    switch (obj) {
      case FieldType.text:
        writer.writeByte(0);
        break;
      case FieldType.number:
        writer.writeByte(1);
        break;
      case FieldType.email:
        writer.writeByte(2);
        break;
      case FieldType.phone:
        writer.writeByte(3);
        break;
      case FieldType.date:
        writer.writeByte(4);
        break;
      case FieldType.time:
        writer.writeByte(5);
        break;
      case FieldType.datetime:
        writer.writeByte(6);
        break;
      case FieldType.dropdown:
        writer.writeByte(7);
        break;
      case FieldType.checkbox:
        writer.writeByte(8);
        break;
      case FieldType.radio:
        writer.writeByte(9);
        break;
      case FieldType.textarea:
        writer.writeByte(10);
        break;
      case FieldType.currency:
        writer.writeByte(11);
        break;
      case FieldType.percentage:
        writer.writeByte(12);
        break;
      case FieldType.url:
        writer.writeByte(13);
        break;
      case FieldType.multilineText:
        writer.writeByte(14);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
