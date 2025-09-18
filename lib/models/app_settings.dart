import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 3)
class AppSettings extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  String defaultCurrency;

  @HiveField(2)
  String companyName;

  @HiveField(3)
  String? companyLogo;

  @HiveField(4)
  String? companyAddress;

  @HiveField(5)
  String? companyPhone;

  @HiveField(6)
  String? companyEmail;

  @HiveField(7)
  String? companyWebsite;

  @HiveField(8)
  String? signature;

  @HiveField(9)
  String invoiceNumberPrefix;

  @HiveField(10)
  int nextInvoiceNumber;

  @HiveField(11)
  int defaultDueDays;

  @HiveField(12)
  String? defaultNotes;

  @HiveField(13)
  Map<String, dynamic>? customFields;

  @HiveField(14)
  String language;

  @HiveField(15)
  String dateFormat;

  @HiveField(16)
  String timeFormat;

  @HiveField(17)
  bool autoSave;

  @HiveField(18)
  int autoSaveInterval; // in minutes

  @HiveField(19)
  bool enableNotifications;

  @HiveField(20)
  bool enableBackup;

  @HiveField(21)
  DateTime? lastBackup;

  AppSettings({
    this.isDarkMode = false,
    this.defaultCurrency = 'USD',
    this.companyName = 'My Company',
    this.companyLogo,
    this.companyAddress,
    this.companyPhone,
    this.companyEmail,
    this.companyWebsite,
    this.signature,
    this.invoiceNumberPrefix = 'INV',
    this.nextInvoiceNumber = 1,
    this.defaultDueDays = 30,
    this.defaultNotes,
    this.customFields,
    this.language = 'en',
    this.dateFormat = 'MM/dd/yyyy',
    this.timeFormat = '12h',
    this.autoSave = true,
    this.autoSaveInterval = 5,
    this.enableNotifications = true,
    this.enableBackup = true,
    this.lastBackup,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    String? defaultCurrency,
    String? companyName,
    String? companyLogo,
    String? companyAddress,
    String? companyPhone,
    String? companyEmail,
    String? companyWebsite,
    String? signature,
    String? invoiceNumberPrefix,
    int? nextInvoiceNumber,
    int? defaultDueDays,
    String? defaultNotes,
    Map<String, dynamic>? customFields,
    String? language,
    String? dateFormat,
    String? timeFormat,
    bool? autoSave,
    int? autoSaveInterval,
    bool? enableNotifications,
    bool? enableBackup,
    DateTime? lastBackup,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
      companyAddress: companyAddress ?? this.companyAddress,
      companyPhone: companyPhone ?? this.companyPhone,
      companyEmail: companyEmail ?? this.companyEmail,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      signature: signature ?? this.signature,
      invoiceNumberPrefix: invoiceNumberPrefix ?? this.invoiceNumberPrefix,
      nextInvoiceNumber: nextInvoiceNumber ?? this.nextInvoiceNumber,
      defaultDueDays: defaultDueDays ?? this.defaultDueDays,
      defaultNotes: defaultNotes ?? this.defaultNotes,
      customFields: customFields ?? this.customFields,
      language: language ?? this.language,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      autoSave: autoSave ?? this.autoSave,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableBackup: enableBackup ?? this.enableBackup,
      lastBackup: lastBackup ?? this.lastBackup,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'defaultCurrency': defaultCurrency,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'companyAddress': companyAddress,
      'companyPhone': companyPhone,
      'companyEmail': companyEmail,
      'companyWebsite': companyWebsite,
      'signature': signature,
      'invoiceNumberPrefix': invoiceNumberPrefix,
      'nextInvoiceNumber': nextInvoiceNumber,
      'defaultDueDays': defaultDueDays,
      'defaultNotes': defaultNotes,
      'customFields': customFields,
      'language': language,
      'dateFormat': dateFormat,
      'timeFormat': timeFormat,
      'autoSave': autoSave,
      'autoSaveInterval': autoSaveInterval,
      'enableNotifications': enableNotifications,
      'enableBackup': enableBackup,
      'lastBackup': lastBackup?.toIso8601String(),
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      defaultCurrency: json['defaultCurrency'] as String? ?? 'USD',
      companyName: json['companyName'] as String? ?? 'My Company',
      companyLogo: json['companyLogo'] as String?,
      companyAddress: json['companyAddress'] as String?,
      companyPhone: json['companyPhone'] as String?,
      companyEmail: json['companyEmail'] as String?,
      companyWebsite: json['companyWebsite'] as String?,
      signature: json['signature'] as String?,
      invoiceNumberPrefix: json['invoiceNumberPrefix'] as String? ?? 'INV',
      nextInvoiceNumber: json['nextInvoiceNumber'] as int? ?? 1,
      defaultDueDays: json['defaultDueDays'] as int? ?? 30,
      defaultNotes: json['defaultNotes'] as String?,
      customFields: json['customFields'] as Map<String, dynamic>?,
      language: json['language'] as String? ?? 'en',
      dateFormat: json['dateFormat'] as String? ?? 'MM/dd/yyyy',
      timeFormat: json['timeFormat'] as String? ?? '12h',
      autoSave: json['autoSave'] as bool? ?? true,
      autoSaveInterval: json['autoSaveInterval'] as int? ?? 5,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableBackup: json['enableBackup'] as bool? ?? true,
      lastBackup: json['lastBackup'] != null 
          ? DateTime.parse(json['lastBackup'] as String) 
          : null,
    );
  }

  String get nextInvoiceNumberFormatted {
    return '$invoiceNumberPrefix-${nextInvoiceNumber.toString().padLeft(4, '0')}';
  }

  void incrementInvoiceNumber() {
    nextInvoiceNumber++;
    save();
  }

  @override
  String toString() {
    return 'AppSettings(companyName: $companyName, isDarkMode: $isDarkMode)';
  }
}


