import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/dynamic_field.dart';
import '../../models/field_type.dart';
import '../../theme/app_theme.dart';

class DynamicFieldWidget extends StatefulWidget {
  final DynamicField field;
  final ValueChanged<String>? onChanged;
  final bool isEditing;

  const DynamicFieldWidget({
    super.key,
    required this.field,
    this.onChanged,
    this.isEditing = true,
  });

  @override
  State<DynamicFieldWidget> createState() => _DynamicFieldWidgetState();
}

class _DynamicFieldWidgetState extends State<DynamicFieldWidget> {
  late TextEditingController _controller;
  bool _checkboxValue = false;
  String? _dropdownValue;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.value ?? '');
    _checkboxValue = widget.field.value == 'true';
    _dropdownValue = widget.field.value;
    _initializeDateAndTime();
  }

  void _initializeDateAndTime() {
    if (widget.field.value != null && widget.field.value!.isNotEmpty) {
      switch (widget.field.type) {
        case FieldType.date:
          try {
            _selectedDate = DateFormat('dd/MM/yyyy').parse(widget.field.value!);
          } catch (_) {}
          break;
        case FieldType.time:
          try {
            final time = DateFormat('HH:mm').parse(widget.field.value!);
            _selectedTime = TimeOfDay.fromDateTime(time);
          } catch (_) {}
          break;
        case FieldType.datetime:
          try {
            _selectedDate = DateTime.parse(widget.field.value!);
          } catch (_) {}
          break;
        default:
          break;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEditing) {
      return _buildDisplayWidget();
    }

    switch (widget.field.type) {
      case FieldType.text:
        return _buildTextWidget();
      case FieldType.multilineText:
      case FieldType.textarea:
        return _buildMultilineTextWidget();
      case FieldType.number:
        return _buildNumberWidget();
      case FieldType.currency:
        return _buildCurrencyWidget();
      case FieldType.percentage:
        return _buildPercentageWidget();
      case FieldType.email:
        return _buildEmailWidget();
      case FieldType.phone:
        return _buildPhoneWidget();
      case FieldType.url:
        return _buildUrlWidget();
      case FieldType.date:
        return _buildDateWidget();
      case FieldType.time:
        return _buildTimeWidget();
      case FieldType.datetime:
        return _buildDateTimeWidget();
      case FieldType.dropdown:
        return _buildDropdownWidget();
      case FieldType.checkbox:
        return _buildCheckboxWidget();
      case FieldType.radio:
        return _buildRadioWidget();
    }
  }

  Widget _buildDisplayWidget() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.field.name,
            style: AppTheme.labelMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getDisplayValue(),
            style: AppTheme.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayValue() {
    if (widget.field.value == null || widget.field.value!.isEmpty) {
      return 'Not specified';
    }

    switch (widget.field.type) {
      case FieldType.currency:
        return '\$${widget.field.value}';
      case FieldType.percentage:
        return '${widget.field.value}%';
      case FieldType.checkbox:
        return widget.field.value == 'true' ? 'Yes' : 'No';
      default:
        return widget.field.value!;
    }
  }

  InputDecoration _decoration({String? hint}) => InputDecoration(
        labelText: widget.field.name,
        hintText: hint ?? widget.field.placeholder,
        helperText: widget.field.hint,
        suffixText: widget.field.isRequired ? '*' : null,
      );

  String? _requiredValidator(String? value, {bool number = false}) {
    if (!widget.field.isRequired) return null;
    if (value == null || value.trim().isEmpty) {
      return '${widget.field.name} is required';
    }
    if (number && double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  Widget _buildTextWidget() {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(),
      maxLength: widget.field.maxLength,
      onChanged: (v) {
        widget.field.value = v;
        widget.onChanged?.call(v);
      },
      validator: _requiredValidator,
    );
  }

  Widget _buildMultilineTextWidget() {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(),
      maxLines: 3,
      maxLength: widget.field.maxLength,
      onChanged: (v) {
        widget.field.value = v;
        widget.onChanged?.call(v);
      },
      validator: _requiredValidator,
    );
  }

  Widget _buildNumberWidget() {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      onChanged: (v) {
        widget.field.value = v;
        widget.onChanged?.call(v);
      },
      validator: (v) => _requiredValidator(v, number: true),
    );
  }

  Widget _buildCurrencyWidget() {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(hint: widget.field.placeholder ?? '0.00').copyWith(prefixText: '\$'),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      onChanged: (v) {
        widget.field.value = v;
        widget.onChanged?.call(v);
      },
      validator: (v) => _requiredValidator(v, number: true),
    );
  }

  Widget _buildPercentageWidget() {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(hint: widget.field.placeholder ?? '0').copyWith(suffixText: '%'),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      onChanged: (v) {
        widget.field.value = v;
        widget.onChanged?.call(v);
      },
      validator: (v) => _requiredValidator(v, number: true),
    );
  }

  Widget _buildEmailWidget() {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(hint: widget.field.placeholder ?? 'example@email.com').copyWith(prefixIcon: const Icon(Icons.email)),
      keyboardType: TextInputType.emailAddress,
      onChanged: (v) {
        widget.field.value = v;
        widget.onChanged?.call(v);
      },
      validator: (v) {
        final base = _requiredValidator(v);
        if (base != null) return base;
        if (v != null && v.isNotEmpty && !RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(v)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneWidget() {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(hint: widget.field.placeholder ?? '+1 (555) 123-4567').copyWith(prefixIcon: const Icon(Icons.phone)),
      keyboardType: TextInputType.phone,
      onChanged: (v) {
        widget.field.value = v;
        widget.onChanged?.call(v);
      },
      validator: _requiredValidator,
    );
  }

  Widget _buildUrlWidget() {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(hint: widget.field.placeholder ?? 'https://example.com').copyWith(prefixIcon: const Icon(Icons.link)),
      keyboardType: TextInputType.url,
      onChanged: (v) {
        widget.field.value = v;
        widget.onChanged?.call(v);
      },
      validator: (v) {
        final base = _requiredValidator(v);
        if (base != null) return base;
        if (v != null && v.isNotEmpty && !RegExp(r'^https?:\/\/').hasMatch(v)) {
          return 'Please enter a valid URL';
        }
        return null;
      },
    );
  }

  Widget _buildDateWidget() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: _decoration(hint: widget.field.placeholder ?? 'Select date').copyWith(prefixIcon: const Icon(Icons.calendar_today)),
        child: Text(
          _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'Select date',
        ),
      ),
    );
  }

  Widget _buildTimeWidget() {
    return InkWell(
      onTap: _selectTime,
      child: InputDecorator(
        decoration: _decoration(hint: widget.field.placeholder ?? 'Select time').copyWith(prefixIcon: const Icon(Icons.access_time)),
        child: Text(
          _selectedTime != null ? _selectedTime!.format(context) : 'Select time',
        ),
      ),
    );
  }

  Widget _buildDateTimeWidget() {
    return InkWell(
      onTap: _selectDateTime,
      child: InputDecorator(
        decoration: _decoration(hint: widget.field.placeholder ?? 'Select date and time').copyWith(prefixIcon: const Icon(Icons.calendar_today)),
        child: Text(
          _selectedDate != null ? DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate!) : 'Select date and time',
        ),
      ),
    );
  }

  Widget _buildDropdownWidget() {
    final options = (widget.field.options?['options'] as List?)?.cast<String>() ?? <String>[];
    return DropdownButtonFormField<String>(
      value: _dropdownValue,
      decoration: _decoration(hint: widget.field.placeholder ?? 'Select option'),
      items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
      onChanged: (v) {
        setState(() {
          _dropdownValue = v;
        });
        widget.field.value = v;
        widget.onChanged?.call(v ?? '');
      },
      validator: (v) => _requiredValidator(v),
    );
  }

  Widget _buildCheckboxWidget() {
    return CheckboxListTile(
      title: Text(widget.field.name),
      subtitle: widget.field.hint != null ? Text(widget.field.hint!) : null,
      value: _checkboxValue,
      onChanged: (value) {
        setState(() {
          _checkboxValue = value ?? false;
        });
        final v = (value ?? false).toString();
        widget.field.value = v;
        widget.onChanged?.call(v);
      },
    );
  }

  Widget _buildRadioWidget() {
    final options = (widget.field.options?['options'] as List?)?.cast<String>() ?? <String>[];
    String? selectedValue = widget.field.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.name,
          style: AppTheme.labelMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        if (widget.field.hint != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.field.hint!,
            style: AppTheme.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
        const SizedBox(height: 8),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: selectedValue,
            onChanged: (v) {
              setState(() {
                selectedValue = v;
              });
              widget.field.value = v;
              widget.onChanged?.call(v ?? '');
            },
          );
        }).toList(),
      ],
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
      final formatted = DateFormat('dd/MM/yyyy').format(date);
      widget.field.value = formatted;
      widget.onChanged?.call(formatted);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
      final formatted = time.format(context);
      widget.field.value = formatted;
      widget.onChanged?.call(formatted);
    }
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
      );
      if (time != null) {
        final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        setState(() {
          _selectedDate = dateTime;
        });
        final formatted = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
        widget.field.value = formatted;
        widget.onChanged?.call(formatted);
      }
    }
  }
}
