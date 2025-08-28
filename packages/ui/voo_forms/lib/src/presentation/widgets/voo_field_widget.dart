import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_checkbox_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_date_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_dropdown_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_radio_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_slider_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_switch_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_text_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/voo_time_form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Widget that renders a form field based on its type and options
/// This widget delegates to atomic widgets based on field type
/// Following atomic design principles - no _buildXXX methods
class VooFieldWidget extends StatelessWidget {
  final VooFormField field;
  final VooFieldOptions? options;
  final ValueChanged<dynamic>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<dynamic>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? error;
  final bool showError;
  final bool autofocus;

  const VooFieldWidget({
    super.key,
    required this.field,
    this.options,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.controller,
    this.error,
    this.showError = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOptions = options ?? VooFieldOptions.material;
    
    // Apply label if needed for non-floating positions
    Widget fieldWidget = _buildFieldByType(context, effectiveOptions);
    
    // Wrap with label if label position requires it
    if (field.label != null && 
        effectiveOptions.labelPosition == LabelPosition.above ||
        effectiveOptions.labelPosition == LabelPosition.left) {
      fieldWidget = _wrapWithLabel(context, fieldWidget, effectiveOptions);
    }
    
    return fieldWidget;
  }
  
  Widget _buildFieldByType(BuildContext context, VooFieldOptions effectiveOptions) {
    switch (field.type) {
      case VooFieldType.text:
      case VooFieldType.email:
      case VooFieldType.password:
      case VooFieldType.phone:
      case VooFieldType.url:
      case VooFieldType.number:
      case VooFieldType.multiline:
        return VooTextFormField(
          field: field,
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          error: error,
          showError: showError,
          autoFocus: autofocus,
        );
        
      case VooFieldType.boolean:
        return VooSwitchFormField(
          field: field,
          onChanged: onChanged,
        );
        
      case VooFieldType.checkbox:
        return VooCheckboxFormField(
          field: field,
          onChanged: onChanged,
        );
        
      case VooFieldType.dropdown:
        return VooDropdownFormField(
          field: field,
          onChanged: onChanged,
        );
        
      case VooFieldType.radio:
        return VooRadioFormField(
          field: field,
          onChanged: onChanged,
        );
        
      case VooFieldType.slider:
        return VooSliderFormField(
          field: field,
          options: effectiveOptions,
          onChanged: onChanged != null 
              ? (value) => onChanged!(value)
              : null,
          error: error,
          showError: showError,
        );
        
      case VooFieldType.date:
        return VooDateFormField(
          field: field,
          options: effectiveOptions,
          onChanged: onChanged != null 
              ? (value) => onChanged!(value)
              : null,
          onTap: onTap,
          focusNode: focusNode,
          controller: controller,
          error: error,
          showError: showError,
        );
        
      case VooFieldType.time:
        return VooTimeFormField(
          field: field,
          options: effectiveOptions,
          onChanged: onChanged != null 
              ? (value) => onChanged!(value)
              : null,
          onTap: onTap,
          focusNode: focusNode,
          controller: controller,
          error: error,
          showError: showError,
        );
        
      default:
        // Fallback for unsupported types
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            'Unsupported field type: ${field.type}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
    }
  }
  
  Widget _wrapWithLabel(
    BuildContext context, 
    Widget fieldWidget,
    VooFieldOptions options,
  ) {
    final theme = Theme.of(context);
    final labelWidget = Text(
      field.label!,
      style: options.textStyle ?? theme.textTheme.bodyMedium,
    );
    
    if (options.labelPosition == LabelPosition.left) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: labelWidget,
          ),
          const SizedBox(width: 16),
          Expanded(child: fieldWidget),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWidget,
          const SizedBox(height: 8),
          fieldWidget,
        ],
      );
    }
  }
}