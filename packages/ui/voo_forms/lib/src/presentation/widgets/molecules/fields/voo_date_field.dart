import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_date_input.dart';

/// Date field molecule that composes atoms to create a complete date picker field
/// Extends VooFieldBase to inherit all common field functionality
class VooDateField extends VooFieldBase<DateTime> {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat? dateFormat;
  final bool autofocus;

  const VooDateField({
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
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();
    
    Widget dateInput = VooDateInput(
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      value: value,
      placeholder: placeholder,
      firstDate: firstDate,
      lastDate: lastDate,
      dateFormat: dateFormat,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      decoration: getInputDecoration(context),
    );
    
    // Apply height constraints to the input widget
    dateInput = applyInputHeightConstraints(dateInput);

    // Compose with label, helper, error and actions using base class methods
    return buildWithLabel(
      context,
      buildWithHelper(
        context,
        buildWithError(
          context,
          buildWithActions(
            context,
            dateInput,
          ),
        ),
      ),
    );
  }
}