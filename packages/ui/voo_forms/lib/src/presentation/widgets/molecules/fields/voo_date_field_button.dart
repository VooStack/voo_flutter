import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/voo_forms.dart';

/// Date field button molecule that provides date selection via a button press
/// Shows selected date or placeholder text on the button
/// Extends VooFieldBase to inherit all common field functionality
class VooDateFieldButton extends VooFieldBase<DateTime> {
  /// First date available for selection
  final DateTime? firstDate;

  /// Last date available for selection
  final DateTime? lastDate;

  /// Date format for displaying the selected date
  final DateFormat? dateFormat;

  /// Button type (filled, outlined, text)
  final ButtonType buttonType;

  /// Whether to expand button to full width
  final bool expandButton;

  /// Custom button text when no date is selected
  final String? buttonText;

  const VooDateFieldButton({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.hint,
    super.helper,
    super.placeholder,
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
    super.initialValue,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.buttonType = ButtonType.outlined,
    this.expandButton = true,
    this.buttonText,
  });

  Future<void> _selectDate(BuildContext context) async {
    final currentValue = initialValue;
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentValue ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      helpText: label ?? placeholder,
    );

    if (picked != null && picked != currentValue) {
      onChanged?.call(picked);
    }
  }

  String _getButtonText() {
    final currentValue = initialValue;

    if (currentValue != null) {
      final formatter = dateFormat ?? DateFormat('yyyy-MM-dd');
      return formatter.format(currentValue);
    }

    return buttonText ?? placeholder ?? 'Select Date';
  }

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

    final effectiveReadOnly = getEffectiveReadOnly(context);

    Widget button = VooFormButton(
      text: _getButtonText(),
      onPressed: enabled && !effectiveReadOnly ? () => _selectDate(context) : null,
      enabled: enabled && !effectiveReadOnly,
      type: buttonType,
    );

    // Apply prefixIcon if provided
    if (prefixIcon != null) {
      button = Row(
        mainAxisSize: expandButton ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (expandButton) const SizedBox(width: 12),
          prefixIcon!,
          const SizedBox(width: 8),
          if (expandButton) Expanded(child: button) else button,
        ],
      );
    }

    // Apply suffixIcon if provided
    if (suffixIcon != null && prefixIcon == null) {
      button = Row(
        mainAxisSize: expandButton ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (expandButton) Expanded(child: button) else button,
          const SizedBox(width: 8),
          suffixIcon!,
          if (expandButton) const SizedBox(width: 12),
        ],
      );
    }

    // Apply height constraints to the button widget
    button = applyInputHeightConstraints(button);

    // Compose with label, helper, error and actions using base class methods
    return buildWithLabel(
      context,
      buildWithHelper(
        context,
        buildWithError(
          context,
          buildWithActions(
            context,
            button,
          ),
        ),
      ),
    );
  }

  @override
  VooDateFieldButton copyWith({
    String? name,
    String? label,
    DateTime? initialValue,
    VooFieldLayout? layout,
    bool? readOnly,
  }) =>
      VooDateFieldButton(
        key: key,
        name: name ?? this.name,
        label: label ?? this.label,
        labelWidget: labelWidget,
        hint: hint,
        helper: helper,
        placeholder: placeholder,
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
        initialValue: initialValue ?? this.initialValue,
        firstDate: firstDate,
        lastDate: lastDate,
        dateFormat: dateFormat,
        buttonType: buttonType,
        expandButton: expandButton,
        buttonText: buttonText,
      );
}
