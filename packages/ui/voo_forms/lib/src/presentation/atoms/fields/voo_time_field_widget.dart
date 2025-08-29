import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Atomic widget for time form field
class VooTimeFieldWidget extends StatelessWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<TimeOfDay?>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? error;
  final bool showError;

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
      decoration: _buildDecoration(context),
      style: options.textStyle ?? theme.textTheme.bodyLarge,
      onTap: field.enabled ? () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: currentValue ?? TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: theme,
              child: child!,
            );
          },
        );
        
        if (picked != null && context.mounted) {
          effectiveController.text = picked.format(context);
          onChanged?.call(picked);
        }
        onTap?.call();
      } : null,
    );
  }
  
  InputDecoration _buildDecoration(BuildContext context) {
    final theme = Theme.of(context);
    
    // Build base decoration based on label position
    InputDecoration decoration;
    
    if (options.labelPosition == LabelPosition.floating) {
      decoration = InputDecoration(
        labelText: field.label,
        hintText: field.hint ?? 'Select time',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.access_time),
      );
    } else if (options.labelPosition == LabelPosition.placeholder) {
      decoration = InputDecoration(
        hintText: field.label ?? field.hint ?? 'Select time',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.access_time),
      );
    } else {
      // For above, left, or hidden positions, don't include label
      // as VooFieldWidget handles it externally
      decoration = InputDecoration(
        hintText: field.hint ?? 'Select time',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.access_time),
      );
    }
    
    // Apply field variant styling
    switch (options.fieldVariant) {
      case FieldVariant.filled:
        return decoration.copyWith(
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        );
      case FieldVariant.underlined:
        return decoration.copyWith(
          border: const UnderlineInputBorder(),
        );
      case FieldVariant.ghost:
        return decoration.copyWith(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
          ),
        );
      case FieldVariant.rounded:
        return decoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        );
      case FieldVariant.sharp:
        return decoration.copyWith(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
        );
      default:
        return decoration;
    }
  }
}