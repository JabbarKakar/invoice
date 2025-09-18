import 'package:hive_flutter/hive_flutter.dart';
import '../models/dynamic_field.dart';
import '../models/invoice.dart';
import '../models/app_settings.dart';
import '../models/field_type.dart';

class DatabaseService {
  static const String _invoicesBoxName = 'invoices';
  static const String _settingsBoxName = 'settings';
  static const String _fieldsBoxName = 'fields';

  static late Box<Invoice> _invoicesBox;
  static late Box<AppSettings> _settingsBox;
  static late Box<DynamicField> _fieldsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(DynamicFieldAdapter());
    Hive.registerAdapter(InvoiceAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(FieldTypeAdapter());

    // Open boxes
    _invoicesBox = await Hive.openBox<Invoice>(_invoicesBoxName);
    _settingsBox = await Hive.openBox<AppSettings>(_settingsBoxName);
    _fieldsBox = await Hive.openBox<DynamicField>(_fieldsBoxName);

    // Initialize default settings if not exists
    if (_settingsBox.isEmpty) {
      final defaultSettings = AppSettings();
      await _settingsBox.put('default', defaultSettings);
    }
  }

  // Invoice operations
  static Future<void> saveInvoice(Invoice invoice) async {
    await _invoicesBox.put(invoice.id, invoice);
  }

  static Future<void> deleteInvoice(String invoiceId) async {
    await _invoicesBox.delete(invoiceId);
  }

  static Invoice? getInvoice(String invoiceId) {
    return _invoicesBox.get(invoiceId);
  }

  static List<Invoice> getAllInvoices() {
    return _invoicesBox.values.toList();
  }

  static List<Invoice> getInvoicesByStatus(String status) {
    return _invoicesBox.values
        .where((invoice) => invoice.status == status)
        .toList();
  }

  static List<Invoice> searchInvoices(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _invoicesBox.values.where((invoice) {
      return invoice.title.toLowerCase().contains(lowercaseQuery) ||
          (invoice.clientName?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (invoice.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (invoice.invoiceNumber?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  static List<Invoice> getRecentInvoices({int limit = 10}) {
    final invoices = _invoicesBox.values.toList();
    invoices.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    return invoices.take(limit).toList();
  }

  // Settings operations
  static AppSettings getSettings() {
    return _settingsBox.get('default') ?? AppSettings();
  }

  static Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put('default', settings);
  }

  // Field operations
  static Future<void> saveField(DynamicField field) async {
    await _fieldsBox.put(field.id, field);
  }

  static Future<void> deleteField(String fieldId) async {
    await _fieldsBox.delete(fieldId);
  }

  static DynamicField? getField(String fieldId) {
    return _fieldsBox.get(fieldId);
  }

  static List<DynamicField> getAllFields() {
    return _fieldsBox.values.toList();
  }

  // Statistics
  static Map<String, int> getInvoiceStats() {
    final invoices = _invoicesBox.values.toList();
    final stats = <String, int>{};
    
    for (final status in ['draft', 'sent', 'paid', 'overdue', 'cancelled']) {
      stats[status] = invoices.where((invoice) => invoice.status == status).length;
    }
    
    return stats;
  }

  static double getTotalRevenue() {
    return _invoicesBox.values
        .where((invoice) => invoice.status == 'paid')
        .fold(0.0, (sum, invoice) => sum + (invoice.totalAmount ?? 0));
  }

  static int getTotalInvoices() {
    return _invoicesBox.length;
  }

  // Backup and restore
  static Future<Map<String, dynamic>> exportData() async {
    return {
      'invoices': _invoicesBox.values.map((e) => e.toJson()).toList(),
      'settings': getSettings().toJson(),
      'fields': _fieldsBox.values.map((e) => e.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  static Future<void> importData(Map<String, dynamic> data) async {
    // Clear existing data
    await _invoicesBox.clear();
    await _fieldsBox.clear();

    // Import invoices
    if (data['invoices'] != null) {
      for (final invoiceData in data['invoices'] as List) {
        final invoice = Invoice.fromJson(invoiceData as Map<String, dynamic>);
        await saveInvoice(invoice);
      }
    }

    // Import fields
    if (data['fields'] != null) {
      for (final fieldData in data['fields'] as List) {
        final field = DynamicField.fromJson(fieldData as Map<String, dynamic>);
        await saveField(field);
      }
    }

    // Import settings
    if (data['settings'] != null) {
      final settings = AppSettings.fromJson(data['settings'] as Map<String, dynamic>);
      await saveSettings(settings);
    }
  }

  // Cleanup
  static Future<void> close() async {
    await _invoicesBox.close();
    await _settingsBox.close();
    await _fieldsBox.close();
  }
}
