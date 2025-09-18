// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 3;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      isDarkMode: fields[0] as bool,
      defaultCurrency: fields[1] as String,
      companyName: fields[2] as String,
      companyLogo: fields[3] as String?,
      companyAddress: fields[4] as String?,
      companyPhone: fields[5] as String?,
      companyEmail: fields[6] as String?,
      companyWebsite: fields[7] as String?,
      signature: fields[8] as String?,
      invoiceNumberPrefix: fields[9] as String,
      nextInvoiceNumber: fields[10] as int,
      defaultDueDays: fields[11] as int,
      defaultNotes: fields[12] as String?,
      customFields: (fields[13] as Map?)?.cast<String, dynamic>(),
      language: fields[14] as String,
      dateFormat: fields[15] as String,
      timeFormat: fields[16] as String,
      autoSave: fields[17] as bool,
      autoSaveInterval: fields[18] as int,
      enableNotifications: fields[19] as bool,
      enableBackup: fields[20] as bool,
      lastBackup: fields[21] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.defaultCurrency)
      ..writeByte(2)
      ..write(obj.companyName)
      ..writeByte(3)
      ..write(obj.companyLogo)
      ..writeByte(4)
      ..write(obj.companyAddress)
      ..writeByte(5)
      ..write(obj.companyPhone)
      ..writeByte(6)
      ..write(obj.companyEmail)
      ..writeByte(7)
      ..write(obj.companyWebsite)
      ..writeByte(8)
      ..write(obj.signature)
      ..writeByte(9)
      ..write(obj.invoiceNumberPrefix)
      ..writeByte(10)
      ..write(obj.nextInvoiceNumber)
      ..writeByte(11)
      ..write(obj.defaultDueDays)
      ..writeByte(12)
      ..write(obj.defaultNotes)
      ..writeByte(13)
      ..write(obj.customFields)
      ..writeByte(14)
      ..write(obj.language)
      ..writeByte(15)
      ..write(obj.dateFormat)
      ..writeByte(16)
      ..write(obj.timeFormat)
      ..writeByte(17)
      ..write(obj.autoSave)
      ..writeByte(18)
      ..write(obj.autoSaveInterval)
      ..writeByte(19)
      ..write(obj.enableNotifications)
      ..writeByte(20)
      ..write(obj.enableBackup)
      ..writeByte(21)
      ..write(obj.lastBackup);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
