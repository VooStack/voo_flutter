import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Atomic widget for datetime form field
class VooDateTimeFieldWidget extends StatelessWidget {
  final VooFormField field;
  final VooFieldOptions options;
  final ValueChanged<DateTime?>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? error;
  final bool showError;

  const VooDateTimeFieldWidget({
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
    final currentValue = field.value as DateTime?;
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
    
    // Create controller if not provided
    final effectiveController = controller ?? 
        TextEditingController(
          text: currentValue != null ? dateFormat.format(currentValue) : '',
        );
    
    return TextFormField(
      controller: effectiveController,
      focusNode: focusNode,
      readOnly: true,
      enabled: field.enabled,
      decoration: _buildDecoration(context),
      style: options.textStyle ?? theme.textTheme.bodyLarge,
      onTap: field.enabled ? () async {
        // First pick date
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: currentValue ?? DateTime.now(),
          firstDate: field.minDate ?? DateTime(1900),
          lastDate: field.maxDate ?? DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: theme,
              child: child!,
            );
          },
        );
        
        if (pickedDate != null && context.mounted) {
          // Then pick time
          final pickedTime = await showTimePicker(
            context: context,
            initialTime: currentValue != null 
                ? TimeOfDay.fromDateTime(currentValue)
                : TimeOfDay.now(),
            builder: (context, child) {
              return Theme(
                data: theme,
                child: child!,
              );
            },
          );
          
          if (pickedTime != null && context.mounted) {
            final combined = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            effectiveController.text = dateFormat.format(combined);
            onChanged?.call(combined);
            field.onChanged?.call(combined);
          }
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
        hintText: field.hint ?? 'Select date and time',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.date_range),
      );
    } else if (options.labelPosition == LabelPosition.placeholder) {
      decoration = InputDecoration(
        hintText: field.label ?? field.hint ?? 'Select date and time',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.date_range),
      );
    } else {
      decoration = InputDecoration(
        hintText: field.hint ?? 'Select date and time',
        errorText: showError && error != null ? error : null,
        helperText: field.helper,
        prefixIcon: field.prefixIcon != null ? Icon(field.prefixIcon) : null,
        suffixIcon: Icon(field.suffixIcon ?? Icons.date_range),
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