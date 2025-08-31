import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/date_field_helpers.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Time form field widget
class VooTimeFieldWidget extends StatefulWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<TimeOfDay?>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? error;
  final bool showError;
  
  // Helper instance for building decorations
  static const _decorationBuilder = TimeFieldDecorationBuilder();

  const VooTimeFieldWidget({
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
  State<VooTimeFieldWidget> createState() => _VooTimeFieldWidgetState();
}

class _VooTimeFieldWidgetState extends State<VooTimeFieldWidget> {
  late TimeOfDay? _value;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _value = (widget.field.value ?? widget.field.initialValue) as TimeOfDay?;
    _controller = widget.controller ?? TextEditingController(
      text: _value != null ? _value!.format(context) : '',
    );
  }

  @override
  void didUpdateWidget(VooTimeFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.field.value != widget.field.value) {
      _value = (widget.field.value ?? widget.field.initialValue) as TimeOfDay?;
      if (widget.controller == null && context.mounted) {
        _controller.text = _value != null ? _value!.format(context) : '';
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
      decoration: VooTimeFieldWidget._decorationBuilder.build(
        context: context,
        field: widget.field,
        options: widget.options,
        error: widget.error,
        showError: widget.showError,
      ),
      style: widget.options.textStyle ?? theme.textTheme.bodyLarge,
      onTap: widget.field.enabled ? () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: _value ?? TimeOfDay.now(),
          builder: (context, child) => Theme(
            data: theme,
            child: child!,
          ),
        );
        
        if (picked != null && context.mounted) {
          setState(() {
            _value = picked;
            _controller.text = picked.format(context);
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
      } : null,
    );
  }
}