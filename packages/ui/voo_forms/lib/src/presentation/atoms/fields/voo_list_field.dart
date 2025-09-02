import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_widget.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Widget for displaying and managing a list of form fields
/// Supports adding, removing, and optionally reordering items
class VooListFieldWidget<T> extends StatefulWidget {
  final VooFormField<List<T>> field;
  final VooFieldOptions options;
  final ValueChanged<List<T>?>? onChanged;
  final String? error;
  final bool showError;

  const VooListFieldWidget({
    super.key,
    required this.field,
    required this.options,
    this.onChanged,
    this.error,
    this.showError = true,
  });

  @override
  State<VooListFieldWidget<T>> createState() => _VooListFieldWidgetState<T>();
}

class _VooListFieldWidgetState<T> extends State<VooListFieldWidget<T>> {
  late List<VooFormField> _items;
  late List<GlobalKey> _itemKeys;
  
  @override
  void initState() {
    super.initState();
    _initializeItems();
  }
  
  void _initializeItems() {
    _items = List.from(widget.field.listItems ?? []);
    _itemKeys = List.generate(_items.length, (_) => GlobalKey());
    
    // Ensure minimum items
    if (widget.field.minItems != null) {
      while (_items.length < widget.field.minItems!) {
        _addItem();
      }
    }
  }
  
  @override
  void didUpdateWidget(VooListFieldWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.field.listItems != oldWidget.field.listItems) {
      _initializeItems();
    }
  }
  
  void _addItem() {
    if (widget.field.maxItems != null && _items.length >= widget.field.maxItems!) {
      // Show error or toast about max items reached
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum ${widget.field.maxItems} items allowed'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Use timestamp to ensure unique IDs
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final template = widget.field.itemTemplate!;
    
    setState(() {
      _items.add(
        template.copyWith(
          id: '${widget.field.name}_item_$timestamp',
          name: '${widget.field.name}_$timestamp',
          value: null,
        ),
      );
      _itemKeys.add(GlobalKey());
    });
    
    _notifyChange();
  }
  
  void _removeItem(int index) {
    if (widget.field.minItems != null && _items.length <= widget.field.minItems!) {
      // Show error about minimum items required
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Minimum ${widget.field.minItems} items required'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    
    setState(() {
      _items.removeAt(index);
      _itemKeys.removeAt(index);
      // Don't re-index the items to preserve their state
    });
    
    _notifyChange();
  }
  
  void _onItemChanged(int index, dynamic value) {
    setState(() {
      _items[index] = _items[index].copyWith(value: value);
    });
    _notifyChange();
  }
  
  void _notifyChange() {
    final values = _items.map((item) => item.value as T?).where((v) => v != null).cast<T>().toList();
    widget.onChanged?.call(values.isEmpty ? null : values);
  }
  
  void _moveItem(int oldIndex, int newIndex) {
    var adjustedNewIndex = newIndex;
    if (adjustedNewIndex > oldIndex) {
      adjustedNewIndex -= 1;
    }
    
    setState(() {
      final item = _items.removeAt(oldIndex);
      final key = _itemKeys.removeAt(oldIndex);
      _items.insert(adjustedNewIndex, item);
      _itemKeys.insert(adjustedNewIndex, key);
      // Don't re-index the items to preserve their state
    });
    
    _notifyChange();
  }
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final errorText = widget.showError ? (widget.error ?? widget.field.error) : null;
    final hasError = errorText != null && errorText.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label - only show if not using above/left label position
        if (widget.field.label != null && 
            widget.options.labelPosition != LabelPosition.above &&
            widget.options.labelPosition != LabelPosition.left) ...[
          Text(
            widget.field.label!,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: hasError ? theme.colorScheme.error : null,
            ),
          ),
          SizedBox(height: design.spacingXs),
        ],
        
        // Helper text
        if (widget.field.helper != null && !hasError) ...[
          Text(
            widget.field.helper!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: design.spacingSm),
        ],
        
        // List items
        if (widget.field.canReorderItems && !widget.field.readOnly)
          _buildReorderableList(design, theme)
        else
          _buildStaticList(design, theme),
        
        // Add button
        if (widget.field.canAddItems && !widget.field.readOnly) ...[
          SizedBox(height: design.spacingMd),
          _buildAddButton(theme),
        ],
        
        // Error text
        if (hasError) ...[
          SizedBox(height: design.spacingXs),
          Text(
            errorText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildStaticList(VooDesignSystemData design, ThemeData theme) => Column(
      children: [
        for (int i = 0; i < _items.length; i++) ...[
          Container(
            key: _itemKeys[i],
            margin: i < _items.length - 1 
                ? EdgeInsets.only(bottom: design.spacingMd)
                : EdgeInsets.zero,
            child: _buildListItem(i, design, theme),
          ),
        ],
      ],
    );
  
  Widget _buildReorderableList(VooDesignSystemData design, ThemeData theme) => ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      onReorder: _moveItem,
      itemBuilder: (context, index) => Container(
          key: _itemKeys[index],
          margin: index < _items.length - 1 
              ? EdgeInsets.only(bottom: design.spacingMd)
              : EdgeInsets.zero,
          child: _buildListItem(index, design, theme),
        ),
    );
  
  Widget _buildListItem(int index, VooDesignSystemData design, ThemeData theme) {
    final item = _items[index];
    
    return Container(
      padding: EdgeInsets.all(design.spacingSm),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(design.radiusMd),
      ),
      child: Row(
        children: [
          // Drag handle for reorderable lists
          if (widget.field.canReorderItems && !widget.field.readOnly) ...[
            Icon(
              Icons.drag_indicator,
              size: design.iconSizeMd,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: design.spacingSm),
          ],
          
          // Field widget
          Expanded(
            child: VooFieldWidget(
              field: item,
              options: widget.options.copyWith(
                labelPosition: LabelPosition.floating,
              ),
              onChanged: (value) => _onItemChanged(index, value),
            ),
          ),
          
          // Remove button
          if (widget.field.canRemoveItems && !widget.field.readOnly) ...[
            SizedBox(width: design.spacingSm),
            IconButton(
              onPressed: () => _removeItem(index),
              icon: widget.field.removeButtonIcon ?? 
                    Icon(Icons.remove_circle_outline),
              color: theme.colorScheme.error,
              tooltip: widget.field.removeButtonText ?? 'Remove',
              constraints: const BoxConstraints(),
              padding: EdgeInsets.all(design.spacingXs),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildAddButton(ThemeData theme) {
    return OutlinedButton.icon(
      onPressed: widget.field.enabled ? _addItem : null,
      icon: widget.field.addButtonIcon ?? 
            const Icon(Icons.add_circle_outline),
      label: Text(widget.field.addButtonText ?? 'Add Item'),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
      ),
    );
  }
}