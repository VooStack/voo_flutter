import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_layout.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';

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
    super.labelWidget,
    super.hint,
    super.helper,
    super.placeholder,
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
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final effectiveReadOnly = getEffectiveReadOnly(context);

    // Get the error for this field using the base class method
    final fieldError = getFieldError(context);

    // If read-only, show simplified list view
    if (effectiveReadOnly) {
      return buildFieldContainer(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null || labelWidget != null) ...[
              labelWidget ??
                  Text(
                    label!,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                  ),
              const SizedBox(height: 8),
            ],
            if (items.isEmpty)
              VooReadOnlyField(value: placeholder ?? 'No items', showBorder: false)
            else
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: index < items.length - 1 ? 8 : 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showItemNumbers) ...[
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, shape: BoxShape.circle),
                          child: Text(
                            '${index + 1}',
                            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      Expanded(child: AbsorbPointer(child: itemBuilder(context, item, index))),
                    ],
                  ),
                );
              }).toList(),
            if (helper != null) ...[
              const SizedBox(height: 8),
              Text(helper!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ],
        ),
      );
    }

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
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
          ),
        ),
      );
    } else if (canReorderItems && !effectiveReadOnly && onReorder != null) {
      // Reorderable list
      listContent = ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        onReorder: onReorder!,
        proxyDecorator: (child, index, animation) => AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Material(elevation: 8, color: Colors.transparent, borderRadius: BorderRadius.circular(12), child: child),
          child: child,
        ),
        itemBuilder: (context, index) => Container(
          key: ValueKey(index), // Simple index key for ReorderableListView
          margin: EdgeInsets.only(bottom: index < items.length - 1 ? itemSpacing : 0),
          child: Row(
            children: [
              // Item number if enabled
              if (showItemNumbers) ...[
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    '${index + 1}',
                    style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              // Main item content
              Expanded(child: itemBuilder(context, items[index], index)),
              // Drag handle for reordering
              const SizedBox(width: 8),
              Icon(Icons.drag_indicator, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            ],
          ),
        ),
      );
    } else {
      // Static list - let users control their own keys through itemBuilder
      listContent = Column(
        children: [
          for (int i = 0; i < items.length; i++)
            Container(
              margin: EdgeInsets.only(bottom: i < items.length - 1 ? itemSpacing : 0),
              child: showItemNumbers
                  ? Row(
                      children: [
                        // Item number
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            '${i + 1}',
                            style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Main item content
                        Expanded(child: itemBuilder(context, items[i], i)),
                      ],
                    )
                  : itemBuilder(context, items[i], i),
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
        if (showAddButton && !effectiveReadOnly && onAddPressed != null) ...[SizedBox(height: itemSpacing), _buildAddButton(context, theme)],
      ],
    );

    // Apply standard field building pattern
    result = buildWithHelper(context, result);

    // Build with error if present
    if (fieldError != null && fieldError.isNotEmpty) {
      result = buildWithError(context, result);
    }

    result = buildWithLabel(context, result);
    result = buildWithActions(context, result);

    // Apply field container with width constraints
    result = buildFieldContainer(context, result);

    return result;
  }

  Widget _buildAddButton(BuildContext context, ThemeData theme) => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: enabled && !getEffectiveReadOnly(context) ? onAddPressed : null,
      icon: addButtonIcon ?? const Icon(Icons.add),
      label: Text(addButtonText ?? 'Add Item'),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(color: enabled ? theme.colorScheme.outline.withValues(alpha: 0.5) : theme.colorScheme.outline.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  @override
  VooListField<T> copyWith({List<T>? initialValue, String? label, VooFieldLayout? layout, String? name, bool? readOnly}) => VooListField<T>(
    key: key,
    name: name ?? this.name,
    label: label ?? this.label,
    labelWidget: labelWidget,
    hint: hint,
    helper: helper,
    placeholder: placeholder,
    enabled: enabled,
    readOnly: readOnly ?? this.readOnly,
    validators: validators,
    actions: actions,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    gridColumns: gridColumns,
    error: error,
    showError: showError,
    layout: layout ?? this.layout,
    items: initialValue ?? items,
    itemBuilder: itemBuilder,
    onAddPressed: onAddPressed,
    onReorder: onReorder,
    showAddButton: showAddButton,
    showRemoveButtons: showRemoveButtons,
    canReorderItems: canReorderItems,
    addButtonText: addButtonText,
    addButtonIcon: addButtonIcon,
    removeButtonTooltip: removeButtonTooltip,
    removeButtonIcon: removeButtonIcon,
    showItemNumbers: showItemNumbers,
    showItemBorders: showItemBorders,
    emptyStateWidget: emptyStateWidget,
    itemDecoration: itemDecoration,
    itemSpacing: itemSpacing,
  );
}
