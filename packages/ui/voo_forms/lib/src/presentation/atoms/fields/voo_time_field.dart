import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/date_field_helpers.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Time form field widget
class VooTimeFieldWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use value if available, otherwise fall back to initialValue
    final currentValue = (field.value ?? field.initialValue) as TimeOfDay?;
    
    // Create controller if not provided
    final effectiveController = controller ?? 
        TextEditingController(
          text: currentValue != null ? currentValue.format(context) : '',
        );
    
    return TextFormField(
      controller: effectiveController,
      focusNode: focusNode,
      readOnly: true,
      enabled: field.enabled,
      decoration: _decorationBuilder.build(
        context: context,
        field: field,
        options: options,
        error: error,
        showError: showError,
      ),
      style: options.textStyle ?? theme.textTheme.bodyLarge,
      onTap: field.enabled ? () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: currentValue ?? TimeOfDay.now(),
          builder: (context, child) => Theme(
            data: theme,
            child: child!,
          ),
        );
        
        if (picked != null && context.mounted) {
          effectiveController.text = picked.format(context);
          onChanged?.call(picked);
        }
        onTap?.call();
      } : null,
    );
  }
}