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
    
    // Use the stateful widget with a stable key based on field name
    // This ensures the widget survives parent rebuilds
    return _VooTextFieldStateful(
      key: ValueKey('voo_text_field_$name'),
      field: this,
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

/// Stateful widget to manage text field state and prevent keyboard dismissal
class _VooTextFieldStateful extends StatefulWidget {
  final VooTextField field;

  const _VooTextFieldStateful({
    super.key,
    required this.field,
  });

  @override
  State<_VooTextFieldStateful> createState() => _VooTextFieldStatefulState();
}

class _VooTextFieldStatefulState extends State<_VooTextFieldStateful> 
    with AutomaticKeepAliveClientMixin {
  TextEditingController? _effectiveController;
  FocusNode? _effectiveFocusNode;
  FocusNode? _internalFocusNode;
  VooFormController? _formController;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get the form controller from scope if available
    final formScope = VooFormScope.of(context);
    _formController = formScope?.controller;
    
    // Initialize or update controllers
    _initializeControllers();
  }

  @override
  void didUpdateWidget(_VooTextFieldStateful oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If the field name changed, we need to get the correct controller
    if (oldWidget.field.name != widget.field.name) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    // Use provided controller or get one from form controller if available
    _effectiveController = widget.field.controller;
    if (_effectiveController == null && _formController != null) {
      // Get the current value from the form controller if it exists
      // If no value in controller yet, use the field's initial value
      final currentValue = _formController!.getValue(widget.field.name);
      final effectiveInitialValue = currentValue?.toString() ?? widget.field.initialValue;
      
      _effectiveController = _formController!.registerTextController(
        widget.field.name, 
        initialText: effectiveInitialValue,
      );
      
      // If we have an initial value but the controller doesn't have it yet, set it
      if (effectiveInitialValue != null && currentValue == null) {
        _formController!.setValue(widget.field.name, effectiveInitialValue);
      }
    }
    
    // Use provided focus node, get from form controller, or create internal one
    if (widget.field.focusNode != null) {
      _effectiveFocusNode = widget.field.focusNode;
    } else if (_formController != null) {
      _effectiveFocusNode = _formController!.getFocusNode(widget.field.name);
    } else {
      // Create internal focus node if none provided
      _internalFocusNode ??= FocusNode();
      _effectiveFocusNode = _internalFocusNode;
    }
  }
  
  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Create wrapped onChanged that updates both controller and calls user callback
    void handleChanged(String? value) {
      // Update form controller if available
      if (_formController != null) {
        // Check if we should validate based on error display mode and current error state
        final hasError = _formController!.hasError(widget.field.name);
        final shouldValidate = hasError || 
            _formController!.errorDisplayMode == VooFormErrorDisplayMode.onTyping ||
            _formController!.validationMode == FormValidationMode.onChange;
        
        _formController!.setValue(widget.field.name, value, validate: shouldValidate);
      }
      // Call user's onChanged if provided
      widget.field.onChanged?.call(value);
    }

    // Listen to form controller for error state changes only
    if (_formController != null) {
      return AnimatedBuilder(
        animation: _formController!,
        builder: (context, child) {
          // Get the current error from the form controller
          final error = _formController!.getError(widget.field.name);
          
          // Create decoration with error text included
          final decoration = widget.field.getInputDecoration(context).copyWith(
            errorText: widget.field.showError != false ? error : null,
          );
          
          // Build the text input widget with the error in the decoration
          final textInput = VooTextInput(
            controller: _effectiveController,
            focusNode: _effectiveFocusNode,
            initialValue: _effectiveController == null ? widget.field.initialValue : null,
            placeholder: widget.field.placeholder,
            keyboardType: widget.field.keyboardType,
            textInputAction: widget.field.textInputAction,
            inputFormatters: widget.field.inputFormatters,
            obscureText: widget.field.obscureText,
            enableSuggestions: widget.field.enableSuggestions,
            autocorrect: widget.field.autocorrect,
            maxLines: widget.field.expands ? null : widget.field.maxLines,
            minLines: widget.field.expands ? null : widget.field.minLines,
            maxLength: widget.field.maxLength,
            expands: widget.field.expands,
            textCapitalization: widget.field.textCapitalization,
            onChanged: handleChanged,
            onEditingComplete: widget.field.onEditingComplete,
            onSubmitted: widget.field.onSubmitted,
            enabled: widget.field.enabled,
            readOnly: widget.field.readOnly == true,
            autofocus: widget.field.autofocus,
            decoration: decoration, // Use decoration with error
          );
          
          // Apply height constraints to the input widget
          final constrainedInput = widget.field.applyInputHeightConstraints(textInput);
          
          // Build with label, helper, and actions (but NOT error - it's in the decoration now)
          return widget.field.buildFieldContainer(
            context,
            widget.field.buildWithLabel(
              context,
              widget.field.buildWithHelper(
                context,
                widget.field.buildWithActions(
                  context,
                  constrainedInput,
                ),
              ),
            ),
          );
        },
      );
    }
    
    // If no form controller, build without AnimatedBuilder
    final textInput = VooTextInput(
      controller: _effectiveController,
      focusNode: _effectiveFocusNode,
      initialValue: _effectiveController == null ? widget.field.initialValue : null,
      placeholder: widget.field.placeholder,
      keyboardType: widget.field.keyboardType,
      textInputAction: widget.field.textInputAction,
      inputFormatters: widget.field.inputFormatters,
      obscureText: widget.field.obscureText,
      enableSuggestions: widget.field.enableSuggestions,
      autocorrect: widget.field.autocorrect,
      maxLines: widget.field.expands ? null : widget.field.maxLines,
      minLines: widget.field.expands ? null : widget.field.minLines,
      maxLength: widget.field.maxLength,
      expands: widget.field.expands,
      textCapitalization: widget.field.textCapitalization,
      onChanged: handleChanged,
      onEditingComplete: widget.field.onEditingComplete,
      onSubmitted: widget.field.onSubmitted,
      enabled: widget.field.enabled,
      readOnly: widget.field.readOnly == true,
      autofocus: widget.field.autofocus,
      decoration: widget.field.getInputDecoration(context).copyWith(
        errorText: widget.field.showError != false ? widget.field.error : null,
      ),
    );
    
    // Apply height constraints to the input widget
    final constrainedInput = widget.field.applyInputHeightConstraints(textInput);
    
    return widget.field.buildFieldContainer(
      context,
      widget.field.buildWithLabel(
        context,
        widget.field.buildWithHelper(
          context,
          widget.field.buildWithActions(
            context,
            constrainedInput,
          ),
        ),
      ),
    );
  }
}
