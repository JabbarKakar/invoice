import 'package:hive/hive.dart';
import 'dynamic_field.dart';

part 'invoice.g.dart';

@HiveType(typeId: 2)
class Invoice extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime lastModified;

  @HiveField(5)
  List<DynamicField> fields;

  @HiveField(6)
  String? clientName;

  @HiveField(7)
  String? clientEmail;

  @HiveField(8)
  String? clientPhone;

  @HiveField(9)
  String? companyName;

  @HiveField(10)
  String? companyLogo;

  @HiveField(11)
  String? companyAddress;

  @HiveField(12)
  String? companyPhone;

  @HiveField(13)
  String? companyEmail;

  @HiveField(14)
  String? notes;

  @HiveField(15)
  String? signature;

  @HiveField(16)
  String? status; // draft, sent, paid, overdue, cancelled

  @HiveField(17)
  double? totalAmount;

  @HiveField(18)
  String? currency;

  @HiveField(19)
  DateTime? dueDate;

  @HiveField(20)
  String? invoiceNumber;

  @HiveField(21)
  Map<String, dynamic>? customData;

  Invoice({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.lastModified,
    required this.fields,
    this.clientName,
    this.clientEmail,
    this.clientPhone,
    this.companyName,
    this.companyLogo,
    this.companyAddress,
    this.companyPhone,
    this.companyEmail,
    this.notes,
    this.signature,
    this.status = 'draft',
    this.totalAmount,
    this.currency = 'USD',
    this.dueDate,
    this.invoiceNumber,
    this.customData,
  });

  Invoice copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? lastModified,
    List<DynamicField>? fields,
    String? clientName,
    String? clientEmail,
    String? clientPhone,
    String? companyName,
    String? companyLogo,
    String? companyAddress,
    String? companyPhone,
    String? companyEmail,
    String? notes,
    String? signature,
    String? status,
    double? totalAmount,
    String? currency,
    DateTime? dueDate,
    String? invoiceNumber,
    Map<String, dynamic>? customData,
  }) {
    return Invoice(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      fields: fields ?? this.fields,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      clientPhone: clientPhone ?? this.clientPhone,
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
      companyAddress: companyAddress ?? this.companyAddress,
      companyPhone: companyPhone ?? this.companyPhone,
      companyEmail: companyEmail ?? this.companyEmail,
      notes: notes ?? this.notes,
      signature: signature ?? this.signature,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      dueDate: dueDate ?? this.dueDate,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customData: customData ?? this.customData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'fields': fields.map((f) => f.toJson()).toList(),
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhone': clientPhone,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'companyAddress': companyAddress,
      'companyPhone': companyPhone,
      'companyEmail': companyEmail,
      'notes': notes,
      'signature': signature,
      'status': status,
      'totalAmount': totalAmount,
      'currency': currency,
      'dueDate': dueDate?.toIso8601String(),
      'invoiceNumber': invoiceNumber,
      'customData': customData,
    };
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      fields: (json['fields'] as List<dynamic>)
          .map((f) => DynamicField.fromJson(f as Map<String, dynamic>))
          .toList(),
      clientName: json['clientName'] as String?,
      clientEmail: json['clientEmail'] as String?,
      clientPhone: json['clientPhone'] as String?,
      companyName: json['companyName'] as String?,
      companyLogo: json['companyLogo'] as String?,
      companyAddress: json['companyAddress'] as String?,
      companyPhone: json['companyPhone'] as String?,
      companyEmail: json['companyEmail'] as String?,
      notes: json['notes'] as String?,
      signature: json['signature'] as String?,
      status: json['status'] as String? ?? 'draft',
      totalAmount: json['totalAmount'] as double?,
      currency: json['currency'] as String? ?? 'USD',
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate'] as String) 
          : null,
      invoiceNumber: json['invoiceNumber'] as String?,
      customData: json['customData'] as Map<String, dynamic>?,
    );
  }

  // Helper methods
  List<DynamicField> get visibleFields => 
      fields.where((field) => field.isVisible).toList();

  List<DynamicField> get requiredFields => 
      fields.where((field) => field.isRequired).toList();

  List<DynamicField> get sortedFields {
    final sorted = List<DynamicField>.from(fields);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  bool get isComplete {
    return requiredFields.every((field) => 
        field.value != null && field.value!.isNotEmpty);
  }

  String get statusDisplayName {
    switch (status) {
      case 'draft':
        return 'Draft';
      case 'sent':
        return 'Sent';
      case 'paid':
        return 'Paid';
      case 'overdue':
        return 'Overdue';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  @override
  String toString() {
    return 'Invoice(id: $id, title: $title, status: $status, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Invoice && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


