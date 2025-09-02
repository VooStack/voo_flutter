import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_dropdown_search_field.dart';

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
    this.displayTextBuilder,
    this.dropdownIcon,
    this.maxDropdownHeight,
    this.isExpanded = true,
    this.sortOptions,
    this.searchFilter,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveValue = value ?? initialValue;

    // Build the searchable dropdown content
    Widget dropdownContent = VooDropdownSearchField<T>(
      items: options,
      value: effectiveValue,
      displayTextBuilder: displayTextBuilder,
      onChanged: enabled && !readOnly ? onChanged : null,
      hint: placeholder ?? hint,
      enabled: enabled && !readOnly,
      icon: dropdownIcon,
      sortComparator: sortOptions,
      searchFilter: searchFilter,
    );

    // Apply standard field building pattern
    dropdownContent = buildWithHelper(context, dropdownContent);
    dropdownContent = buildWithError(context, dropdownContent);
    dropdownContent = buildWithLabel(context, dropdownContent);
    dropdownContent = buildWithActions(context, dropdownContent);

    return dropdownContent;
  }
}

/// Async dropdown field that loads options asynchronously
class VooAsyncDropdownField<T> extends VooFieldBase<T> {
  /// Async loader for options
  final Future<List<T>> Function(String query) asyncOptionsLoader;

  /// Display text converter for options
  final String Function(T)? displayTextBuilder;

  /// Icon for the dropdown arrow
  final Widget? dropdownIcon;

  /// Maximum height for dropdown overlay
  final double? maxDropdownHeight;

  /// Whether dropdown should fill width
  final bool isExpanded;

  /// Loading indicator widget
  final Widget? loadingIndicator;

  /// Debounce duration for search
  final Duration searchDebounce;

  /// Sort comparison function for options
  final int Function(T a, T b)? sortOptions;

  const VooAsyncDropdownField({
    super.key,
    required super.name,
    required this.asyncOptionsLoader,
    super.label,
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
    this.displayTextBuilder,
    this.dropdownIcon,
    this.maxDropdownHeight,
    this.isExpanded = true,
    this.loadingIndicator,
    this.searchDebounce = const Duration(milliseconds: 500),
    this.sortOptions,
  });

  @override
  Widget build(BuildContext context) => _AsyncDropdownFieldWidget<T>(
        field: this,
      );
}

/// Internal stateful widget for async dropdown
class _AsyncDropdownFieldWidget<T> extends StatefulWidget {
  final VooAsyncDropdownField<T> field;

  const _AsyncDropdownFieldWidget({
    required this.field,
  });

  @override
  State<_AsyncDropdownFieldWidget<T>> createState() => _AsyncDropdownFieldWidgetState<T>();
}

class _AsyncDropdownFieldWidgetState<T> extends State<_AsyncDropdownFieldWidget<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.field.value ?? widget.field.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    // Build the dropdown with integrated async search
    Widget dropdownContent = VooDropdownSearchField<T>(
      items: const [], // Empty initial items, async search will load them
      value: _selectedValue,
      displayTextBuilder: widget.field.displayTextBuilder,
      onChanged: widget.field.enabled && !widget.field.readOnly
          ? (value) {
              setState(() {
                _selectedValue = value;
              });
              widget.field.onChanged?.call(value);
            }
          : null,
      hint: widget.field.placeholder ?? widget.field.hint,
      enabled: widget.field.enabled && !widget.field.readOnly,
      icon: widget.field.dropdownIcon,
      sortComparator: widget.field.sortOptions,
      asyncSearch: widget.field.asyncOptionsLoader,
      searchDebounce: widget.field.searchDebounce,
    );

    // Apply standard field building pattern
    dropdownContent = widget.field.buildWithHelper(context, dropdownContent);
    dropdownContent = widget.field.buildWithError(context, dropdownContent);
    dropdownContent = widget.field.buildWithLabel(context, dropdownContent);
    dropdownContent = widget.field.buildWithActions(context, dropdownContent);

    return dropdownContent;
  }
}
