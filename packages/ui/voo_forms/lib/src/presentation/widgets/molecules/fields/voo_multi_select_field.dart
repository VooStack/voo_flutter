import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();
    
    return _MultiSelectFieldWidget<T>(field: this);
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

/// Internal stateful widget for multi-select field
class _MultiSelectFieldWidget<T> extends StatefulWidget {
  final VooMultiSelectField<T> field;

  const _MultiSelectFieldWidget({
    required this.field,
  });

  @override
  State<_MultiSelectFieldWidget<T>> createState() => _MultiSelectFieldWidgetState<T>();
}

class _MultiSelectFieldWidgetState<T> extends State<_MultiSelectFieldWidget<T>> {
  late List<T> _selectedValues;
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedValues = List<T>.from(widget.field.initialValue ?? []);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && _isOpen) {
      _closeDropdown();
    }
  }

  @override
  void didUpdateWidget(_MultiSelectFieldWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected values if initialValue changes
    if (widget.field.initialValue != oldWidget.field.initialValue) {
      setState(() {
        _selectedValues = List<T>.from(widget.field.initialValue ?? []);
      });
    }
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
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _focusNode.requestFocus();
  }

  void _closeDropdown() {
    setState(() {
      _isOpen = false;
      _searchQuery = '';
    });
    _searchController.clear();
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleSelectionChange(T item) {
    setState(() {
      if (_selectedValues.contains(item)) {
        _selectedValues.remove(item);
      } else {
        _selectedValues.add(item);
      }
    });
    
    // Update form controller if available
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    if (formController != null) {
      formController.setValue(widget.field.name, _selectedValues, validate: true);
    }
    
    // Call user's onChanged if provided
    widget.field.onChanged?.call(_selectedValues);
  }

  void _selectAll() {
    setState(() {
      _selectedValues = List<T>.from(widget.field.options);
    });
    
    // Update form controller and call onChanged
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    if (formController != null) {
      formController.setValue(widget.field.name, _selectedValues, validate: true);
    }
    widget.field.onChanged?.call(_selectedValues);
  }

  void _clearAll() {
    setState(() {
      _selectedValues.clear();
    });
    
    // Update form controller and call onChanged
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    if (formController != null) {
      formController.setValue(widget.field.name, _selectedValues, validate: true);
    }
    widget.field.onChanged?.call(_selectedValues);
  }

  List<T> _getFilteredOptions() {
    if (_searchQuery.isEmpty) {
      return widget.field.options;
    }
    
    if (widget.field.searchFilter != null) {
      return widget.field.options
          .where((item) => widget.field.searchFilter!(item, _searchQuery))
          .toList();
    }
    
    // Default search filter using display text
    final displayBuilder = widget.field.displayTextBuilder ?? (item) => item.toString();
    return widget.field.options
        .where((item) => displayBuilder(item)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  String _getDisplayText(T item) {
    if (widget.field.displayTextBuilder != null) {
      return widget.field.displayTextBuilder!(item);
    }
    return item.toString();
  }

  Widget _buildSelectedChips() {
    if (_selectedValues.isEmpty) {
      return Text(
        widget.field.emptySelectionText ?? 
        widget.field.placeholder ?? 
        'Select items...',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).hintColor,
        ),
      );
    }

    final maxDisplay = widget.field.maxChipsDisplay ?? 3;
    final displayItems = _selectedValues.take(maxDisplay).toList();
    final remaining = _selectedValues.length - displayItems.length;

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        ...displayItems.map((item) => Chip(
          label: Text(
            _getDisplayText(item),
            style: const TextStyle(fontSize: 12),
          ),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: widget.field.enabled && !widget.field.getEffectiveReadOnly(context)
              ? () => _handleSelectionChange(item)
              : null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          labelPadding: const EdgeInsets.only(left: 4),
        )),
        if (remaining > 0)
          Chip(
            label: Text(
              '+$remaining more',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          ),
      ],
    );
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final theme = Theme.of(context);
    
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 8),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: widget.field.maxDropdownHeight ?? 300,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search field
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                        // Update overlay
                        _overlayEntry?.markNeedsBuild();
                      },
                    ),
                  ),
                  // Action buttons
                  if (widget.field.showSelectAll || widget.field.showClearAll)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.field.showSelectAll)
                            TextButton.icon(
                              onPressed: _selectAll,
                              icon: const Icon(Icons.select_all, size: 18),
                              label: const Text('Select All'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          if (widget.field.showClearAll)
                            TextButton.icon(
                              onPressed: _clearAll,
                              icon: const Icon(Icons.clear_all, size: 18),
                              label: const Text('Clear All'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  const Divider(height: 1),
                  // Options list
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: _getFilteredOptions().map((item) {
                        final isSelected = _selectedValues.contains(item);
                        return ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: isSelected,
                            onChanged: (_) => _handleSelectionChange(item),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          title: Text(
                            _getDisplayText(item),
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          onTap: () => _handleSelectionChange(item),
                          selected: isSelected,
                          selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveReadOnly = widget.field.getEffectiveReadOnly(context);
    final theme = Theme.of(context);
    
    // Get the error for this field
    final fieldError = widget.field.getFieldError(context);

    // Build the main input field
    Widget fieldContent = CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: widget.field.enabled && !effectiveReadOnly ? _toggleDropdown : null,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: widget.field.getInputDecoration(context).copyWith(
            errorText: fieldError,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedValues.isNotEmpty && widget.field.showClearAll && !effectiveReadOnly)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: _clearAll,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: widget.field.dropdownIcon ?? const Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
          ),
          child: _buildSelectedChips(),
        ),
      ),
    );

    // Apply standard field building pattern
    fieldContent = widget.field.buildWithHelper(context, fieldContent);
    fieldContent = widget.field.buildWithLabel(context, fieldContent);
    fieldContent = widget.field.buildWithActions(context, fieldContent);

    return widget.field.buildFieldContainer(context, fieldContent);
  }
}
/// Async multi-select field that loads options asynchronously
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
  });

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();
    
    return _AsyncMultiSelectFieldWidget<T>(field: this);
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

