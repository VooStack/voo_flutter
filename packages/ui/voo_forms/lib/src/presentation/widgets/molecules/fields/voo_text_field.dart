import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/validation_rule.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_text_input.dart';

/// Text field molecule that composes atoms to create a complete text input field
/// Extends VooFieldBase to inherit all common field functionality
class VooTextField extends VooFieldBase<String> {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool expands;
  final TextCapitalization textCapitalization;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  const VooTextField({
    super.key,
    required super.name,
    super.label,
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
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.expands = false,
    this.textCapitalization = TextCapitalization.none,
    this.onEditingComplete,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final textInput = VooTextInput(
      controller: controller,
      focusNode: focusNode,
      initialValue: value ?? initialValue,
      placeholder: placeholder,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      maxLines: expands ? null : maxLines,
      minLines: expands ? null : minLines,
      maxLength: maxLength,
      expands: expands,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      decoration: getInputDecoration(context),
    );

    // Compose with helper and error using base class methods
    return buildWithHelper(
      context,
      buildWithError(
        context,
        buildWithActions(
          context,
          textInput,
        ),
      ),
    );
  }

  /// Factory constructor to create from VooFormField
  factory VooTextField.fromFormField(VooFormField field) => VooTextField(
        name: field.name,
        label: field.label,
        hint: field.hint,
        helper: field.helper,
        placeholder: field.placeholder,
        initialValue: field.initialValue?.toString(),
        value: field.value?.toString(),
        required: field.required,
        enabled: field.enabled,
        readOnly: field.readOnly,
        validators: field.validators is List<VooValidationRule<String>> ? field.validators as List<VooValidationRule<String>> : null,
        onChanged: field.onChanged != null ? (value) => field.onChanged!(value) : null,
        actions: field.actions,
        prefixIcon: field.prefixIcon is IconData ? Icon(field.prefixIcon) : field.prefix,
        suffixIcon: field.suffixIcon is IconData ? Icon(field.suffixIcon) : field.suffix,
        maxLines: field.maxLines,
        maxLength: field.maxLength,
        inputFormatters: field.inputFormatters,
        textCapitalization: field.textCapitalization ?? TextCapitalization.none,
        textInputAction: field.textInputAction ?? TextInputAction.next,
      );
}
