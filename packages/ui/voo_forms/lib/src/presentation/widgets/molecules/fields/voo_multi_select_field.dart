import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/internal/multi_select_field_widget.dart';
import 'package:voo_forms/voo_forms.dart';

/// Multi-select dropdown field that allows selecting multiple options
/// Extends VooFieldBase to inherit all common field functionality
class VooMultiSelectField<T> extends VooFieldBase<List<T>> {
  /// List of options to display in the dropdown
  final List<T> options;

  /// Display text converter for options
  final String Function(T)? displayTextBuilder;

  /// Icon for the dropdown arrow
  final Widget? dropdownIcon;

  /// Maximum height for dropdown overlay
  final double? maxDropdownHeight;

  /// Whether dropdown should fill width
  final bool isExpanded;

  /// Sort comparison function for options
  final int Function(T a, T b)? sortOptions;

  /// Custom search filter function
  final bool Function(T item, String searchTerm)? searchFilter;

  /// Widget to display when no items are selected
  final String? emptySelectionText;

  /// Maximum number of chips to display before showing count
  final int? maxChipsDisplay;

  /// Whether to show clear all button
  final bool showClearAll;

  /// Whether to show select all button
  final bool showSelectAll;

  /// Custom option builder for dropdown items
  final Widget Function(BuildContext context, T item, bool isSelected, String displayText)? optionBuilder;

  const VooMultiSelectField({
    super.key,
    required super.name,
    required this.options,
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
    this.displayTextBuilder,
    this.dropdownIcon,
    this.maxDropdownHeight,
    this.isExpanded = true,
    this.sortOptions,
    this.searchFilter,
    this.emptySelectionText,
    this.maxChipsDisplay = 3,
    this.showClearAll = true,
    this.showSelectAll = true,
    this.optionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

    return MultiSelectFieldWidget<T>(field: this);
  }

  @override
  VooMultiSelectField<T> copyWith({
    List<T>? initialValue,
    String? label,
    VooFieldLayout? layout,
    String? name,
    bool? readOnly,
  }) =>
      VooMultiSelectField<T>(
        key: key,
        name: name ?? this.name,
        options: options,
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
        displayTextBuilder: displayTextBuilder,
        dropdownIcon: dropdownIcon,
        maxDropdownHeight: maxDropdownHeight,
        isExpanded: isExpanded,
        sortOptions: sortOptions,
        searchFilter: searchFilter,
        emptySelectionText: emptySelectionText,
        maxChipsDisplay: maxChipsDisplay,
        showClearAll: showClearAll,
        showSelectAll: showSelectAll,
      );
}