/// Internal stateful widget for async multi-select field
class _AsyncMultiSelectFieldWidget<T> extends StatefulWidget {
  final VooAsyncMultiSelectField<T> field;

  const _AsyncMultiSelectFieldWidget({
    required this.field,
  });

  @override
  State<_AsyncMultiSelectFieldWidget<T>> createState() => _AsyncMultiSelectFieldWidgetState<T>();
}

class _AsyncMultiSelectFieldWidgetState<T> extends State<_AsyncMultiSelectFieldWidget<T>> {
  late List<T> _selectedValues;
  List<T> _availableOptions = [];
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isOpen = false;
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _selectedValues = List<T>.from(widget.field.initialValue ?? []);
    _focusNode.addListener(_onFocusChanged);
    // Load initial options
    _loadOptions('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _debounceTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && _isOpen) {
      _closeDropdown();
    }
  }

  @override
  void didUpdateWidget(_AsyncMultiSelectFieldWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected values if initialValue changes
    if (widget.field.initialValue != oldWidget.field.initialValue) {
      setState(() {
        _selectedValues = List<T>.from(widget.field.initialValue ?? []);
      });
    }
  }

  Future<void> _loadOptions(String query) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final options = await widget.field.asyncOptionsLoader(query);
      if (mounted) {
        setState(() {
          _availableOptions = options;
          _isLoading = false;
        });
        _overlayEntry?.markNeedsBuild();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.field.searchDebounce, () {
      _loadOptions(value);
    });
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
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _focusNode.requestFocus();
  }

  void _closeDropdown() {
    setState(() {
      _isOpen = false;
    });
    _searchController.clear();
    _debounceTimer?.cancel();
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleSelectionChange(T item) {
    setState(() {
      if (_selectedValues.contains(item)) {
        _selectedValues.remove(item);
      } else {
        _selectedValues.add(item);
      }
    });
    
    // Update form controller if available
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    if (formController != null) {
      formController.setValue(widget.field.name, _selectedValues, validate: true);
    }
    
    // Call user's onChanged if provided
    widget.field.onChanged?.call(_selectedValues);
  }

  void _clearAll() {
    setState(() {
      _selectedValues.clear();
    });
    
    // Update form controller and call onChanged
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    if (formController != null) {
      formController.setValue(widget.field.name, _selectedValues, validate: true);
    }
    widget.field.onChanged?.call(_selectedValues);
  }

  String _getDisplayText(T item) {
    if (widget.field.displayTextBuilder != null) {
      return widget.field.displayTextBuilder!(item);
    }
    return item.toString();
  }

  Widget _buildSelectedChips() {
    if (_selectedValues.isEmpty) {
      return Text(
        widget.field.emptySelectionText ?? 
        widget.field.placeholder ?? 
        'Select items...',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).hintColor,
        ),
      );
    }

    final maxDisplay = widget.field.maxChipsDisplay ?? 3;
    final displayItems = _selectedValues.take(maxDisplay).toList();
    final remaining = _selectedValues.length - displayItems.length;

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        ...displayItems.map((item) => Chip(
          label: Text(
            _getDisplayText(item),
            style: const TextStyle(fontSize: 12),
          ),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: widget.field.enabled && !widget.field.getEffectiveReadOnly(context)
              ? () => _handleSelectionChange(item)
              : null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          labelPadding: const EdgeInsets.only(left: 4),
        )),
        if (remaining > 0)
          Chip(
            label: Text(
              '+$remaining more',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          ),
      ],
    );
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final theme = Theme.of(context);
    
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 8),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: widget.field.maxDropdownHeight ?? 300,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search field
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  // Action buttons
                  if (widget.field.showClearAll && _selectedValues.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: _clearAll,
                            icon: const Icon(Icons.clear_all, size: 18),
                            label: const Text('Clear All'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 1),
                  // Options list or loading indicator
                  Flexible(
                    child: _isLoading
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: widget.field.loadingIndicator ??
                                  const CircularProgressIndicator(),
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            children: _availableOptions.map((item) {
                              final isSelected = _selectedValues.contains(item);
                              return ListTile(
                                dense: true,
                                leading: Checkbox(
                                  value: isSelected,
                                  onChanged: (_) => _handleSelectionChange(item),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                title: Text(
                                  _getDisplayText(item),
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                                onTap: () => _handleSelectionChange(item),
                                selected: isSelected,
                                selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveReadOnly = widget.field.getEffectiveReadOnly(context);
    
    // Get the error for this field
    final fieldError = widget.field.getFieldError(context);

    // Build the main input field
    Widget fieldContent = CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: widget.field.enabled && !effectiveReadOnly ? _toggleDropdown : null,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: widget.field.getInputDecoration(context).copyWith(
            errorText: fieldError,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedValues.isNotEmpty && widget.field.showClearAll && !effectiveReadOnly)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: _clearAll,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: widget.field.dropdownIcon ?? const Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
          ),
          child: _buildSelectedChips(),
        ),
      ),
    );

    // Apply standard field building pattern
    fieldContent = widget.field.buildWithHelper(context, fieldContent);
    fieldContent = widget.field.buildWithLabel(context, fieldContent);
    fieldContent = widget.field.buildWithActions(context, fieldContent);

    return widget.field.buildFieldContainer(context, fieldContent);
  }
}
