import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_checkbox_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_color_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_custom_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_date_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_datetime_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_dropdown_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_file_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_multiselect_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_radio_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_rating_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_slider_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_switch_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_text_field_widget.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_time_field_widget.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

/// Form field builder that delegates to atomic field widgets
class VooFormFieldBuilder extends StatelessWidget {
  final VooFormField field;
  final VooFormController controller;
  final VooFormConfig? config;
  final bool showError;
  final EdgeInsetsGeometry? padding;

  const VooFormFieldBuilder({
    super.key,
    required this.field,
    required this.controller,
    this.config,
    this.showError = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (!field.visible) {
      return const SizedBox.shrink();
    }

    // Use cascaded config with floating labels as default
    final formConfig = config ??
        const VooFormConfig(
          labelPosition: LabelPosition.floating,
          fieldVariant: FieldVariant.outlined,
          showFieldIcons: true,
          showRequiredIndicator: true,
        );

    Widget fieldWidget;
    final fieldOptions = VooFieldOptions(
      labelPosition: formConfig.labelPosition,
      fieldVariant: formConfig.fieldVariant,
    );
    final error = controller.errors[field.id];

    // Delegate to appropriate atomic widget based on field type
    switch (field.type) {
      case VooFieldType.text:
      case VooFieldType.number:
      case VooFieldType.email:
      case VooFieldType.password:
      case VooFieldType.phone:
      case VooFieldType.url:
      case VooFieldType.multiline:
        fieldWidget = VooTextFieldWidget(
          field: field,
          controller: controller,
          config: formConfig,
          showError: showError,
          focusNode: controller.getFocusNode(field.id),
          onEditingComplete: () => controller.focusNextField(field.id),
          onSubmitted: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onSubmit) {
              controller.validateField(field.id);
            }
          },
        );
        break;

      case VooFieldType.date:
        fieldWidget = VooDateFieldWidget(
          field: field,
          options: fieldOptions,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.time:
        fieldWidget = VooTimeFieldWidget(
          field: field,
          options: fieldOptions,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.dateTime:
        fieldWidget = VooDateTimeFieldWidget(
          field: field,
          options: fieldOptions,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.boolean:
        fieldWidget = VooSwitchFieldWidget(
          field: field,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.checkbox:
        fieldWidget = VooCheckboxFieldWidget(
          field: field,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.dropdown:
        fieldWidget = VooDropdownFieldWidget(
          field: field,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.radio:
        fieldWidget = VooRadioFieldWidget(
          field: field,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.slider:
        fieldWidget = VooSliderFieldWidget(
          field: field,
          options: fieldOptions,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.multiSelect:
        fieldWidget = VooMultiSelectFieldWidget(
          field: field,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.file:
        fieldWidget = VooFileFieldWidget(
          field: field,
          options: fieldOptions,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.color:
        fieldWidget = VooColorFieldWidget(
          field: field,
          options: fieldOptions,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.rating:
        fieldWidget = VooRatingFieldWidget(
          field: field,
          options: fieldOptions,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;

      case VooFieldType.custom:
        fieldWidget = VooCustomFieldWidget(
          field: field,
          options: fieldOptions,
          onChanged: (value) {
            controller.setValue(field.id, value);
            if (controller.form.validationMode == FormValidationMode.onChange) {
              controller.validateField(field.id);
            }
          },
          error: error,
          showError: showError,
        );
        break;
    }

    // Apply padding if specified
    if (padding != null || formConfig.padding != null) {
      fieldWidget = Padding(
        padding: padding ?? formConfig.padding!,
        child: fieldWidget,
      );
    }

    return fieldWidget;
  }
}
