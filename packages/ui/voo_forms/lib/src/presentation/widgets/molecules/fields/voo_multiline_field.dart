import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_layout.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_text_field.dart';

/// Multiline text field molecule - extends VooTextField with multiline defaults
/// Automatically configures for multiline text input
class VooMultilineField extends VooTextField {
  const VooMultilineField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.hint,
    super.helper,
    super.placeholder,
    super.initialValue,
    super.value,
    super.required,
    super.enabled,
    super.readOnly,
    super.validators,
    super.onChanged,
    super.actions,
    super.prefixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    super.layout = VooFieldLayout.wide, // Multiline fields default to full width
    super.controller,
    super.focusNode,
    super.inputFormatters,
    super.onEditingComplete,
    super.onSubmitted,
    super.autofocus,
    int? maxLines,
    int? minLines,
    super.maxLength,
  }) : super(
          maxLines: maxLines ?? 5,
          minLines: minLines ?? 3,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          expands: false,
        );
}
