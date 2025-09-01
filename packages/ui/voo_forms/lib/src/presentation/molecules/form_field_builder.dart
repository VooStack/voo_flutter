import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_widget.dart';

/// Form field builder that delegates to atomic field widgets
class VooFormFieldBuilder extends StatelessWidget {
  final VooFormField field;
  final VooFormController controller;
  final VooFormConfig? config;
  final bool showError;
  final EdgeInsetsGeometry? padding;
  final bool isEditable;

  const VooFormFieldBuilder({
    super.key,
    required this.field,
    required this.controller,
    this.config,
    this.showError = true,
    this.padding,
    this.isEditable = true,
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
        );

    // Create field options from config
    final fieldOptions = VooFieldOptions(
      labelPosition: formConfig.labelPosition,
      fieldVariant: formConfig.fieldVariant,
    );
    final error = controller.errors[field.id];

    // Use VooFieldWidget which handles label positioning correctly
    Widget fieldWidget = VooFieldWidget(
      field: field,
      options: fieldOptions,
      isEditable: isEditable,
      onChanged: (dynamic value) {
        controller.setValue(field.id, value);
        if (controller.form.validationMode == FormValidationMode.onChange) {
          controller.validateField(field.id);
        }
      },
      onEditingComplete: field.type == VooFieldType.text ||
              field.type == VooFieldType.number ||
              field.type == VooFieldType.email ||
              field.type == VooFieldType.password ||
              field.type == VooFieldType.phone ||
              field.type == VooFieldType.url ||
              field.type == VooFieldType.multiline
          ? () => controller.focusNextField(field.id)
          : null,
      onSubmitted: field.type == VooFieldType.text ||
              field.type == VooFieldType.number ||
              field.type == VooFieldType.email ||
              field.type == VooFieldType.password ||
              field.type == VooFieldType.phone ||
              field.type == VooFieldType.url ||
              field.type == VooFieldType.multiline
          ? (value) {
              controller.setValue(field.id, value);
              if (controller.form.validationMode ==
                  FormValidationMode.onSubmit) {
                controller.validateField(field.id);
              }
            }
          : null,
      focusNode: controller.getFocusNode(field.id),
      error: error,
      showError: showError,
    );

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
