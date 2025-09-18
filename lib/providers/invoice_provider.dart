import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../models/dynamic_field.dart';
import '../services/database_service.dart';

class InvoiceProvider extends ChangeNotifier {
  List<Invoice> _invoices = [];
  List<Invoice> _filteredInvoices = [];
  String _searchQuery = '';
  String _statusFilter = 'all';
  String _sortBy = 'lastModified';
  bool _isLoading = false;

  List<Invoice> get invoices => _filteredInvoices;
  List<Invoice> get allInvoices => _invoices;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String get sortBy => _sortBy;
  bool get isLoading => _isLoading;

  InvoiceProvider() {
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _invoices = DatabaseService.getAllInvoices();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading invoices: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addInvoice(Invoice invoice) async {
    try {
      await DatabaseService.saveInvoice(invoice);
      _invoices.add(invoice);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding invoice: $e');
    }
  }

  Future<void> updateInvoice(Invoice invoice) async {
    try {
      await DatabaseService.saveInvoice(invoice);
      final index = _invoices.indexWhere((i) => i.id == invoice.id);
      if (index != -1) {
        _invoices[index] = invoice;
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating invoice: $e');
    }
  }

  Future<void> deleteInvoice(String invoiceId) async {
    try {
      await DatabaseService.deleteInvoice(invoiceId);
      _invoices.removeWhere((invoice) => invoice.id == invoiceId);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting invoice: $e');
    }
  }

  void searchInvoices(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByStatus(String status) {
    _statusFilter = status;
    _applyFilters();
    notifyListeners();
  }

  void sortInvoices(String sortBy) {
    _sortBy = sortBy;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<Invoice> filtered = List.from(_invoices);

    // Apply status filter
    if (_statusFilter != 'all') {
      filtered = filtered.where((invoice) => invoice.status == _statusFilter).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((invoice) {
        return invoice.title.toLowerCase().contains(query) ||
            (invoice.clientName?.toLowerCase().contains(query) ?? false) ||
            (invoice.description?.toLowerCase().contains(query) ?? false) ||
            (invoice.invoiceNumber?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'title':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'createdAt':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'lastModified':
        filtered.sort((a, b) => b.lastModified.compareTo(a.lastModified));
        break;
      case 'totalAmount':
        filtered.sort((a, b) => (b.totalAmount ?? 0).compareTo(a.totalAmount ?? 0));
        break;
      case 'status':
        filtered.sort((a, b) => a.status?.compareTo(b.status ?? '') ?? 0);
        break;
      case 'clientName':
        filtered.sort((a, b) => (a.clientName ?? '').compareTo(b.clientName ?? ''));
        break;
    }

    _filteredInvoices = filtered;
  }

  List<Invoice> getRecentInvoices({int limit = 5}) {
    return DatabaseService.getRecentInvoices(limit: limit);
  }

  Map<String, int> getInvoiceStats() {
    return DatabaseService.getInvoiceStats();
  }

  double getTotalRevenue() {
    return DatabaseService.getTotalRevenue();
  }

  int getTotalInvoices() {
    return DatabaseService.getTotalInvoices();
  }

  List<Invoice> getInvoicesByStatus(String status) {
    return _invoices.where((invoice) => invoice.status == status).toList();
  }

  Invoice? getInvoiceById(String id) {
    try {
      return DatabaseService.getInvoice(id);
    } catch (e) {
      debugPrint('Error getting invoice by ID: $e');
      return null;
    }
  }

  Future<void> duplicateInvoice(String invoiceId) async {
    final originalInvoice = getInvoiceById(invoiceId);
    if (originalInvoice != null) {
      final duplicatedInvoice = originalInvoice.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '${originalInvoice.title} (Copy)',
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
        status: 'draft',
        invoiceNumber: null,
      );
      await addInvoice(duplicatedInvoice);
    }
  }

  Future<void> changeInvoiceStatus(String invoiceId, String newStatus) async {
    final invoice = getInvoiceById(invoiceId);
    if (invoice != null) {
      final updatedInvoice = invoice.copyWith(
        status: newStatus,
        lastModified: DateTime.now(),
      );
      await updateInvoice(updatedInvoice);
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = 'all';
    _sortBy = 'lastModified';
    _applyFilters();
    notifyListeners();
  }
}


