import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/internal/async_multi_select_field_widget.dart';
import 'package:voo_forms/voo_forms.dart';

/// Async multi-select field that loads options asynchronously
/// Extends VooFieldBase to inherit all common field functionality
class VooAsyncMultiSelectField<T> extends VooFieldBase<List<T>> {
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

  /// Widget to display when no items are selected
  final String? emptySelectionText;

  /// Maximum number of chips to display before showing count
  final int? maxChipsDisplay;

  /// Whether to show clear all button
  final bool showClearAll;

  /// Custom option builder for dropdown items
  final Widget Function(BuildContext context, T item, bool isSelected, String displayText)? optionBuilder;

  const VooAsyncMultiSelectField({
    super.key,
    required super.name,
    required this.asyncOptionsLoader,
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
    this.loadingIndicator,
    this.searchDebounce = const Duration(milliseconds: 500),
    this.sortOptions,
    this.emptySelectionText,
    this.maxChipsDisplay = 3,
    this.showClearAll = true,
    this.optionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

    return AsyncMultiSelectFieldWidget<T>(field: this);
  }

  @override
  VooAsyncMultiSelectField<T> copyWith({
    List<T>? initialValue,
    String? label,
    VooFieldLayout? layout,
    String? name,
    bool? readOnly,
  }) =>
      VooAsyncMultiSelectField<T>(
        key: key,
        name: name ?? this.name,
        asyncOptionsLoader: asyncOptionsLoader,
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
        loadingIndicator: loadingIndicator,
        searchDebounce: searchDebounce,
        sortOptions: sortOptions,
        emptySelectionText: emptySelectionText,
        maxChipsDisplay: maxChipsDisplay,
        showClearAll: showClearAll,
      );
}