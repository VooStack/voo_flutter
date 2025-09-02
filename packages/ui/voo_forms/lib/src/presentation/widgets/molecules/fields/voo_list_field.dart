import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_layout.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';

/// List field molecule that displays a list of items
/// IMPORTANT: This widget does NOT manage state internally
/// The developer is responsible for managing items via callbacks
///
/// Example:
/// ```dart
/// VooListField<Note>(
///   name: 'notes',
///   items: myNotes,  // Your state
///   itemBuilder: (context, note, index) => VooTextField(...),
///   onAddPressed: () => setState(() => myNotes.add(Note())),
///   onRemovePressed: (index) => setState(() => myNotes.removeAt(index)),
/// )
/// ```
class VooListField<T> extends VooFieldBase<List<T>> {
  /// Current items to display (managed externally by developer)
  final List<T> items;

  /// Builder for creating item widgets
  /// The developer is responsible for creating the appropriate widget for each item
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Callback when add button is pressed
  /// Developer should handle adding items to their state
  final VoidCallback? onAddPressed;

  /// Callback when remove button is pressed for an item
  /// Developer should handle removing items from their state
  final void Function(int index)? onRemovePressed;

  /// Callback when items are reordered
  /// Developer should handle reordering items in their state
  final void Function(int oldIndex, int newIndex)? onReorder;

  /// Whether to show add button
  final bool showAddButton;

  /// Whether to show remove buttons
  final bool showRemoveButtons;

  /// Whether items can be reordered
  final bool canReorderItems;

  /// Text for add button
  final String? addButtonText;

  /// Icon for add button
  final Widget? addButtonIcon;

  /// Text for remove button tooltip
  final String? removeButtonTooltip;

  /// Icon for remove button
  final Widget? removeButtonIcon;

  /// Whether to show item numbers
  final bool showItemNumbers;

  /// Whether to show borders around items
  final bool showItemBorders;

  /// Custom empty state widget
  final Widget? emptyStateWidget;

  /// Custom item decoration
  final BoxDecoration? itemDecoration;

  /// Spacing between items
  final double itemSpacing;

  const VooListField({
    super.key,
    required super.name,
    super.label,
    super.hint,
    super.helper,
    super.placeholder,
    super.required,
    super.enabled,
    super.readOnly,
    super.validators,
    super.actions,
    super.prefixIcon,
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    super.layout = VooFieldLayout.wide, // List fields default to full width
    required this.items,
    required this.itemBuilder,
    this.onAddPressed,
    this.onRemovePressed,
    this.onReorder,
    this.showAddButton = true,
    this.showRemoveButtons = true,
    this.canReorderItems = false,
    this.addButtonText,
    this.addButtonIcon,
    this.removeButtonTooltip,
    this.removeButtonIcon,
    this.showItemNumbers = false,
    this.showItemBorders = true,
    this.emptyStateWidget,
    this.itemDecoration,
    this.itemSpacing = 12.0,
  });

  @override
  List<T> get value => items;

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();
    
    final theme = Theme.of(context);

    Widget listContent;

    // Show empty state if no items
    if (items.isEmpty && emptyStateWidget != null) {
      listContent = emptyStateWidget!;
    } else if (items.isEmpty) {
      listContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            placeholder ?? 'No items added yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    } else if (canReorderItems && !readOnly && onReorder != null) {
      // Reorderable list
      listContent = ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        onReorder: onReorder!,
        proxyDecorator: (child, index, animation) => AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Material(
            elevation: 8,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
          child: child,
        ),
        itemBuilder: (context, index) => Container(
          key: ValueKey(index), // Simple index key for ReorderableListView
          margin: EdgeInsets.only(bottom: index < items.length - 1 ? itemSpacing : 0),
          child: itemBuilder(context, items[index], index),
        ),
      );
    } else {
      // Static list - let users control their own keys through itemBuilder
      listContent = Column(
        children: [
          for (int i = 0; i < items.length; i++)
            Container(
              margin: EdgeInsets.only(bottom: i < items.length - 1 ? itemSpacing : 0),
              child: itemBuilder(context, items[i], i),
            ),
        ],
      );
    }

    // Build the complete field
    Widget result = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        listContent,
        if (showAddButton && !readOnly && onAddPressed != null) ...[
          SizedBox(height: itemSpacing),
          _buildAddButton(theme),
        ],
      ],
    );

    // Apply standard field building pattern
    result = buildWithHelper(context, result);
    result = buildWithError(context, result);
    result = buildWithLabel(context, result);
    result = buildWithActions(context, result);

    return result;
  }


  Widget _buildAddButton(ThemeData theme) => SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: enabled && !readOnly ? onAddPressed : null,
          icon: addButtonIcon ?? const Icon(Icons.add),
          label: Text(addButtonText ?? 'Add Item'),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            side: BorderSide(
              color: enabled ? theme.colorScheme.outline.withValues(alpha: 0.5) : theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );

  @override
  String? validate(List<T>? value) {
    // Call base validation first
    final baseError = super.validate(value);
    if (baseError != null) return baseError;

    // Additional list-specific validation could go here
    // For example: minimum/maximum items validation

    return null;
  }
}
