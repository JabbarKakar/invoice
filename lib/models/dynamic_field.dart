import 'package:hive/hive.dart';
import 'field_type.dart';

part 'dynamic_field.g.dart';

@HiveType(typeId: 1)
class DynamicField extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  FieldType type;

  @HiveField(3)
  String? value;

  @HiveField(4)
  bool isRequired;

  @HiveField(5)
  String? placeholder;

  @HiveField(6)
  String? hint;

  @HiveField(7)
  int order;

  @HiveField(8)
  Map<String, dynamic>? options; // For dropdown, radio options

  @HiveField(9)
  Map<String, dynamic>? validation; // Validation rules

  @HiveField(10)
  bool isVisible;

  @HiveField(11)
  String? defaultValue;

  @HiveField(12)
  double? minValue; // For number fields

  @HiveField(13)
  double? maxValue; // For number fields

  @HiveField(14)
  int? maxLength; // For text fields

  @HiveField(15)
  String? currency; // For currency fields

  DynamicField({
    required this.id,
    required this.name,
    required this.type,
    this.value,
    this.isRequired = false,
    this.placeholder,
    this.hint,
    this.order = 0,
    this.options,
    this.validation,
    this.isVisible = true,
    this.defaultValue,
    this.minValue,
    this.maxValue,
    this.maxLength,
    this.currency,
  });

  DynamicField copyWith({
    String? id,
    String? name,
    FieldType? type,
    String? value,
    bool? isRequired,
    String? placeholder,
    String? hint,
    int? order,
    Map<String, dynamic>? options,
    Map<String, dynamic>? validation,
    bool? isVisible,
    String? defaultValue,
    double? minValue,
    double? maxValue,
    int? maxLength,
    String? currency,
  }) {
    return DynamicField(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      isRequired: isRequired ?? this.isRequired,
      placeholder: placeholder ?? this.placeholder,
      hint: hint ?? this.hint,
      order: order ?? this.order,
      options: options ?? this.options,
      validation: validation ?? this.validation,
      isVisible: isVisible ?? this.isVisible,
      defaultValue: defaultValue ?? this.defaultValue,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      maxLength: maxLength ?? this.maxLength,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'value': value,
      'isRequired': isRequired,
      'placeholder': placeholder,
      'hint': hint,
      'order': order,
      'options': options,
      'validation': validation,
      'isVisible': isVisible,
      'defaultValue': defaultValue,
      'minValue': minValue,
      'maxValue': maxValue,
      'maxLength': maxLength,
      'currency': currency,
    };
  }

  factory DynamicField.fromJson(Map<String, dynamic> json) {
    return DynamicField(
      id: json['id'] as String,
      name: json['name'] as String,
      type: FieldType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => FieldType.text,
      ),
      value: json['value'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
      placeholder: json['placeholder'] as String?,
      hint: json['hint'] as String?,
      order: json['order'] as int? ?? 0,
      options: json['options'] as Map<String, dynamic>?,
      validation: json['validation'] as Map<String, dynamic>?,
      isVisible: json['isVisible'] as bool? ?? true,
      defaultValue: json['defaultValue'] as String?,
      minValue: json['minValue'] as double?,
      maxValue: json['maxValue'] as double?,
      maxLength: json['maxLength'] as int?,
      currency: json['currency'] as String?,
    );
  }

  @override
  String toString() {
    return 'DynamicField(id: $id, name: $name, type: $type, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DynamicField && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


