import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

typedef AsyncOptionsLoader<T> = Future<List<VooFieldOption<T>>> Function(String query);

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

  @override
  void initState() {
    super.initState();
    _focusNode = widget.field.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _allOptions = widget.field.options ?? [];
    _filteredOptions = _allOptions;
    
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

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
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
                child: _buildDropdownMenu(),
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

  Widget _buildDropdownMenu() {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 300,
        maxWidth: 400,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(design.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.field.enableSearch) ...[
            Container(
              padding: EdgeInsets.all(design.spacingMd),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.field.searchHint ?? 'Search...',
                  prefixIcon: Icon(
                    Icons.search,
                    size: design.iconSizeMd,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: design.iconSizeSm,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(design.radiusSm),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(design.radiusSm),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: design.spacingMd,
                    vertical: design.spacingSm,
                  ),
                  isDense: true,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ],
          Flexible(
            child: _buildItemsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    if (_isLoading) {
      return Container(
        padding: EdgeInsets.all(design.spacingXl),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_filteredOptions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(design.spacingXl),
        child: Center(
          child: Text(
            'No results found',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: design.spacingSm),
      itemCount: _filteredOptions.length,
      itemBuilder: (context, index) {
        final option = _filteredOptions[index];
        final currentValue = widget.field.value ?? widget.field.initialValue;
        final isSelected = option.value == currentValue;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: option.enabled
                ? () {
                    final T? value = option.value;
                    widget.onChanged?.call(value);
                    // Call field.onChanged only if it exists
                    // This avoids type casting issues
                    if (widget.field.onChanged != null) {
                      try {
                        widget.field.onChanged!(value);
                      } catch (_) {
                        // Silently ignore type casting errors
                      }
                    }
                    setState(() {
                      // Force update to reflect new selection
                    });
                    _removeOverlay();
                    _searchController.clear();
                  }
                : null,
            hoverColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.08),
            highlightColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.12),
            child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: design.spacingLg,
              vertical: design.spacingMd,
            ),
            color: isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
                : null,
            child: Row(
              children: [
                if (option.icon != null) ...[
                  Icon(
                    option.icon,
                    size: design.iconSizeMd,
                    color: option.enabled
                        ? (isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface)
                        : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                  ),
                  SizedBox(width: design.spacingSm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        option.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: option.enabled
                              ? (isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface)
                              : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                          fontWeight: isSelected ? FontWeight.w500 : null,
                        ),
                      ),
                      if (option.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    size: design.iconSizeMd,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
          ),
        );
      },
    );
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
          _filteredOptions = _allOptions.where((option) {
            return option.label.toLowerCase().contains(query.toLowerCase()) ||
                (option.subtitle?.toLowerCase().contains(query.toLowerCase()) ?? false);
          }).toList();
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

  BoxDecoration _buildDecoration(
    BuildContext context,
    Color borderColor,
    bool isFocused,
  ) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    // Base decoration
    BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(design.radiusMd),
      border: Border.all(
        color: borderColor,
        width: isFocused ? 2 : 1,
      ),
    );
    
    // Apply field variant styling
    switch (widget.options.fieldVariant) {
      case FieldVariant.filled:
        decoration = BoxDecoration(
          color: widget.field.enabled
              ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(design.radiusMd),
          border: Border.all(
            color: borderColor,
            width: isFocused ? 2 : 1,
          ),
        );
        break;
      case FieldVariant.outlined:
        decoration = BoxDecoration(
          // No background color for outlined variant to match TextFormField
          borderRadius: BorderRadius.circular(design.radiusMd),
          border: Border.all(
            color: borderColor,
            width: isFocused ? 2 : 1,
          ),
        );
        break;
      case FieldVariant.underlined:
        decoration = BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: borderColor,
              width: isFocused ? 2 : 1,
            ),
          ),
        );
        break;
      case FieldVariant.ghost:
        decoration = BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(design.radiusMd),
          border: isFocused
              ? Border.all(
                  color: borderColor,
                  width: 2,
                )
              : null,
        );
        break;
      case FieldVariant.rounded:
        decoration = BoxDecoration(
          // No background color for rounded variant to match TextFormField
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: borderColor,
            width: isFocused ? 2 : 1,
          ),
        );
        break;
      case FieldVariant.sharp:
        decoration = BoxDecoration(
          // No background color for sharp variant to match TextFormField
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: borderColor,
            width: isFocused ? 2 : 1,
          ),
        );
        break;
      default:
        // Default to outlined (no background)
        decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(design.radiusMd),
          border: Border.all(
            color: borderColor,
            width: isFocused ? 2 : 1,
          ),
        );
    }
    
    return decoration;
  }

  VooFieldOption<T>? _getSelectedOption() {
    // Always use the current value from the field
    final currentValue = widget.field.value ?? widget.field.initialValue;
    if (currentValue == null) return null;
    
    try {
      return _allOptions.firstWhere((option) => option.value == currentValue);
    } catch (_) {
      // If we have an initial value but no matching option yet (async loading),
      // create a temporary option for display
      if (widget.field.initialValue != null && widget.field.asyncOptionsLoader != null) {
        return VooFieldOption<T>(
          value: widget.field.initialValue as T,
          label: widget.field.initialValue.toString(),
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

      Color borderColor;
      if (!widget.field.enabled) {
        borderColor = theme.colorScheme.outline.withValues(alpha: 0.3);
      } else if (hasError) {
        borderColor = theme.colorScheme.error;
      } else if (_isFocused || _isOpen) {
        borderColor = theme.colorScheme.primary;
      } else {
        borderColor = theme.colorScheme.outline;
      }

      // Build the dropdown input field
      Widget dropdownInput = CompositedTransformTarget(
        link: _layerLink,
        child: InkWell(
          onTap: widget.field.enabled && !widget.field.readOnly
              ? () {
                  if (_isOpen) {
                    _removeOverlay();
                  } else {
                    _showOverlay();
                  }
                }
              : null,
          borderRadius: BorderRadius.circular(design.radiusMd),
          child: Container(
            height: design.inputHeight,
            padding: EdgeInsets.symmetric(
              horizontal: design.spacingLg,
            ),
            decoration: _buildDecoration(
              context,
              borderColor,
              (_isFocused || _isOpen),
            ),
            child: Row(
              children: [
                if (widget.field.prefixIcon != null) ...[
                  Icon(
                    widget.field.prefixIcon,
                    size: design.iconSizeMd,
                    color: (_isFocused || _isOpen)
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: design.spacingMd),
                ],
                Expanded(
                  child: selectedOption != null
                      ? Row(
                          children: [
                            if (selectedOption.icon != null) ...[
                              Icon(
                                selectedOption.icon,
                                size: design.iconSizeMd,
                                color: theme.colorScheme.onSurface,
                              ),
                              SizedBox(width: design.spacingSm),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedOption.label,
                                    style: theme.textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (selectedOption.subtitle != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      selectedOption.subtitle!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        )
                      : Text(
                          widget.field.hint ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ),
                ),
                Icon(
                  _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: widget.field.enabled
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                ),
              ],
            ),
          ),
        ),
      );

      // Build the complete widget based on label position
      if (widget.options.labelPosition == LabelPosition.floating && widget.field.label != null) {
        // For floating label, include it in the widget structure
        return AnimatedContainer(
          duration: design.animationDurationFast,
          curve: design.animationCurve,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.field.label!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: hasError
                      ? theme.colorScheme.error
                      : (_isFocused || _isOpen)
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                  fontWeight: (_isFocused || _isOpen) ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              SizedBox(height: design.spacingXs),
              dropdownInput,
              if (widget.field.helper != null || errorText != null) ...[
                SizedBox(height: design.spacingXs),
                Text(
                  errorText ?? widget.field.helper ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: hasError ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        );
      } else {
        // For other label positions (above, left, hidden, placeholder)
        // Return just the input field, VooFieldWidget will handle label wrapping
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            dropdownInput,
            if (widget.field.helper != null || errorText != null) ...[
              SizedBox(height: design.spacingXs),
              Text(
                errorText ?? widget.field.helper ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: hasError ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        );
      }
    }

    // Regular dropdown without search - use VooDropdown from voo_ui_core
    final items = widget.field.options?.map<VooDropdownItem<T>>((option) {
          return VooDropdownItem<T>(
            value: option.value,
            label: option.label,
            subtitle: option.subtitle,
            icon: option.icon,
            enabled: option.enabled,
          );
        }).toList() ??
        [];

    // Only pass label to VooDropdown if labelPosition is floating
    // For above/left positions, VooFieldWidget handles the label
    final shouldShowLabel = widget.options.labelPosition == LabelPosition.floating ||
                           widget.options.labelPosition == LabelPosition.placeholder;

    // Use value if available, otherwise fall back to initialValue
    final currentValue = widget.field.value ?? widget.field.initialValue;
    
    return VooDropdown<T>(
      value: currentValue,
      items: items,
      onChanged: widget.field.enabled && !widget.field.readOnly
          ? (T? value) {
              widget.onChanged?.call(value);
              // Call field.onChanged only if it exists
              // This avoids type casting issues
              if (widget.field.onChanged != null) {
                try {
                  widget.field.onChanged!(value);
                } catch (_) {
                  // Silently ignore type casting errors
                }
              }
            }
          : null,
      label: shouldShowLabel ? widget.field.label : null,
      hint: widget.field.hint,
      helper: widget.field.helper,
      error: errorText,
      prefixIcon: widget.field.prefixIcon,
      enabled: widget.field.enabled && !widget.field.readOnly,
    );
  }
}