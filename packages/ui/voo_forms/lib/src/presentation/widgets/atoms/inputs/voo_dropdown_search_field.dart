import 'dart:async';

import 'package:flutter/material.dart';

/// Atomic dropdown with search field widget
/// Provides a searchable dropdown with filtering capabilities
class VooDropdownSearchField<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String Function(T)? displayTextBuilder;
  final String Function(T)? subtitleBuilder;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool enabled;
  final Widget? icon;
  final int Function(T a, T b)? sortComparator;
  final bool Function(T item, String searchTerm)? searchFilter;
  final Future<List<T>> Function(String searchTerm)? asyncSearch;
  final Duration searchDebounce;
  final InputDecoration? decoration;
  final Widget Function(BuildContext context, T item, bool isSelected, String displayText)? optionBuilder;

  const VooDropdownSearchField({
    super.key,
    required this.items,
    this.value,
    this.displayTextBuilder,
    this.subtitleBuilder,
    this.onChanged,
    this.hint,
    this.enabled = true,
    this.icon,
    this.sortComparator,
    this.searchFilter,
    this.asyncSearch,
    this.searchDebounce = const Duration(milliseconds: 500),
    this.decoration,
    this.optionBuilder,
  });

  @override
  State<VooDropdownSearchField<T>> createState() => _VooDropdownSearchFieldState<T>();
}

class _VooDropdownSearchFieldState<T> extends State<VooDropdownSearchField<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<T> _filteredItems = [];
  T? _selectedValue;
  bool _isOpen = false;
  bool _isLoading = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _filteredItems = _getSortedItems(widget.items);

    // Update search controller text if there's an initial value
    if (_selectedValue != null && widget.displayTextBuilder != null) {
      _searchController.text = widget.displayTextBuilder!(_selectedValue as T);
    }

    // If async search is provided, load initial items
    if (widget.asyncSearch != null) {
      _loadAsyncItems('');
    }
  }

  @override
  void didUpdateWidget(VooDropdownSearchField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedValue = widget.value;
    }
    if (widget.items != oldWidget.items) {
      _filteredItems = _getSortedItems(widget.items);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _debounceTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  List<T> _getSortedItems(List<T> items) {
    if (widget.sortComparator != null) {
      return List<T>.from(items)..sort(widget.sortComparator);
    }
    return items;
  }

  Future<void> _loadAsyncItems(String searchTerm) async {
    if (widget.asyncSearch == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final items = await widget.asyncSearch!(searchTerm);
      if (mounted) {
        setState(() {
          _filteredItems = _getSortedItems(items);
          _isLoading = false;

          // Ensure the selected value is preserved after async load
          // This helps maintain the initial value
          if (_selectedValue == null && widget.value != null) {
            _selectedValue = widget.value;
          }
        });
        _updateOverlay();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterItems(String searchTerm) {
    // If async search is provided, use debounced async loading
    if (widget.asyncSearch != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.searchDebounce, () {
        _loadAsyncItems(searchTerm);
      });
      return;
    }

    // Otherwise use local filtering
    setState(() {
      if (searchTerm.isEmpty) {
        _filteredItems = _getSortedItems(widget.items);
      } else {
        _filteredItems = _getSortedItems(
          widget.items.where((item) {
            if (widget.searchFilter != null) {
              return widget.searchFilter!(item, searchTerm);
            }
            final displayText = widget.displayTextBuilder?.call(item) ?? item.toString();
            return displayText.toLowerCase().contains(searchTerm.toLowerCase());
          }).toList(),
        );
      }
    });
    _updateOverlay();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() {
      _isOpen = true;
    });
    _createOverlay();
  }

  void _closeDropdown() {
    setState(() {
      _isOpen = false;
      _searchController.clear();
      _filteredItems = _getSortedItems(widget.items);
    });
    _removeOverlay();

    // Unfocus to close keyboard if it was open
    _searchFocus.unfocus();
  }

  void _selectItem(T item) {
    setState(() {
      _selectedValue = item;
    });
    widget.onChanged?.call(item);
    _closeDropdown();
  }

  void _createOverlay() {
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlay() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;
    final theme = Theme.of(context);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Full screen gesture detector to capture outside clicks
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Dropdown overlay
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surface,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                            ),
                          ),
                          onChanged: _filterItems,
                          autofocus: true,
                        ),
                      ),
                      // Linear progress indicator when loading
                      if (_isLoading)
                        LinearProgressIndicator(
                          backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                          minHeight: 2,
                        ),
                      if (!_isLoading) const Divider(height: 1),
                      // Options list
                      Flexible(
                        child: _filteredItems.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('No items found', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                itemCount: _filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = _filteredItems[index];
                                  final isSelected = item == _selectedValue;
                                  final displayText = widget.displayTextBuilder?.call(item) ?? item.toString();

                                  // Use custom option builder if provided
                                  if (widget.optionBuilder != null) {
                                    return InkWell(onTap: () => _selectItem(item), child: widget.optionBuilder!(context, item, isSelected, displayText));
                                  }

                                  // Default option rendering with subtitle support
                                  final subtitle = widget.subtitleBuilder?.call(item);

                                  return InkWell(
                                    onTap: () => _selectItem(item),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : null,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: subtitle != null
                                                ? Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        displayText,
                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                          color: isSelected ? theme.colorScheme.primary : null,
                                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        subtitle,
                                                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    displayText,
                                                    style: theme.textTheme.bodyMedium?.copyWith(color: isSelected ? theme.colorScheme.primary : null),
                                                  ),
                                          ),
                                          if (isSelected) Icon(Icons.check, size: 20, color: theme.colorScheme.primary),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = _selectedValue != null ? (widget.displayTextBuilder?.call(_selectedValue as T) ?? _selectedValue.toString()) : null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: widget.enabled ? _toggleDropdown : null,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration:
              widget.decoration?.copyWith(
                suffixIcon:
                    widget.icon ??
                    Icon(_isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: widget.enabled ? null : theme.colorScheme.onSurfaceVariant),
              ) ??
              InputDecoration(
                hintText: widget.hint,
                filled: true,
                fillColor: widget.enabled ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                ),
                suffixIcon:
                    widget.icon ??
                    Icon(_isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: widget.enabled ? null : theme.colorScheme.onSurfaceVariant),
              ),
          child: displayText != null ? Text(displayText, style: theme.textTheme.bodyLarge) : null,
        ),
      ),
    );
  }
}
