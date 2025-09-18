import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/invoice_provider.dart';
import '../models/invoice.dart';
import '../models/dynamic_field.dart';
import '../models/field_type.dart';
import '../theme/app_theme.dart';
import '../widgets/field_widgets/reorderable_fields_list.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _clientEmailController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyPhoneController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _notesController = TextEditingController();

  List<DynamicField> _fields = [];
  String _status = 'draft';
  double? _totalAmount;
  String _currency = 'USD';
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _addDefaultFields();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _clientNameController.dispose();
    _clientEmailController.dispose();
    _clientPhoneController.dispose();
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _companyPhoneController.dispose();
    _companyEmailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addDefaultFields() {
    // Add some default fields for demonstration
    _fields.addAll([
      DynamicField(
        id: const Uuid().v4(),
        name: 'Item Description',
        type: FieldType.text,
        isRequired: true,
        order: 0,
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Quantity',
        type: FieldType.number,
        isRequired: true,
        order: 1,
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Unit Price',
        type: FieldType.currency,
        isRequired: true,
        order: 2,
        currency: 'USD',
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Total',
        type: FieldType.currency,
        isRequired: true,
        order: 3,
        currency: 'USD',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: const Text('Save Draft'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _saveInvoice,
            child: const Text('Save'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              _SectionCard(
                title: 'Basic Information',
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Invoice Title',
                      hintText: 'Enter invoice title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter invoice description',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Client Information
              _SectionCard(
                title: 'Client Information',
                children: [
                  TextFormField(
                    controller: _clientNameController,
                    decoration: const InputDecoration(
                      labelText: 'Client Name',
                      hintText: 'Enter client name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _clientEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Client Email',
                      hintText: 'Enter client email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _clientPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Client Phone',
                      hintText: 'Enter client phone',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Company Information
              _SectionCard(
                title: 'Company Information',
                children: [
                  TextFormField(
                    controller: _companyNameController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      hintText: 'Enter company name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _companyAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Company Address',
                      hintText: 'Enter company address',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _companyPhoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            hintText: 'Enter phone',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _companyEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Invoice Details
              _SectionCard(
                title: 'Invoice Details',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _status,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                          ),
                          items: const [
                            DropdownMenuItem(value: 'draft', child: Text('Draft')),
                            DropdownMenuItem(value: 'sent', child: Text('Sent')),
                            DropdownMenuItem(value: 'paid', child: Text('Paid')),
                            DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
                            DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _status = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Currency',
                            hintText: 'USD',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _currency = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Total Amount',
                            hintText: '0.00',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _totalAmount = double.tryParse(value);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: _selectDueDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Due Date',
                            ),
                            child: Text(
                              _dueDate != null
                                  ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                                  : 'Select date',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Dynamic Fields
              _SectionCard(
                title: 'Invoice Items',
                children: [
                  ReorderableFieldsList(
                    fields: _fields,
                    isEditing: true,
                    onFieldsReordered: (reorderedFields) {
                      setState(() {
                        _fields = reorderedFields;
                      });
                    },
                    onFieldChanged: (field) {
                      // Field changed, no need to do anything special
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _addField,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Field'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _addPresetFields,
                          icon: const Icon(Icons.auto_fix_high),
                          label: const Text('Add Preset'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Notes
              _SectionCard(
                title: 'Additional Notes',
                children: [
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Enter any additional notes',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),

              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }


  void _addField() {
    showDialog(
      context: context,
      builder: (context) => _AddFieldDialog(
        onFieldAdded: (field) {
          setState(() {
            field.order = _fields.length;
            _fields.add(field);
          });
        },
      ),
    );
  }

  void _addPresetFields() {
    showDialog(
      context: context,
      builder: (context) => _PresetFieldsDialog(
        onFieldsAdded: (fields) {
          setState(() {
            for (int i = 0; i < fields.length; i++) {
              fields[i].order = _fields.length + i;
            }
            _fields.addAll(fields);
          });
        },
      ),
    );
  }

  void _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }


  void _saveDraft() {
    _saveInvoice(isDraft: true);
  }

  void _saveInvoice({bool isDraft = false}) {
    if (_formKey.currentState!.validate()) {
      final invoice = Invoice(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
        fields: _fields,
        clientName: _clientNameController.text,
        clientEmail: _clientEmailController.text,
        clientPhone: _clientPhoneController.text,
        companyName: _companyNameController.text,
        companyAddress: _companyAddressController.text,
        companyPhone: _companyPhoneController.text,
        companyEmail: _companyEmailController.text,
        notes: _notesController.text,
        status: isDraft ? 'draft' : _status,
        totalAmount: _totalAmount,
        currency: _currency,
        dueDate: _dueDate,
      );

      context.read<InvoiceProvider>().addInvoice(invoice);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isDraft ? 'Draft saved!' : 'Invoice saved!'),
        ),
      );

      Navigator.of(context).pop();
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.heading6.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _AddFieldDialog extends StatefulWidget {
  final Function(DynamicField) onFieldAdded;

  const _AddFieldDialog({required this.onFieldAdded});

  @override
  State<_AddFieldDialog> createState() => _AddFieldDialogState();
}

class _AddFieldDialogState extends State<_AddFieldDialog> {
  final _nameController = TextEditingController();
  FieldType _selectedType = FieldType.text;
  bool _isRequired = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Field'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Field Name',
              hintText: 'Enter field name',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<FieldType>(
            value: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Field Type',
            ),
            items: FieldType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Row(
                  children: [
                    Text(type.icon),
                    const SizedBox(width: 8),
                    Text(type.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Required'),
            value: _isRequired,
            onChanged: (value) {
              setState(() {
                _isRequired = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              final field = DynamicField(
                id: const Uuid().v4(),
                name: _nameController.text,
                type: _selectedType,
                isRequired: _isRequired,
                order: 0, // Will be updated when added to the list
              );
              widget.onFieldAdded(field);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _PresetFieldsDialog extends StatefulWidget {
  final Function(List<DynamicField>) onFieldsAdded;

  const _PresetFieldsDialog({required this.onFieldsAdded});

  @override
  State<_PresetFieldsDialog> createState() => _PresetFieldsDialogState();
}

class _PresetFieldsDialogState extends State<_PresetFieldsDialog> {
  final List<String> _selectedPresets = [];

  final Map<String, List<DynamicField>> _presetTemplates = {
    'Basic Invoice': [
      DynamicField(
        id: const Uuid().v4(),
        name: 'Item Description',
        type: FieldType.text,
        isRequired: true,
        order: 0,
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Quantity',
        type: FieldType.number,
        isRequired: true,
        order: 1,
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Unit Price',
        type: FieldType.currency,
        isRequired: true,
        order: 2,
        currency: 'USD',
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Total',
        type: FieldType.currency,
        isRequired: true,
        order: 3,
        currency: 'USD',
      ),
    ],
    'Service Invoice': [
      DynamicField(
        id: const Uuid().v4(),
        name: 'Service Description',
        type: FieldType.textarea,
        isRequired: true,
        order: 0,
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Hours Worked',
        type: FieldType.number,
        isRequired: true,
        order: 1,
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Hourly Rate',
        type: FieldType.currency,
        isRequired: true,
        order: 2,
        currency: 'USD',
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Total Amount',
        type: FieldType.currency,
        isRequired: true,
        order: 3,
        currency: 'USD',
      ),
    ],
    'Product Invoice': [
      DynamicField(
        id: const Uuid().v4(),
        name: 'Product Name',
        type: FieldType.text,
        isRequired: true,
        order: 0,
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'SKU',
        type: FieldType.text,
        isRequired: false,
        order: 1,
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Quantity',
        type: FieldType.number,
        isRequired: true,
        order: 2,
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Unit Price',
        type: FieldType.currency,
        isRequired: true,
        order: 3,
        currency: 'USD',
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Tax Rate',
        type: FieldType.percentage,
        isRequired: false,
        order: 4,
      ),
      DynamicField(
        id: const Uuid().v4(),
        name: 'Total',
        type: FieldType.currency,
        isRequired: true,
        order: 5,
        currency: 'USD',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Preset Fields'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select preset templates to add:'),
            const SizedBox(height: 16),
            ..._presetTemplates.keys.map((presetName) {
              return CheckboxListTile(
                title: Text(presetName),
                subtitle: Text('${_presetTemplates[presetName]!.length} fields'),
                value: _selectedPresets.contains(presetName),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedPresets.add(presetName);
                    } else {
                      _selectedPresets.remove(presetName);
                    }
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedPresets.isEmpty
              ? null
              : () {
                  final fields = <DynamicField>[];
                  for (final presetName in _selectedPresets) {
                    fields.addAll(_presetTemplates[presetName]!);
                  }
                  widget.onFieldsAdded(fields);
                  Navigator.of(context).pop();
                },
          child: const Text('Add Fields'),
        ),
      ],
    );
  }
}
