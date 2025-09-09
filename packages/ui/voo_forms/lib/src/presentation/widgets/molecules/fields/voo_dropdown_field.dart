import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_dropdown_search_field.dart';
import 'package:voo_forms/voo_forms.dart';

/// Dropdown field molecule that provides a searchable dropdown selection widget
/// Extends VooFieldBase to inherit all common field functionality
class VooDropdownField<T> extends VooFieldBase<T> {
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

  const VooDropdownField({
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
    this.displayTextBuilder,
    this.dropdownIcon,
    this.maxDropdownHeight,
    this.isExpanded = true,
    this.sortOptions,
    this.searchFilter,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveValue = initialValue;
    final effectiveReadOnly = getEffectiveReadOnly(context);

    // Get the form controller from scope if available
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    
    // Get the error for this field using the base class method
    final fieldError = getFieldError(context);

    // Create wrapped onChanged that updates both controller and calls user callback
    void handleChanged(T? value) {
      // Update form controller if available
      if (formController != null) {
        // Validate on selection to clear any errors
        formController.setValue(name, value, validate: true);
      }
      // Call user's onChanged if provided
      onChanged?.call(value);
    }

    // Build the searchable dropdown content
    Widget dropdownContent = VooDropdownSearchField<T>(
      items: options,
      value: effectiveValue,
      displayTextBuilder: displayTextBuilder,
      onChanged: enabled && !effectiveReadOnly ? handleChanged : null,
      hint: placeholder ?? hint,
      enabled: enabled && !effectiveReadOnly,
      icon: dropdownIcon,
      sortComparator: sortOptions,
      searchFilter: searchFilter,
      decoration: getInputDecoration(context).copyWith(
        suffixIcon: dropdownIcon,
      ),
    );

    // Apply standard field building pattern
    dropdownContent = buildWithHelper(context, dropdownContent);
    
    // Build with error if present
    if (fieldError != null && fieldError.isNotEmpty) {
      dropdownContent = buildWithError(context, dropdownContent);
    }
    
    dropdownContent = buildWithLabel(context, dropdownContent);
    dropdownContent = buildWithActions(context, dropdownContent);

    return buildFieldContainer(context, dropdownContent);
  }

  @override
  VooDropdownField<T> copyWith({
    T? initialValue,
    String? label,
    VooFieldLayout? layout,
    String? name,
    bool? readOnly,
  }) =>
      VooDropdownField<T>(
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
      );
}