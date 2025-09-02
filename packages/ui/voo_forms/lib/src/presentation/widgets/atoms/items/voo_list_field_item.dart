import 'package:flutter/material.dart';

/// Optional item wrapper for VooListField that provides consistent item styling
/// Developers can use this or create their own widget
/// Following atomic design and KISS principle
class VooListFieldItem extends StatelessWidget {
  /// The unique key for this item
  /// Developers should provide a stable key to avoid focus issues
  @override
  final Key? key;
  
  /// The child widget to display
  final Widget child;
  
  /// Optional item number to display
  final int? itemNumber;
  
  /// Whether to show item number
  final bool showItemNumber;
  
  /// Whether to show border around item
  final bool showBorder;
  
  /// Whether the item can be reordered
  final bool canReorder;
  
  /// Optional remove button callback
  final VoidCallback? onRemove;
  
  /// Whether the item is enabled
  final bool enabled;
  
  /// Whether the item is read-only
  final bool readOnly;
  
  /// Custom decoration for the item
  final BoxDecoration? decoration;
  
  /// Remove button icon
  final Widget? removeIcon;
  
  /// Remove button tooltip
  final String? removeTooltip;
  
  /// Spacing around the item content
  final EdgeInsetsGeometry? padding;
  
  const VooListFieldItem({
    this.key,
    required this.child,
    this.itemNumber,
    this.showItemNumber = false,
    this.showBorder = true,
    this.canReorder = false,
    this.onRemove,
    this.enabled = true,
    this.readOnly = false,
    this.decoration,
    this.removeIcon,
    this.removeTooltip,
    this.padding,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget content = Row(
      children: [
        // Drag handle for reorderable lists
        if (canReorder && !readOnly) ...[
          Icon(
            Icons.drag_indicator,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 8),
        ],
        
        // Item number if enabled
        if (showItemNumber && itemNumber != null) ...[
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$itemNumber',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        
        // Main content
        Expanded(child: child),
        
        // Remove button
        if (onRemove != null && !readOnly) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: enabled ? onRemove : null,
            icon: removeIcon ?? const Icon(Icons.remove_circle_outline),
            color: theme.colorScheme.error,
            tooltip: removeTooltip ?? 'Remove',
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ],
    );
    
    if (showBorder) {
      content = Container(
        padding: padding ?? const EdgeInsets.all(12),
        decoration: decoration ??
            BoxDecoration(
              color: enabled 
                  ? theme.colorScheme.surface 
                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
        child: content,
      );
    } else if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }
    
    return content;
  }
}