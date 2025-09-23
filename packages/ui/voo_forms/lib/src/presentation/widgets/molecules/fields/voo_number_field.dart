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

      Widget readOnlyContent = VooReadOnlyField(value: displayValue, icon: prefixIcon ?? suffixIcon);

      // Apply standard field building pattern
      readOnlyContent = buildWithHelper(context, readOnlyContent);
      readOnlyContent = buildWithError(context, readOnlyContent);
      readOnlyContent = buildWithLabel(context, readOnlyContent);
      readOnlyContent = buildWithActions(context, readOnlyContent);

      return buildFieldContainer(context, readOnlyContent);
    }

    // Use the stateful widget with a stable key based on field name
    // This ensures the widget survives parent rebuilds
    return _VooNumberFieldStateful(key: ValueKey('voo_number_field_$name'), field: this);
  }

  @override
  VooNumberField copyWith({num? initialValue, String? label, VooFieldLayout? layout, String? name, bool? readOnly}) => VooNumberField(
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

  const _VooNumberFieldStateful({super.key, required this.field});

  @override
  State<_VooNumberFieldStateful> createState() => _VooNumberFieldStatefulState();
}

class _VooNumberFieldStatefulState extends State<_VooNumberFieldStateful> with AutomaticKeepAliveClientMixin {
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
  void didUpdateWidget(_VooNumberFieldStateful oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the field name changed, we need to get the correct controller
    if (oldWidget.field.name != widget.field.name) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    // Use provided focus node or get one from form controller if available
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
    void handleChanged(String text) {
      final numValue = num.tryParse(text);
      // Update form controller if available
      if (_formController != null) {
        // Check if we should validate based on error display mode and current error state
        final hasError = _formController!.hasError(widget.field.name);
        final shouldValidate =
            hasError || _formController!.errorDisplayMode == VooFormErrorDisplayMode.onTyping || _formController!.validationMode == FormValidationMode.onChange;

        _formController!.setValue(widget.field.name, numValue, validate: shouldValidate);
      }
      // Call user's onChanged if provided
      widget.field.onChanged?.call(numValue);
    }

    // Listen to form controller for error state changes only
    if (_formController != null) {
      return AnimatedBuilder(
        animation: _formController!,
        builder: (context, child) {
          // Get the current error from the form controller
          final error = _formController!.getError(widget.field.name);

          // Create decoration with error text included
          final decoration = widget.field.getInputDecoration(context).copyWith(errorText: widget.field.showError != false ? error : null);

          // Build the number input widget with the error in the decoration
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
            decoration: decoration, // Use decoration with error
            signed: widget.field.allowNegative,
            decimal: widget.field.allowDecimals,
          );

          // Apply height constraints to the input widget
          final constrainedInput = widget.field.applyInputHeightConstraints(numberInput);

          // Build with label, helper, and actions (but NOT error - it's in the decoration now)
          return widget.field.buildFieldContainer(
            context,
            widget.field.buildWithLabel(context, widget.field.buildWithHelper(context, widget.field.buildWithActions(context, constrainedInput))),
          );
        },
      );
    }

    // If no form controller, build without AnimatedBuilder
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
      decoration: widget.field.getInputDecoration(context).copyWith(errorText: widget.field.showError != false ? widget.field.error : null),
      signed: widget.field.allowNegative,
      decimal: widget.field.allowDecimals,
    );

    // Apply height constraints to the input widget
    final constrainedInput = widget.field.applyInputHeightConstraints(numberInput);

    return widget.field.buildFieldContainer(
      context,
      widget.field.buildWithLabel(context, widget.field.buildWithHelper(context, widget.field.buildWithActions(context, constrainedInput))),
    );
  }
}
