import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/overlays/voo_dropdown_overlay.dart';
import 'package:voo_forms/voo_forms.dart';

/// Internal stateful widget for async multi-select field
class AsyncMultiSelectFieldWidget<T> extends StatefulWidget {
  final VooAsyncMultiSelectField<T> field;

  const AsyncMultiSelectFieldWidget({
    super.key,
    required this.field,
  });

  @override
  State<AsyncMultiSelectFieldWidget<T>> createState() => AsyncMultiSelectFieldWidgetState<T>();
}

/// State for internal async multi-select field widget
class AsyncMultiSelectFieldWidgetState<T> extends State<AsyncMultiSelectFieldWidget<T>> {
  late List<T> _selectedValues;
  List<T> _availableOptions = [];
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isLoading = false;
  final _layerLink = LayerLink();
  late final VooDropdownOverlayController _overlayController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _selectedValues = List<T>.from(widget.field.initialValue ?? []);
    _overlayController = VooDropdownOverlayController(
      context: context,
      layerLink: _layerLink,
    );
    // Load initial options
    _loadOptions('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    _overlayController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AsyncMultiSelectFieldWidget<T> oldWidget) {
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
        _overlayController.rebuild();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _overlayController.rebuild();
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
    if (_overlayController.isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    _overlayController.open(
      width: size.width,
      maxHeight: widget.field.maxDropdownHeight ?? 300,
      builder: (close) => VooDropdownOverlay(
        layerLink: _layerLink,
        width: size.width,
        maxHeight: widget.field.maxDropdownHeight ?? 300,
        onClose: () {
          _closeDropdown();
          close();
        },
        searchConfig: VooDropdownSearchConfig(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
        ),
        header: _buildHeader(),
        child: _buildOptionsList(),
      ),
    );
    setState(() {});
  }

  void _closeDropdown() {
    _searchController.clear();
    _debounceTimer?.cancel();
    _overlayController.close();
    setState(() {});
  }

  void _handleSelectionChange(T item) {
    setState(() {
      if (_selectedValues.contains(item)) {
        _selectedValues.remove(item);
      } else {
        _selectedValues.add(item);
      }
    });

    // Update the overlay to reflect selection changes
    _overlayController.rebuild();

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

    // Update the overlay to reflect selection changes
    _overlayController.rebuild();

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
        widget.field.emptySelectionText ?? widget.field.placeholder ?? 'Select items...',
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              labelPadding: const EdgeInsets.only(left: 4),
            ),
        ),
        if (remaining > 0)
          Chip(
            label: Text(
              '+$remaining more',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    if (!widget.field.showClearAll || _selectedValues.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
    );
  }

  Widget _buildOptionsList() {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: widget.field.loadingIndicator ?? const CircularProgressIndicator(),
        ),
      );
    }

    if (_availableOptions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No items found',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView(
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
          selectedTileColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        );
      }).toList(),
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
                suffixIcon: AnimatedRotation(
                  turns: _overlayController.isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: widget.field.dropdownIcon ?? const Icon(Icons.arrow_drop_down),
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