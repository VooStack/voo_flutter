import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/field_label_wrapper.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_checkbox_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_date_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_dropdown_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_radio_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_slider_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_switch_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_text_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_time_field_widget.dart';
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

    // Get the appropriate field widget based on type
    Widget fieldWidget = _getFieldWidget(context, effectiveOptions);

    // Wrap with label if label position requires it
    if (field.label != null &&
        effectiveOptions.labelPosition != null &&
        (effectiveOptions.labelPosition == LabelPosition.above ||
            effectiveOptions.labelPosition == LabelPosition.left)) {
      fieldWidget = FieldLabelWrapper(
        label: field.label!,
        labelPosition: effectiveOptions.labelPosition!,
        textStyle: effectiveOptions.textStyle,
        child: fieldWidget,
      );
    }

    return fieldWidget;
  }

  /// Returns the appropriate field widget based on field type
  /// This is a factory method that delegates to specific field widgets
  Widget _getFieldWidget(
    BuildContext context,
    VooFieldOptions effectiveOptions,
  ) {
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
          options: effectiveOptions,
          controller: controller,
          focusNode: focusNode,
          onChanged: (String value) {
            onChanged?.call(value);
            // Don't call field.onChanged here - let the form controller handle it
          },
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted != null ? (value) => onSubmitted!(value) : null,
          error: error,
          showError: showError,
          autoFocus: autofocus,
        );

      case VooFieldType.boolean:
        return VooSwitchFieldWidget(
          field: field,
          options: effectiveOptions,
          onChanged: (bool? value) {
            onChanged?.call(value);
            // Don't call field.onChanged here - let the form controller handle it
          },
        );

      case VooFieldType.checkbox:
        return VooCheckboxFieldWidget(
          field: field,
          options: effectiveOptions,
          onChanged: (bool? value) {
            onChanged?.call(value);
            // Don't call field.onChanged here - let the form controller handle it
          },
        );

      case VooFieldType.dropdown:
        // Create dropdown with dynamic type to handle all field types
        // Create a wrapper callback that handles both widget onChanged and field onChanged
        void handleChange(dynamic value) {
          // Call widget's onChanged
          onChanged?.call(value);
          
          // Safely invoke field.onChanged using reflection to avoid type casting
          try {
            final fieldOnChanged = field.onChanged;
            if (fieldOnChanged != null) {
              // Create a Function.apply call to invoke the callback without type checking
              Function.apply(fieldOnChanged, [value]);
            }
          } catch (_) {
            // If Function.apply fails, field.onChanged is incompatible
            // This is expected when types don't match, so we silently ignore
          }
        }

        return VooDropdownFieldWidget<dynamic>(
          field: field,
          options: effectiveOptions,
          onChanged: handleChange,
        );

      case VooFieldType.radio:
        return VooRadioFieldWidget(
          field: field,
          options: effectiveOptions,
          onChanged: (value) {
            onChanged?.call(value);
            // Don't call field.onChanged here - let the form controller handle it
          },
        );

      case VooFieldType.slider:
        return VooSliderFieldWidget(
          field: field,
          options: effectiveOptions,
          onChanged: (double value) {
            onChanged?.call(value);
            // Don't call field.onChanged here - let the form controller handle it
          },
          error: error,
          showError: showError,
        );

      case VooFieldType.date:
        return VooDateFieldWidget(
          field: field,
          options: effectiveOptions,
          onChanged: (DateTime? value) {
            onChanged?.call(value);
            // Don't call field.onChanged here - let the form controller handle it
          },
          onTap: onTap,
          focusNode: focusNode,
          controller: controller,
          error: error,
          showError: showError,
        );

      case VooFieldType.time:
        return VooTimeFieldWidget(
          field: field,
          options: effectiveOptions,
          onChanged: (TimeOfDay? value) {
            onChanged?.call(value);
            // Don't call field.onChanged here - let the form controller handle it
          },
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

}
