import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    super.layout,
    super.isHidden,
    super.minWidth,
    super.maxWidth,
    super.minHeight,
    super.maxHeight,
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
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();
    
    Widget textInput = VooTextInput(
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
    
    // Apply height constraints to the input widget
    textInput = applyInputHeightConstraints(textInput);

    // Compose with label, helper, error and actions using base class methods
    return buildWithLabel(
      context,
      buildWithHelper(
        context,
        buildWithError(
          context,
          buildWithActions(
            context,
            textInput,
          ),
        ),
      ),
    );
  }
}
