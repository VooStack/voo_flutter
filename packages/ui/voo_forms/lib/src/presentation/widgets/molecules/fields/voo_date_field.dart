import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/config/voo_field_options.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/date_field_helpers.dart';

/// Date form field widget
class VooDateFieldWidget extends StatefulWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<DateTime?>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? error;
  final bool showError;

  // Helper instance for building decorations
  static const _decorationBuilder = DateFieldDecorationBuilder();

  const VooDateFieldWidget({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.controller,
    this.error,
    this.showError = true,
  });

  @override
  State<VooDateFieldWidget> createState() => _VooDateFieldWidgetState();
}

class _VooDateFieldWidgetState extends State<VooDateFieldWidget> {
  late DateTime? _value;
  late TextEditingController _controller;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _value = (widget.field.value ?? widget.field.initialValue) as DateTime?;
    _controller = widget.controller ??
        TextEditingController(
          text: _value != null ? _dateFormat.format(_value!) : '',
        );
  }

  @override
  void didUpdateWidget(VooDateFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.field.value != widget.field.value) {
      _value = (widget.field.value ?? widget.field.initialValue) as DateTime?;
      if (widget.controller == null) {
        _controller.text = _value != null ? _dateFormat.format(_value!) : '';
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: _controller,
      focusNode: widget.focusNode,
      readOnly: true,
      enabled: widget.field.enabled,
      decoration: VooDateFieldWidget._decorationBuilder.build(
        context: context,
        field: widget.field,
        options: widget.options,
        error: widget.error,
        showError: widget.showError,
      ),
      style: widget.options.textStyle ?? theme.textTheme.bodyLarge,
      onTap: widget.field.enabled
          ? () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _value ?? DateTime.now(),
                firstDate: widget.field.minDate ?? DateTime(1900),
                lastDate: widget.field.maxDate ?? DateTime(2100),
                builder: (context, child) => Theme(
                  data: theme,
                  child: child!,
                ),
              );

              if (picked != null) {
                setState(() {
                  _value = picked;
                  _controller.text = _dateFormat.format(picked);
                });
                widget.onChanged?.call(picked);
                // Safely call field.onChanged with type checking
                try {
                  final dynamic dynField = widget.field;
                  final callback = dynField.onChanged;
                  if (callback != null) {
                    callback(picked);
                  }
                } catch (_) {
                  // Silently ignore type casting errors
                }
              }
              widget.onTap?.call();
            }
          : null,
    );
  }
}
