import 'package:hive/hive.dart';

part 'field_type.g.dart';

@HiveType(typeId: 0)
enum FieldType {
  @HiveField(0)
  text,
  @HiveField(1)
  number,
  @HiveField(2)
  email,
  @HiveField(3)
  phone,
  @HiveField(4)
  date,
  @HiveField(5)
  time,
  @HiveField(6)
  datetime,
  @HiveField(7)
  dropdown,
  @HiveField(8)
  checkbox,
  @HiveField(9)
  radio,
  @HiveField(10)
  textarea,
  @HiveField(11)
  currency,
  @HiveField(12)
  percentage,
  @HiveField(13)
  url,
  @HiveField(14)
  multilineText,
}

extension FieldTypeExtension on FieldType {
  String get displayName {
    switch (this) {
      case FieldType.text:
        return 'Text';
      case FieldType.number:
        return 'Number';
      case FieldType.email:
        return 'Email';
      case FieldType.phone:
        return 'Phone';
      case FieldType.date:
        return 'Date';
      case FieldType.time:
        return 'Time';
      case FieldType.datetime:
        return 'Date & Time';
      case FieldType.dropdown:
        return 'Dropdown';
      case FieldType.checkbox:
        return 'Checkbox';
      case FieldType.radio:
        return 'Radio Button';
      case FieldType.textarea:
        return 'Text Area';
      case FieldType.currency:
        return 'Currency';
      case FieldType.percentage:
        return 'Percentage';
      case FieldType.url:
        return 'URL';
      case FieldType.multilineText:
        return 'Multiline Text';
    }
  }

  String get icon {
    switch (this) {
      case FieldType.text:
        return '📝';
      case FieldType.number:
        return '🔢';
      case FieldType.email:
        return '📧';
      case FieldType.phone:
        return '📞';
      case FieldType.date:
        return '📅';
      case FieldType.time:
        return '🕐';
      case FieldType.datetime:
        return '📅🕐';
      case FieldType.dropdown:
        return '📋';
      case FieldType.checkbox:
        return '☑️';
      case FieldType.radio:
        return '🔘';
      case FieldType.textarea:
        return '📄';
      case FieldType.currency:
        return '💰';
      case FieldType.percentage:
        return '📊';
      case FieldType.url:
        return '🔗';
      case FieldType.multilineText:
        return '📝';
    }
  }
}
