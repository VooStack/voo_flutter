import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_checkbox_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_date_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_dropdown_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_radio_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_slider_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_switch_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_text_form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_time_field_widget.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Factory class for creating field widgets based on field type
/// Follows atomic design and clean architecture principles
class FieldWidgetFactory {
  const FieldWidgetFactory();

  /// Creates the appropriate field widget based on field type
  Widget create({
    required BuildContext context,
    required VooFormField field,
    required VooFieldOptions options,
    ValueChanged<dynamic>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<dynamic>? onSubmitted,
    VoidCallback? onTap,
    FocusNode? focusNode,
    TextEditingController? controller,
    String? error,
    bool showError = true,
    bool autofocus = false,
  }) {
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
          options: options,
          controller: controller,
          focusNode: focusNode,
          onChanged: (String value) {
            onChanged?.call(value);
          },
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted != null ? (value) => onSubmitted(value) : null,
          error: error,
          showError: showError,
          autoFocus: autofocus,
        );

      case VooFieldType.boolean:
        return VooSwitchFieldWidget(
          field: field,
          options: options,
          onChanged: (bool? value) {
            onChanged?.call(value);
          },
        );

      case VooFieldType.checkbox:
        return VooCheckboxFieldWidget(
          field: field,
          options: options,
          onChanged: (bool? value) {
            onChanged?.call(value);
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
          options: options,
          onChanged: handleChange,
        );

      case VooFieldType.radio:
        return VooRadioFieldWidget(
          field: field,
          options: options,
          onChanged: (value) {
            onChanged?.call(value);
          },
        );

      case VooFieldType.slider:
        return VooSliderFieldWidget(
          field: field,
          options: options,
          onChanged: (double value) {
            onChanged?.call(value);
          },
          error: error,
          showError: showError,
        );

      case VooFieldType.date:
        return VooDateFieldWidget(
          field: field,
          options: options,
          onChanged: (DateTime? value) {
            onChanged?.call(value);
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
          options: options,
          onChanged: (TimeOfDay? value) {
            onChanged?.call(value);
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