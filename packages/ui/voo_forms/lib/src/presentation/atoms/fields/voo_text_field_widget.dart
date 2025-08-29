import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_text_form_field.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Atomic text field widget that handles label positioning
class VooTextFieldWidget extends StatelessWidget {
  final VooFormField field;
  final VooFormController controller;
  final VooFormConfig config;
  final bool showError;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  const VooTextFieldWidget({
    super.key,
    required this.field,
    required this.controller,
    required this.config,
    this.showError = true,
    this.focusNode,
    this.onEditingComplete,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    // Prepare the text field with proper decoration
    final preparedField = _prepareField(context);
    final decoration = _getDecoration(context);
    
    final textField = VooTextFormField(
      field: preparedField,
      controller: controller.getTextController(field.id),
      focusNode: focusNode,
      onChanged: (value) => controller.setValue(field.id, value),
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      error: controller.getError(field.id),
      showError: showError && config.errorDisplayMode != ErrorDisplayMode.none,
      decoration: decoration,
    );
    
    // Handle label position
    if (config.labelPosition == LabelPosition.above && field.label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LabelWidget(
            label: field.label!,
            required: field.required,
            config: config,
          ),
          const SizedBox(height: 8),
          textField,
        ],
      );
    }
    
    return textField;
  }
  
  VooFormField _prepareField(BuildContext context) {
    // Don't include label in field if position is above or hidden
    if (config.labelPosition == LabelPosition.above || 
        config.labelPosition == LabelPosition.hidden) {
      return field.copyWith(label: null);
    }
    
    // Add required indicator for floating labels
    String? label = field.label;
    if (label != null && field.required && config.showRequiredIndicator) {
      label = '$label ${config.requiredIndicator}';
    }
    
    return field.copyWith(
      label: label,
      padding: config.getFieldPadding(),
    );
  }
  
  InputDecoration _getDecoration(BuildContext context) {
    final theme = Theme.of(context);
    
    // Only include label for floating position
    final includeLabel = config.labelPosition == LabelPosition.floating;
    
    String? labelText;
    if (includeLabel && field.label != null) {
      labelText = field.label;
      if (field.required && config.showRequiredIndicator) {
        labelText = '$labelText ${config.requiredIndicator}';
      }
    }
    
    final baseDecoration = InputDecoration(
      labelText: includeLabel ? labelText : null,  // Explicitly control label
      hintText: field.hint,
      helperText: field.helper,
      errorText: showError ? controller.getError(field.id) : null,
      prefixIcon: field.prefixIcon != null && config.showFieldIcons 
          ? Icon(field.prefixIcon) 
          : null,
      suffixIcon: field.suffixIcon != null ? Icon(field.suffixIcon) : null,
      contentPadding: config.getFieldPadding(),
    );
    
    // Apply field variant styling
    return _applyVariantStyling(baseDecoration, theme);
  }
  
  InputDecoration _applyVariantStyling(InputDecoration decoration, ThemeData theme) {
    switch (config.fieldVariant) {
      case FieldVariant.filled:
        return decoration.copyWith(
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        );
        
      case FieldVariant.underlined:
        return decoration.copyWith(
          border: const UnderlineInputBorder(),
        );
        
      case FieldVariant.ghost:
        return decoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
        );
        
      case FieldVariant.outlined:
        return decoration;
        
      case FieldVariant.rounded:
        return decoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color: theme.colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
        );
        
      case FieldVariant.sharp:
        return decoration.copyWith(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: theme.colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
        );
    }
  }
}

/// Label widget for fields with above positioning
class _LabelWidget extends StatelessWidget {
  final String label;
  final bool required;
  final VooFormConfig config;
  
  const _LabelWidget({
    required this.label,
    required this.required,
    required this.config,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    String labelText = label;
    if (required && config.showRequiredIndicator) {
      labelText = '$labelText ${config.requiredIndicator}';
    }
    
    return Text(
      labelText,
      style: config.getLabelStyle(context) ?? theme.textTheme.bodyMedium,
    );
  }
}