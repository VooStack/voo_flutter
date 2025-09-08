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

    // Get the form controller from scope if available
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    
    // Get the error for this field from the controller
    final fieldError = formController?.getError(name) ?? error;

    // If read-only, show VooReadOnlyField for better UX
    if (effectiveReadOnly) {
      final format = dateFormat ?? DateFormat.yMMMd();
      Widget readOnlyContent = VooReadOnlyField(
        value: initialValue != null ? format.format(initialValue!) : '',
        icon: prefixIcon ?? const Icon(Icons.calendar_today),
      );
      
      // Apply standard field building pattern
      readOnlyContent = buildWithHelper(context, readOnlyContent);
      
      // Build error widget if there's an error
      if (fieldError != null && fieldError.isNotEmpty) {
        readOnlyContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            readOnlyContent,
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                fieldError,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        );
      }
      
      readOnlyContent = buildWithLabel(context, readOnlyContent);
      readOnlyContent = buildWithActions(context, readOnlyContent);
      
      return buildFieldContainer(context, readOnlyContent);
    }

    // Create wrapped onChanged that updates both controller and calls user callback
    void handleChanged(DateTime? value) {
      // Update form controller if available
      if (formController != null) {
        formController.setValue(name, value);
      }
      // Call user's onChanged if provided
      onChanged?.call(value);
    }

    Widget dateInput = VooDateInput(
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      placeholder: placeholder,
      firstDate: firstDate,
      lastDate: lastDate,
      dateFormat: dateFormat,
      onChanged: handleChanged,
      enabled: enabled,
      readOnly: readOnly,
      decoration: getInputDecoration(context),
    );

    // Apply height constraints to the input widget
    dateInput = applyInputHeightConstraints(dateInput);

    // Build the error widget if there's an error
    Widget fieldWithError = dateInput;
    if (fieldError != null && fieldError.isNotEmpty) {
      fieldWithError = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          dateInput,
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              fieldError,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      );
    }

    // Compose with label, helper and actions using base class methods
    return buildFieldContainer(
      context,
      buildWithLabel(
        context,
        buildWithHelper(
          context,
          buildWithActions(
            context,
            fieldWithError,
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
