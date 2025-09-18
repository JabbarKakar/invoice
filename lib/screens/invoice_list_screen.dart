import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/invoice_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/invoice_card.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';
  String _sortBy = 'lastModified';

  @override
  void initState() {
    super.initState();
    context.read<InvoiceProvider>().loadInvoices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Invoices'),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search invoices...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          context.read<InvoiceProvider>().searchInvoices('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<InvoiceProvider>().searchInvoices(value);
              },
            ),
          ),
          
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedStatus == 'all',
                    onTap: () => _filterByStatus('all'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Draft',
                    isSelected: _selectedStatus == 'draft',
                    onTap: () => _filterByStatus('draft'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Sent',
                    isSelected: _selectedStatus == 'sent',
                    onTap: () => _filterByStatus('sent'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Paid',
                    isSelected: _selectedStatus == 'paid',
                    onTap: () => _filterByStatus('paid'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Overdue',
                    isSelected: _selectedStatus == 'overdue',
                    onTap: () => _filterByStatus('overdue'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Invoices List
          Expanded(
            child: Consumer<InvoiceProvider>(
              builder: (context, invoiceProvider, child) {
                if (invoiceProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                final invoices = invoiceProvider.invoices;
                
                if (invoices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No invoices found',
                          style: AppTheme.heading5.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first invoice to get started',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: invoices.length,
                  itemBuilder: (context, index) {
                    final invoice = invoices[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InvoiceCard(
                        invoice: invoice,
                        onTap: () {
                          // TODO: Navigate to invoice details
                        },
                        onEdit: () {
                          // TODO: Navigate to edit invoice
                        },
                        onDuplicate: () {
                          invoiceProvider.duplicateInvoice(invoice.id);
                        },
                        onDelete: () {
                          _showDeleteDialog(invoice);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _filterByStatus(String status) {
    setState(() {
      _selectedStatus = status;
    });
    context.read<InvoiceProvider>().filterByStatus(status);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort & Filter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sort by'),
              trailing: DropdownButton<String>(
                value: _sortBy,
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                  context.read<InvoiceProvider>().sortInvoices(value!);
                },
                items: const [
                  DropdownMenuItem(value: 'lastModified', child: Text('Last Modified')),
                  DropdownMenuItem(value: 'createdAt', child: Text('Created Date')),
                  DropdownMenuItem(value: 'title', child: Text('Title')),
                  DropdownMenuItem(value: 'totalAmount', child: Text('Amount')),
                  DropdownMenuItem(value: 'status', child: Text('Status')),
                  DropdownMenuItem(value: 'clientName', child: Text('Client')),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<InvoiceProvider>().clearFilters();
              setState(() {
                _selectedStatus = 'all';
                _sortBy = 'lastModified';
              });
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invoice'),
        content: Text('Are you sure you want to delete "${invoice.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<InvoiceProvider>().deleteInvoice(invoice.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}


