import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_text_input.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

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

    final effectiveReadOnly = getEffectiveReadOnly(context);

    // Get the form controller from scope if available
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    
    // If read-only, show VooReadOnlyField for better UX
    if (effectiveReadOnly) {
      final String displayValue = initialValue ?? '';
      
      Widget readOnlyContent = VooReadOnlyField(
        value: displayValue,
        icon: prefixIcon ?? suffixIcon,
      );
      
      // Apply standard field building pattern
      readOnlyContent = buildWithHelper(context, readOnlyContent);
      readOnlyContent = buildWithError(context, readOnlyContent);
      readOnlyContent = buildWithLabel(context, readOnlyContent);
      readOnlyContent = buildWithActions(context, readOnlyContent);
      
      return buildFieldContainer(context, readOnlyContent);
    }
    
    // Use provided controller or get one from form controller if available
    TextEditingController? effectiveController = controller;
    if (effectiveController == null && formController != null) {
      effectiveController = formController.registerTextController(name, initialText: initialValue);
    }
    
    // Use provided focus node or get one from form controller if available
    FocusNode? effectiveFocusNode = focusNode;
    if (effectiveFocusNode == null && formController != null) {
      effectiveFocusNode = formController.getFocusNode(name);
    }

    // Create wrapped onChanged that updates both controller and calls user callback
    void handleChanged(String? value) {
      // Update form controller if available (for non-controller based updates)
      // If there's an effectiveController, it already has a listener that updates the form controller
      if (formController != null && effectiveController == null) {
        formController.setValue(name, value, validate: true);
      }
      // Call user's onChanged if provided
      onChanged?.call(value);
    }

    Widget textInput = VooTextInput(
      controller: effectiveController,
      focusNode: effectiveFocusNode,
      initialValue: effectiveController == null ? initialValue : null,
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
      onChanged: handleChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      enabled: enabled && !effectiveReadOnly,
      readOnly: effectiveReadOnly,
      autofocus: autofocus,
      decoration: getInputDecoration(context),
    );

    // Apply height constraints to the input widget
    textInput = applyInputHeightConstraints(textInput);
    
    // Compose with label, helper, error and actions using base class methods
    return buildFieldContainer(
      context,
      buildWithLabel(
        context,
        buildWithError(
          context,
          buildWithHelper(
            context,
            buildWithActions(
              context,
              textInput,
            ),
          ),
        ),
      ),
    );
  }

  @override
  VooTextField copyWith({
    String? initialValue,
    String? label,
    VooFieldLayout? layout,
    String? name,
    bool? readOnly,
  }) =>
      VooTextField(
        key: key,
        name: name ?? this.name,
        label: label ?? this.label,
        labelWidget: labelWidget,
        hint: hint,
        helper: helper,
        placeholder: placeholder,
        initialValue: initialValue ?? this.initialValue,
        enabled: enabled,
        readOnly: readOnly ?? this.readOnly,
        validators: validators,
        onChanged: onChanged,
        actions: actions,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        gridColumns: gridColumns,
        error: error,
        showError: showError,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: autocorrect,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        expands: expands,
        textCapitalization: textCapitalization,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
        layout: layout ?? this.layout,
        isHidden: isHidden,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );
}
