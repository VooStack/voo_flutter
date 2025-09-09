import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_dropdown_search_field.dart';
import 'package:voo_forms/voo_forms.dart';

/// Internal stateful widget for async dropdown
class AsyncDropdownFieldWidget<T> extends StatefulWidget {
  final VooAsyncDropdownField<T> field;

  const AsyncDropdownFieldWidget({
    super.key,
    required this.field,
  });

  @override
  State<AsyncDropdownFieldWidget<T>> createState() => AsyncDropdownFieldWidgetState<T>();
}

/// State for internal async dropdown field widget
class AsyncDropdownFieldWidgetState<T> extends State<AsyncDropdownFieldWidget<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.field.initialValue;
  }

  @override
  void didUpdateWidget(AsyncDropdownFieldWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected value if initialValue changes
    if (widget.field.initialValue != oldWidget.field.initialValue) {
      setState(() {
        _selectedValue = widget.field.initialValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveReadOnly = widget.field.getEffectiveReadOnly(context);

    // Get the form controller from scope if available
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    
    // Get the error for this field using the base class method
    final fieldError = widget.field.getFieldError(context);

    // Create wrapped onChanged that updates both controller and calls user callback
    void handleChanged(T? value) {
      setState(() {
        _selectedValue = value;
      });
      // Update form controller if available
      if (formController != null) {
        // Validate on selection to clear any errors
        formController.setValue(widget.field.name, value, validate: true);
      }
      // Call user's onChanged if provided
      widget.field.onChanged?.call(value);
    }

    // Build the dropdown with integrated async search
    Widget dropdownContent = VooDropdownSearchField<T>(
      items: const [], // Empty initial items, async search will load them
      value: _selectedValue,
      displayTextBuilder: widget.field.displayTextBuilder,
      onChanged: widget.field.enabled && !effectiveReadOnly ? handleChanged : null,
      hint: widget.field.placeholder ?? widget.field.hint,
      enabled: widget.field.enabled && !effectiveReadOnly,
      icon: widget.field.dropdownIcon,
      sortComparator: widget.field.sortOptions,
      asyncSearch: widget.field.asyncOptionsLoader,
      searchDebounce: widget.field.searchDebounce,
      decoration: widget.field.getInputDecoration(context).copyWith(
        suffixIcon: widget.field.dropdownIcon,
      ),
    );

    // Apply standard field building pattern
    dropdownContent = widget.field.buildWithHelper(context, dropdownContent);
    
    // Build with error if present
    if (fieldError != null && fieldError.isNotEmpty) {
      dropdownContent = widget.field.buildWithError(context, dropdownContent);
    }
    
    dropdownContent = widget.field.buildWithLabel(context, dropdownContent);
    dropdownContent = widget.field.buildWithActions(context, dropdownContent);

    return dropdownContent;
  }
}