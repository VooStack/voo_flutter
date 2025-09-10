import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/overlays/voo_dropdown_overlay.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

/// Internal stateful widget for multi-select field
class MultiSelectFieldWidget<T> extends StatefulWidget {
  final VooMultiSelectField<T> field;

  const MultiSelectFieldWidget({
    super.key,
    required this.field,
  });

  @override
  State<MultiSelectFieldWidget<T>> createState() => MultiSelectFieldWidgetState<T>();
}

/// State for internal multi-select field widget
class MultiSelectFieldWidgetState<T> extends State<MultiSelectFieldWidget<T>> {
  late List<T> _selectedValues;
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  late final VooDropdownOverlayController _overlayController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedValues = List<T>.from(widget.field.initialValue ?? []);
    _overlayController = VooDropdownOverlayController(
      context: context,
      layerLink: _layerLink,
    );
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get the form controller from scope if available
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    
    if (formController != null) {
      // Get value from form controller if available
      final currentValue = formController.getValue(widget.field.name);
      
      if (currentValue != null) {
        // Use the value from the controller
        setState(() {
          _selectedValues = List<T>.from(currentValue as List<T>? ?? []);
        });
      } else if (widget.field.initialValue != null) {
        // If controller doesn't have a value but field has initial value, set it
        setState(() {
          _selectedValues = List<T>.from(widget.field.initialValue!);
        });
        formController.setValue(widget.field.name, _selectedValues, isUserInput: false);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MultiSelectFieldWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected values if initialValue changes
    if (widget.field.initialValue != oldWidget.field.initialValue) {
      setState(() {
        _selectedValues = List<T>.from(widget.field.initialValue ?? []);
      });
    }
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
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            _overlayController.rebuild();
          },
        ),
        header: _buildHeader(),
        child: _buildOptionsList(),
      ),
    );
    setState(() {});
  }

  void _closeDropdown() {
    setState(() {
      _searchQuery = '';
    });
    _searchController.clear();
    _overlayController.close();
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

  void _selectAll() {
    setState(() {
      _selectedValues = List<T>.from(widget.field.options);
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

  List<T> _getFilteredOptions() {
    if (_searchQuery.isEmpty) {
      return widget.field.options;
    }

    if (widget.field.searchFilter != null) {
      return widget.field.options.where((item) => widget.field.searchFilter!(item, _searchQuery)).toList();
    }

    // Default search filter using display text
    final displayBuilder = widget.field.displayTextBuilder ?? (item) => item.toString();
    return widget.field.options
        .where(
          (item) => displayBuilder(item).toLowerCase().contains(_searchQuery.toLowerCase()),
        )
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
    if (!widget.field.showSelectAll && !widget.field.showClearAll) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.field.showSelectAll)
            Flexible(
              child: TextButton.icon(
                onPressed: _selectAll,
                icon: const Icon(Icons.select_all, size: 16),
                label: const Text('Select All', overflow: TextOverflow.ellipsis),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 36),
                ),
              ),
            ),
          if (widget.field.showClearAll)
            Flexible(
              child: TextButton.icon(
                onPressed: _clearAll,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear All', overflow: TextOverflow.ellipsis),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 36),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionsList() {
    final theme = Theme.of(context);
    final filteredOptions = _getFilteredOptions();

    if (filteredOptions.isEmpty) {
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
      children: filteredOptions.map((item) {
        final isSelected = _selectedValues.contains(item);
        final displayText = _getDisplayText(item);
        
        // Use custom option builder if provided
        if (widget.field.optionBuilder != null) {
          return InkWell(
            onTap: () => _handleSelectionChange(item),
            child: widget.field.optionBuilder!(context, item, isSelected, displayText),
          );
        }
        
        // Default option rendering
        return ListTile(
          dense: true,
          leading: Checkbox(
            value: isSelected,
            onChanged: (_) => _handleSelectionChange(item),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          title: Text(
            displayText,
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

    // If read-only, show VooReadOnlyField with comma-separated values
    if (effectiveReadOnly) {
      final displayValue = _selectedValues.isEmpty 
          ? ''
          : _selectedValues.map(_getDisplayText).join(', ');
      
      Widget readOnlyContent = VooReadOnlyField(
        value: displayValue,
        icon: widget.field.prefixIcon ?? widget.field.suffixIcon,
      );
      
      // Apply standard field building pattern
      readOnlyContent = widget.field.buildWithHelper(context, readOnlyContent);
      readOnlyContent = widget.field.buildWithError(context, readOnlyContent);
      readOnlyContent = widget.field.buildWithLabel(context, readOnlyContent);
      readOnlyContent = widget.field.buildWithActions(context, readOnlyContent);
      
      return widget.field.buildFieldContainer(context, readOnlyContent);
    }

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