import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_number_input.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

/// Number field molecule that composes atoms to create a complete numeric input field
/// Supports both integer and decimal numbers with configurable constraints
class VooNumberField extends VooFieldBase<num> {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final num? min;
  final num? max;
  final num? step;
  final bool allowDecimals;
  final bool allowNegative;
  final int? maxDecimalPlaces;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  const VooNumberField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.hint,
    super.helper,
    String? placeholder,
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
    this.min,
    this.max,
    this.step,
    this.allowDecimals = true,
    this.allowNegative = true,
    this.maxDecimalPlaces,
    this.onEditingComplete,
    this.onSubmitted,
    this.autofocus = false,
  }) : super(placeholder: placeholder ?? '0');

  @override
  String? validate(num? value) {
    // Call base validation first for required check
    final baseError = super.validate(value);
    if (baseError != null) return baseError;

    // Check min/max constraints
    if (value != null) {
      if (min != null && value < min!) {
        return '${label ?? name} must be at least $min';
      }
      if (max != null && value > max!) {
        return '${label ?? name} must be at most $max';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

    final effectiveReadOnly = getEffectiveReadOnly(context);

    // If read-only, show VooReadOnlyField for better UX
    if (effectiveReadOnly) {
      String displayValue = '';
      if (initialValue != null) {
        // Format the number appropriately
        if (!allowDecimals || initialValue!.toInt() == initialValue) {
          displayValue = initialValue!.toInt().toString();
        } else {
          displayValue = initialValue.toString();
        }
      }
      
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

    // Use the stateful widget to manage the number input and prevent keyboard dismissal
    return _VooNumberFieldStateful(
      field: this,
    );
  }

  @override
  VooNumberField copyWith({
    num? initialValue,
    String? label,
    VooFieldLayout? layout,
    String? name,
    bool? readOnly,
  }) =>
      VooNumberField(
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
        min: min,
        max: max,
        step: step,
        allowDecimals: allowDecimals,
        allowNegative: allowNegative,
        maxDecimalPlaces: maxDecimalPlaces,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
      );
}

/// Stateful widget to manage number field state and prevent keyboard dismissal
class _VooNumberFieldStateful extends StatefulWidget {
  final VooNumberField field;

  const _VooNumberFieldStateful({
    required this.field,
  });

  @override
  State<_VooNumberFieldStateful> createState() => _VooNumberFieldStatefulState();
}

class _VooNumberFieldStatefulState extends State<_VooNumberFieldStateful> {
  FocusNode? _effectiveFocusNode;
  VooFormController? _formController;

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
  void didUpdateWidget(_VooNumberFieldStateful oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Preserve focus state during widget updates
    final hadFocus = _effectiveFocusNode?.hasFocus ?? false;
    
    // If the field name changed, we need to get the correct controller
    if (oldWidget.field.name != widget.field.name) {
      _initializeControllers();
    }
    
    // Restore focus if the field had it before the update
    if (hadFocus && _effectiveFocusNode != null && !_effectiveFocusNode!.hasFocus) {
      // Schedule focus restoration after the build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _effectiveFocusNode != null) {
          _effectiveFocusNode!.requestFocus();
        }
      });
    }
  }

  void _initializeControllers() {
    // Use provided focus node or get one from form controller if available
    _effectiveFocusNode = widget.field.focusNode;
    if (_effectiveFocusNode == null && _formController != null) {
      _effectiveFocusNode = _formController!.getFocusNode(widget.field.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create wrapped onChanged that updates both controller and calls user callback
    void handleChanged(String text) {
      final numValue = num.tryParse(text);
      // Update form controller if available
      if (_formController != null) {
        // Check if we should validate based on error display mode and current error state
        final hasError = _formController!.hasError(widget.field.name);
        final shouldValidate = hasError || 
            _formController!.errorDisplayMode == VooFormErrorDisplayMode.onTyping ||
            _formController!.validationMode == FormValidationMode.onChange;
        
        _formController!.setValue(widget.field.name, numValue, validate: shouldValidate);
      }
      // Call user's onChanged if provided
      widget.field.onChanged?.call(numValue);
    }

    final numberInput = VooNumberInput(
      controller: widget.field.controller,
      focusNode: _effectiveFocusNode,
      initialValue: widget.field.initialValue,
      placeholder: widget.field.placeholder,
      inputFormatters: [
        StrictNumberFormatter(
          allowDecimals: widget.field.allowDecimals,
          allowNegative: widget.field.allowNegative,
          maxDecimalPlaces: widget.field.maxDecimalPlaces,
          minValue: widget.field.min,
          maxValue: widget.field.max,
        ),
      ],
      onChanged: handleChanged,
      onEditingComplete: widget.field.onEditingComplete,
      onSubmitted: widget.field.onSubmitted,
      enabled: widget.field.enabled,
      autofocus: widget.field.autofocus,
      decoration: widget.field.getInputDecoration(context),
      signed: widget.field.allowNegative,
      decimal: widget.field.allowDecimals,
    );
    
    // Listen to form controller for error state changes only
    if (_formController != null) {
      return AnimatedBuilder(
        animation: _formController!,
        builder: (context, child) {
          // Compose with label, helper, error and actions using base class methods
          return widget.field.buildFieldContainer(
            context,
            widget.field.buildWithLabel(
              context,
              widget.field.buildWithError(
                context,
                widget.field.buildWithHelper(
                  context,
                  widget.field.buildWithActions(
                    context,
                    child!, // Use the child (number input) that doesn't rebuild
                  ),
                ),
              ),
            ),
          );
        },
        child: numberInput, // This child won't rebuild when the animation changes
      );
    }
    
    // If no form controller, build without AnimatedBuilder
    return widget.field.buildFieldContainer(
      context,
      widget.field.buildWithLabel(
        context,
        widget.field.buildWithError(
          context,
          widget.field.buildWithHelper(
            context,
            widget.field.buildWithActions(
              context,
              numberInput,
            ),
          ),
        ),
      ),
    );
  }
}
