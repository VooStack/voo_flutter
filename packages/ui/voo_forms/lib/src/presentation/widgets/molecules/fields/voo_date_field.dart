import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_date_input.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

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

    final effectiveReadOnly = getEffectiveReadOnly(context);

    // If read-only, show VooReadOnlyField for better UX
    if (effectiveReadOnly) {
      final format = dateFormat ?? DateFormat.yMMMd();
      Widget readOnlyContent = VooReadOnlyField(
        value: initialValue != null ? format.format(initialValue!) : '',
        icon: prefixIcon ?? const Icon(Icons.calendar_today),
      );
      
      // Apply standard field building pattern
      readOnlyContent = buildWithHelper(context, readOnlyContent);
      readOnlyContent = buildWithError(context, readOnlyContent);
      readOnlyContent = buildWithLabel(context, readOnlyContent);
      readOnlyContent = buildWithActions(context, readOnlyContent);
      
      return buildFieldContainer(context, readOnlyContent);
    }

    Widget dateInput = VooDateInput(
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
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

  @override
  VooDateField copyWith({
    String? name,
    String? label,
    DateTime? initialValue,
    VooFieldLayout? layout,
    bool? readOnly,
  }) =>
      VooDateField(
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
        layout: layout ?? this.layout,
        isHidden: isHidden,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
        controller: controller,
        focusNode: focusNode,
        firstDate: firstDate,
        lastDate: lastDate,
        dateFormat: dateFormat,
        autofocus: autofocus,
      );
}
