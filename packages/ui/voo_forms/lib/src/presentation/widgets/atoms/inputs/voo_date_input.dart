import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Atomic date input widget that displays formatted date and handles date picking
class VooDateInput extends StatefulWidget {
  final DateTime? initialValue;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final String? placeholder;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final bool readOnly;
  final InputDecoration decoration;
  final DateFormat? dateFormat;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const VooDateInput({
    super.key,
    this.initialValue,
    this.value,
    this.onChanged,
    this.placeholder,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.readOnly = false,
    required this.decoration,
    this.dateFormat,
    this.focusNode,
    this.controller,
  });

  @override
  State<VooDateInput> createState() => _VooDateInputState();
}

class _VooDateInputState extends State<VooDateInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  DateTime? _selectedDate;
  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _dateFormat = widget.dateFormat ?? DateFormat('MM/dd/yyyy');
    _selectedDate = widget.value ?? widget.initialValue;
    _updateController();
  }

  @override
  void didUpdateWidget(VooDateInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedDate = widget.value;
      _updateController();
    }
  }

  void _updateController() {
    if (_selectedDate != null) {
      _controller.text = _dateFormat.format(_selectedDate!);
    } else {
      _controller.clear();
    }
  }

  Future<void> _selectDate() async {
    if (!widget.enabled || widget.readOnly) return;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _updateController();
      });
      widget.onChanged?.call(pickedDate);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: _controller,
    focusNode: _focusNode,
    decoration: widget.decoration.copyWith(
      hintText: widget.placeholder,
      suffixIcon:
          widget.decoration.suffixIcon ??
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: widget.enabled && !widget.readOnly ? _selectDate : null),
    ),
    readOnly: true,
    enabled: widget.enabled,
    onTap: widget.enabled && !widget.readOnly ? _selectDate : null,
  );
}
