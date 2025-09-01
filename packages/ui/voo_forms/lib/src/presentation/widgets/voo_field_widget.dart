import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/field_label_wrapper.dart';
import 'package:voo_forms/src/presentation/molecules/field_widget_factory.dart';
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
  final bool isEditable;

  // Factory instance for creating field widgets
  static const _factory = FieldWidgetFactory();

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
    this.isEditable = true,
  });


  @override
  Widget build(BuildContext context) {
    final effectiveOptions = options ?? VooFieldOptions.material;

    // Use factory to create the appropriate field widget
    Widget fieldWidget = _factory.create(
      context: context,
      field: field,
      options: effectiveOptions,
      isEditable: isEditable,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      controller: controller,
      error: error,
      showError: showError,
      autofocus: autofocus,
    );

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
}
