// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceAdapter extends TypeAdapter<Invoice> {
  @override
  final int typeId = 2;

  @override
  Invoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invoice(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      createdAt: fields[3] as DateTime,
      lastModified: fields[4] as DateTime,
      fields: (fields[5] as List).cast<DynamicField>(),
      clientName: fields[6] as String?,
      clientEmail: fields[7] as String?,
      clientPhone: fields[8] as String?,
      companyName: fields[9] as String?,
      companyLogo: fields[10] as String?,
      companyAddress: fields[11] as String?,
      companyPhone: fields[12] as String?,
      companyEmail: fields[13] as String?,
      notes: fields[14] as String?,
      signature: fields[15] as String?,
      status: fields[16] as String?,
      totalAmount: fields[17] as double?,
      currency: fields[18] as String?,
      dueDate: fields[19] as DateTime?,
      invoiceNumber: fields[20] as String?,
      customData: (fields[21] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Invoice obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastModified)
      ..writeByte(5)
      ..write(obj.fields)
      ..writeByte(6)
      ..write(obj.clientName)
      ..writeByte(7)
      ..write(obj.clientEmail)
      ..writeByte(8)
      ..write(obj.clientPhone)
      ..writeByte(9)
      ..write(obj.companyName)
      ..writeByte(10)
      ..write(obj.companyLogo)
      ..writeByte(11)
      ..write(obj.companyAddress)
      ..writeByte(12)
      ..write(obj.companyPhone)
      ..writeByte(13)
      ..write(obj.companyEmail)
      ..writeByte(14)
      ..write(obj.notes)
      ..writeByte(15)
      ..write(obj.signature)
      ..writeByte(16)
      ..write(obj.status)
      ..writeByte(17)
      ..write(obj.totalAmount)
      ..writeByte(18)
      ..write(obj.currency)
      ..writeByte(19)
      ..write(obj.dueDate)
      ..writeByte(20)
      ..write(obj.invoiceNumber)
      ..writeByte(21)
      ..write(obj.customData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
