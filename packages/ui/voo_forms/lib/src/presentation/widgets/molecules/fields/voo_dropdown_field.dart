import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';

/// Dropdown field molecule that provides a dropdown selection widget
/// Extends VooFieldBase to inherit all common field functionality
class VooDropdownField<T> extends VooFieldBase<T> {
  /// List of options to display in the dropdown
  final List<T> options;

  /// Display text converter for options
  final String Function(T)? displayTextBuilder;

  /// Icon for the dropdown arrow
  final Widget? dropdownIcon;

  /// Whether to enable search in dropdown
  final bool enableSearch;

  /// Search hint text
  final String? searchHint;

  /// Maximum height for dropdown overlay
  final double? maxDropdownHeight;

  /// Whether dropdown should fill width
  final bool isExpanded;

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
    this.enableSearch = false,
    this.searchHint,
    this.maxDropdownHeight,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveValue = value ?? initialValue;

    // Build the dropdown button content
    Widget dropdownContent = DropdownButtonFormField<T>(
      initialValue: effectiveValue,
      decoration: InputDecoration(
        hintText: placeholder ?? hint,
        // Don't include errorText since we use buildWithError separately
        filled: true,
        fillColor: enabled ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
          ),
        ),
      ),
      isExpanded: isExpanded,
      hint: placeholder != null ? Text(placeholder!) : null,
      icon: dropdownIcon ?? const Icon(Icons.arrow_drop_down),
      items: options.map((T option) {
        final displayText = displayTextBuilder?.call(option) ?? option.toString();
        return DropdownMenuItem<T>(
          value: option,
          child: Text(displayText),
        );
      }).toList(),
      onChanged: enabled && !readOnly ? onChanged : null,
      validator: validate,
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

  /// Whether to enable search in dropdown
  final bool enableSearch;

  /// Search hint text
  final String? searchHint;

  /// Maximum height for dropdown overlay
  final double? maxDropdownHeight;

  /// Whether dropdown should fill width
  final bool isExpanded;

  /// Loading indicator widget
  final Widget? loadingIndicator;

  /// Debounce duration for search
  final Duration searchDebounce;

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
    this.enableSearch = true,
    this.searchHint,
    this.maxDropdownHeight,
    this.isExpanded = true,
    this.loadingIndicator,
    this.searchDebounce = const Duration(milliseconds: 500),
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<T> _options = [];
  bool _isLoading = false;
  T? _selectedValue;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.field.value ?? widget.field.initialValue;
    // Load initial options
    _loadOptions('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadOptions(String query) async {
    if (_lastQuery == query && _options.isNotEmpty) return;

    setState(() {
      _isLoading = true;
      _lastQuery = query;
    });

    try {
      final options = await widget.field.asyncOptionsLoader(query);
      if (mounted) {
        setState(() {
          _options = options;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget dropdownContent;

    if (_isLoading) {
      dropdownContent = InputDecorator(
        decoration: InputDecoration(
          // Don't include hintText here since we show it in the child widget
          // Don't include errorText since we use buildWithError separately
          filled: true,
          fillColor: widget.field.enabled ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
            ),
          ),
        ),
        child: Row(
          children: [
            if (widget.field.loadingIndicator == null) ...[
              Expanded(
                child: Text(
                  widget.field.placeholder ?? 'Loading...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ] else
              const Spacer(),
            widget.field.loadingIndicator ??
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
          ],
        ),
      );
    } else {
      dropdownContent = DropdownButtonFormField<T>(
        initialValue: _selectedValue,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.field.placeholder ?? widget.field.hint,
          // Don't include errorText since we use buildWithError separately
          filled: true,
          fillColor: widget.field.enabled ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
            ),
          ),
        ),
        isExpanded: widget.field.isExpanded,
        hint: widget.field.placeholder != null ? Text(widget.field.placeholder!) : null,
        icon: widget.field.dropdownIcon ?? const Icon(Icons.arrow_drop_down),
        items: _options.map((T option) {
          final displayText = widget.field.displayTextBuilder?.call(option) ?? option.toString();
          return DropdownMenuItem<T>(
            value: option,
            child: Text(displayText),
          );
        }).toList(),
        onChanged: widget.field.enabled && !widget.field.readOnly
            ? (value) {
                setState(() {
                  _selectedValue = value;
                });
                widget.field.onChanged?.call(value);
              }
            : null,
        validator: (value) => widget.field.validate(value),
      );
    }

    // Apply standard field building pattern
    dropdownContent = widget.field.buildWithHelper(context, dropdownContent);
    dropdownContent = widget.field.buildWithError(context, dropdownContent);
    dropdownContent = widget.field.buildWithLabel(context, dropdownContent);
    dropdownContent = widget.field.buildWithActions(context, dropdownContent);

    return dropdownContent;
  }
}
