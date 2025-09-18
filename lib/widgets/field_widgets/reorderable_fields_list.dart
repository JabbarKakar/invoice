import 'package:flutter/material.dart';
import '../../models/dynamic_field.dart';
import '../../models/field_type.dart';
import '../../theme/app_theme.dart';
import 'dynamic_field_widget.dart';

class ReorderableFieldsList extends StatefulWidget {
  final List<DynamicField> fields;
  final ValueChanged<List<DynamicField>> onFieldsReordered;
  final ValueChanged<DynamicField>? onFieldChanged;
  final bool isEditing;

  const ReorderableFieldsList({
    super.key,
    required this.fields,
    required this.onFieldsReordered,
    this.onFieldChanged,
    this.isEditing = true,
  });

  @override
  State<ReorderableFieldsList> createState() => _ReorderableFieldsListState();
}

class _ReorderableFieldsListState extends State<ReorderableFieldsList> {
  late List<DynamicField> _fields;

  @override
  void initState() {
    super.initState();
    _fields = List.from(widget.fields);
    _updateFieldOrders();
  }

  @override
  void didUpdateWidget(ReorderableFieldsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fields != oldWidget.fields) {
      _fields = List.from(widget.fields);
      _updateFieldOrders();
    }
  }

  void _updateFieldOrders() {
    for (int i = 0; i < _fields.length; i++) {
      _fields[i] = _fields[i].copyWith(order: i);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final field = _fields.removeAt(oldIndex);
      _fields.insert(newIndex, field);
      _updateFieldOrders();
    });
    widget.onFieldsReordered(_fields);
  }

  @override
  Widget build(BuildContext context) {
    if (_fields.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.drag_indicator,
              size: 48,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No fields added yet',
              style: AppTheme.heading6.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add fields to create your custom invoice form',
              style: AppTheme.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: _onReorder,
      children: _fields.asMap().entries.map((entry) {
        final index = entry.key;
        final field = entry.value;
        return _FieldListItem(
          key: ValueKey(field.id),
          field: field,
          index: index,
          isEditing: widget.isEditing,
          onFieldChanged: widget.onFieldChanged,
        );
      }).toList(),
    );
  }
}

class _FieldListItem extends StatelessWidget {
  final DynamicField field;
  final int index;
  final bool isEditing;
  final ValueChanged<DynamicField>? onFieldChanged;

  const _FieldListItem({
    super.key,
    required this.field,
    required this.index,
    required this.isEditing,
    this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkCardGradient
                : AppTheme.cardGradient,
          ),
          child: Column(
            children: [
              // Field Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    // Drag Handle
                    if (isEditing)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.drag_indicator,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    
                    if (isEditing) const SizedBox(width: 8),
                    
                    // Field Icon
                    Text(
                      field.type.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Field Name and Type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            field.name,
                            style: AppTheme.labelLarge.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            field.type.displayName,
                            style: AppTheme.bodySmall.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Field Order
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: AppTheme.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Field Widget
              Padding(
                padding: const EdgeInsets.all(16),
                child: DynamicFieldWidget(
                  field: field,
                  isEditing: isEditing,
                  onChanged: (value) {
                    onFieldChanged?.call(field);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
