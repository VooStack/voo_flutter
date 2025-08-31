import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/atoms/fields/dropdown_field_helpers.dart';
import 'package:voo_forms/src/presentation/atoms/fields/dropdown_menu_overlay.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

typedef AsyncOptionsLoader<T> = Future<List<VooFieldOption<T>>> Function(
  String query,
);

class VooDropdownFieldWidget<T> extends StatefulWidget {
  final VooFormField<T> field;
  final VooFieldOptions options;
  final ValueChanged<T?>? onChanged;
  final String? error;
  final bool showError;

  const VooDropdownFieldWidget({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.error,
    this.showError = true,
  });

  @override
  State<VooDropdownFieldWidget<T>> createState() => _VooDropdownFieldWidgetState<T>();
}

class _VooDropdownFieldWidgetState<T> extends State<VooDropdownFieldWidget<T>> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isOpen = false;
  final TextEditingController _searchController = TextEditingController();
  List<VooFieldOption<T>> _filteredOptions = [];
  List<VooFieldOption<T>> _allOptions = [];
  bool _isLoading = false;
  String _lastQuery = '';
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  Timer? _debounceTimer;
  T? _currentValue;

  // Helper instance for building decorations
  static const _decorationBuilder = DropdownFieldDecorationBuilder();

  @override
  void initState() {
    super.initState();
    _focusNode = widget.field.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _allOptions = widget.field.options ?? [];
    _filteredOptions = _allOptions;
    _currentValue = widget.field.value ?? widget.field.initialValue;

    // Handle initial value for async dropdowns
    if (widget.field.asyncOptionsLoader != null) {
      // If there's an initial value, we need to handle it specially
      if (widget.field.initialValue != null) {
        // Create a temporary option for the initial value if we have a converter
        // This will be replaced when actual options are loaded
        _allOptions = [];
        _filteredOptions = [];
      }
      // Load initial options
      _loadAsyncOptions('');
    }
  }

  @override
  void didUpdateWidget(VooDropdownFieldWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update current value if field value changes
    if (widget.field.value != oldWidget.field.value) {
      setState(() {
        _currentValue = widget.field.value ?? widget.field.initialValue;
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    // Just remove the overlay without setState as we're disposing
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
    if (widget.field.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  /// Safely invoke field.onChanged callback without type casting errors
  void _invokeFieldOnChanged(T? value) {
    try {
      // Access field.onChanged dynamically to avoid compile-time type checking
      final dynamic field = widget.field;
      final callback = field.onChanged;
      if (callback != null && callback is Function) {
        // Use Function.apply to invoke the callback with proper type handling
        Function.apply(callback as Function, [value]);
      }
    } catch (e) {
      // If there's a type mismatch, silently ignore
      // This can happen when field.onChanged expects a specific type
      // but we're passing dynamic. This is expected behavior.
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _removeOverlay,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 8),
                child: DropdownMenuOverlay<T>(
                  filteredOptions: _filteredOptions,
                  allOptions: _allOptions,
                  isLoading: _isLoading,
                  enableSearch: widget.field.enableSearch,
                  searchHint: widget.field.searchHint,
                  searchController: _searchController,
                  onSearchChanged: _onSearchChanged,
                  currentValue: _currentValue,
                  initialValue: widget.field.initialValue,
                  onItemSelected: (T? value) {
                    setState(() {
                      _currentValue = value;
                    });
                    widget.onChanged?.call(value);
                    // Safely invoke field.onChanged if it exists
                    _invokeFieldOnChanged(value);
                    _removeOverlay();
                    _searchController.clear();
                  },
                  onClearSearch: () => _onSearchChanged(''),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });

    if (widget.field.asyncOptionsLoader != null && _allOptions.isEmpty) {
      _loadAsyncOptions('');
    }
  }

  void _onSearchChanged(String query) {
    if (widget.field.asyncOptionsLoader != null) {
      final searchDebounce = widget.field.searchDebounce ?? const Duration(milliseconds: 300);
      final minSearchLength = widget.field.minSearchLength ?? 0;

      // Cancel previous timer
      _debounceTimer?.cancel();

      if (query.length < minSearchLength && query.isNotEmpty) {
        // If query is too short, clear results
        setState(() {
          _filteredOptions = [];
        });
        return;
      }

      // Set up new debounce timer
      _debounceTimer = Timer(searchDebounce, () {
        if (_searchController.text == query) {
          _loadAsyncOptions(query);
        }
      });
    } else {
      // For non-async dropdowns, filter immediately
      setState(() {
        if (query.isEmpty) {
          _filteredOptions = _allOptions;
        } else {
          _filteredOptions = _allOptions
              .where(
                (option) => option.label.toLowerCase().contains(query.toLowerCase()) || (option.subtitle?.toLowerCase().contains(query.toLowerCase()) ?? false),
              )
              .toList();
        }
      });
    }
  }

  Future<void> _loadAsyncOptions(String query) async {
    if (_isLoading && query == _lastQuery) return;

    setState(() {
      _isLoading = true;
      _lastQuery = query;
    });

    try {
      final options = await widget.field.asyncOptionsLoader!(query);
      if (mounted) {
        setState(() {
          _allOptions = options;
          _filteredOptions = options;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _filteredOptions = [];
          _isLoading = false;
        });
      }
    }
  }

  VooFieldOption<T>? _getSelectedOption() {
    // Use the current tracked value
    if (_currentValue == null) return null;

    try {
      return _allOptions.firstWhere((option) => option.value == _currentValue);
    } catch (_) {
      // If we have an initial value but no matching option yet (async loading),
      // create a temporary option for display
      if (_currentValue != null && widget.field.asyncOptionsLoader != null) {
        return VooFieldOption<T>(
          value: _currentValue as T,
          label: _currentValue.toString(),
        );
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final errorText = widget.showError ? (widget.error ?? widget.field.error) : null;
    final hasError = errorText != null && errorText.isNotEmpty;

    // Use searchable dropdown if search is enabled or async loader is provided
    if (widget.field.enableSearch || widget.field.asyncOptionsLoader != null) {
      final selectedOption = _getSelectedOption();

      // Create InputDecoration matching TextFormField style
      final InputDecoration decoration = _decorationBuilder.build<T>(
        context: context,
        field: widget.field,
        options: widget.options,
        hasError: hasError,
        isFocused: _isFocused,
        isOpen: _isOpen,
        error: widget.error,
        selectedOption: selectedOption,
      );

      // Build the dropdown input field using TextFormField for consistent styling
      final Widget dropdownInput = CompositedTransformTarget(
        link: _layerLink,
        child: TextFormField(
          controller: TextEditingController(
            text: selectedOption?.label ?? '',
          ),
          readOnly: true,
          enabled: widget.field.enabled && !widget.field.readOnly,
          focusNode: _focusNode,
          decoration: decoration,
          onTap: widget.field.enabled && !widget.field.readOnly
              ? () {
                  if (_isOpen) {
                    _removeOverlay();
                  } else {
                    _showOverlay();
                  }
                }
              : null,
          style: theme.textTheme.bodyMedium,
        ),
      );

      // Return the dropdown input - TextFormField already handles labels and errors
      return dropdownInput;
    }

    // Regular dropdown without search - use DropdownButtonFormField for consistency
    // Simplified items without subtitles to prevent overflow
    // Subtitles are only shown in searchable dropdowns with custom overlay

    // Simplified item without subtitle to prevent overflow
    // Subtitle can be shown in the searchable dropdown only
    final items = widget.field.options
            ?.map<DropdownMenuItem<T>>(
              (option) => DropdownMenuItem<T>(
                value: option.value,
                enabled: option.enabled,
                child: Row(
                  children: [
                    if (option.icon != null) ...[
                      Icon(
                        option.icon,
                        size: design.iconSizeMd,
                        color: option.enabled ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                      ),
                      SizedBox(width: design.spacingSm),
                    ],
                    Expanded(
                      child: Text(
                        option.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: option.enabled ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList() ??
        [];

    // Build input decoration for regular dropdown
    VooFieldOption<T>? selectedOption;
    if (_currentValue != null) {
      try {
        selectedOption = widget.field.options?.firstWhere(
          (option) => option.value == _currentValue,
        );
      } catch (_) {
        // If not found in options, create a default one
        selectedOption = VooFieldOption<T>(
          value: _currentValue as T,
          label: _currentValue.toString(),
        );
      }
    }

    final decoration = _decorationBuilder.build<T>(
      context: context,
      field: widget.field,
      options: widget.options,
      hasError: hasError,
      isFocused: _isFocused,
      isOpen: _isOpen,
      error: widget.error,
      selectedOption: selectedOption,
    );

    // Create a new key to force rebuild when value changes
    final dropdownKey = ValueKey(_currentValue);

    return DropdownButtonFormField<T>(
      key: dropdownKey,
      initialValue: items.any((item) => item.value == _currentValue) ? _currentValue : null,
      items: items,
      onChanged: widget.field.enabled && !widget.field.readOnly
          ? (T? value) {
              setState(() {
                _currentValue = value;
              });
              widget.onChanged?.call(value);
              // Safely invoke field.onChanged if it exists
              _invokeFieldOnChanged(value);
            }
          : null,
      decoration: decoration,
      focusNode: _focusNode,
      style: theme.textTheme.bodyMedium,
      dropdownColor: theme.colorScheme.surface,
      isExpanded: true,
    );
  }
}
