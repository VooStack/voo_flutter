import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/voo_text_field_widget.dart';
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
    final formConfig = config ?? const VooFormConfig(
      labelPosition: LabelPosition.floating,
      fieldVariant: FieldVariant.outlined,
      showFieldIcons: true,
      showRequiredIndicator: true,
    );

    Widget fieldWidget;
    
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
        
      // TODO: Create atomic widgets for other field types
      default:
        fieldWidget = Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            'Field type not yet implemented: ${field.type}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
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