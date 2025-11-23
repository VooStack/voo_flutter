import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/node_template.dart';

/// A palette widget that displays available node templates.
///
/// Users can drag templates from this palette onto the canvas
/// to create new nodes. The palette supports categories and
/// customizable item appearance.
///
/// Example:
/// ```dart
/// NodePalette(
///   templates: [
///     NodeTemplate(type: 'start', label: 'Start', icon: Icons.play_arrow),
///     NodeTemplate(type: 'process', label: 'Process', icon: Icons.settings),
///     NodeTemplate(type: 'end', label: 'End', icon: Icons.stop),
///   ],
///   onTemplateDragStarted: (template) {
///     print('Started dragging: ${template.type}');
///   },
/// )
/// ```
class NodePalette extends StatelessWidget {
  /// Creates a node palette.
  const NodePalette({
    required this.templates,
    this.onTemplateTap,
    this.onTemplateDragStarted,
    this.onTemplateDragEnded,
    this.itemBuilder,
    this.direction = Axis.vertical,
    this.padding = const EdgeInsets.all(8),
    this.itemSpacing = 8.0,
    this.showCategories = true,
    this.collapsedCategories = const {},
    this.onCategoryToggle,
    super.key,
  });

  /// The list of node templates to display.
  final List<NodeTemplate> templates;

  /// Called when a template item is tapped.
  final void Function(NodeTemplate)? onTemplateTap;

  /// Called when a template drag starts.
  final void Function(NodeTemplate)? onTemplateDragStarted;

  /// Called when a template drag ends.
  final void Function(NodeTemplate)? onTemplateDragEnded;

  /// Optional custom builder for template items.
  ///
  /// If not provided, uses [_DefaultPaletteItem].
  final Widget Function(BuildContext, NodeTemplate)? itemBuilder;

  /// The direction to lay out palette items.
  final Axis direction;

  /// Padding around the palette content.
  final EdgeInsets padding;

  /// Spacing between palette items.
  final double itemSpacing;

  /// Whether to group templates by category.
  final bool showCategories;

  /// Set of category names that are currently collapsed.
  final Set<String> collapsedCategories;

  /// Called when a category's collapse state is toggled.
  final void Function(String category)? onCategoryToggle;

  @override
  Widget build(BuildContext context) {
    if (showCategories) {
      return _buildCategorizedPalette(context);
    }
    return _buildFlatPalette(context);
  }

  Widget _buildFlatPalette(BuildContext context) {
    final items = templates.map((t) => _buildDraggableItem(context, t)).toList();

    if (direction == Axis.horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _addSpacing(items),
        ),
      );
    }

    return SingleChildScrollView(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _addSpacing(items),
      ),
    );
  }

  Widget _buildCategorizedPalette(BuildContext context) {
    // Group templates by category
    final categorized = <String, List<NodeTemplate>>{};
    for (final template in templates) {
      final category = template.category ?? 'General';
      categorized.putIfAbsent(category, () => []).add(template);
    }

    final categories = categorized.keys.toList()..sort();

    return SingleChildScrollView(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: categories.map((category) {
          final categoryTemplates = categorized[category]!;
          final isCollapsed = collapsedCategories.contains(category);

          return _CategorySection(
            category: category,
            isCollapsed: isCollapsed,
            onToggle: onCategoryToggle != null
                ? () => onCategoryToggle!(category)
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _addSpacing(
                categoryTemplates
                    .map((t) => _buildDraggableItem(context, t))
                    .toList(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDraggableItem(BuildContext context, NodeTemplate template) {
    final child = itemBuilder?.call(context, template) ??
        _DefaultPaletteItem(template: template);

    return Draggable<NodeTemplate>(
      data: template,
      onDragStarted: () => onTemplateDragStarted?.call(template),
      onDragEnd: (_) => onTemplateDragEnded?.call(template),
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Opacity(
          opacity: 0.8,
          child: SizedBox(
            width: 120,
            child: child,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: child,
      ),
      child: GestureDetector(
        onTap: () => onTemplateTap?.call(template),
        child: child,
      ),
    );
  }

  List<Widget> _addSpacing(List<Widget> items) {
    if (items.isEmpty) return items;

    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(SizedBox(
          width: direction == Axis.horizontal ? itemSpacing : null,
          height: direction == Axis.vertical ? itemSpacing : null,
        ));
      }
    }
    return result;
  }
}

/// A collapsible category section for the palette.
class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.isCollapsed,
    required this.child,
    this.onToggle,
  });

  final String category;
  final bool isCollapsed;
  final Widget child;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Icon(
                  isCollapsed
                      ? Icons.keyboard_arrow_right
                      : Icons.keyboard_arrow_down,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    category,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isCollapsed)
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: child,
          ),
      ],
    );
  }
}

/// The default visual representation of a palette item.
class _DefaultPaletteItem extends StatelessWidget {
  const _DefaultPaletteItem({required this.template});

  final NodeTemplate template;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = template.color ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (template.icon != null) ...[
            Icon(
              template.icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (template.description != null)
                  Text(
                    template.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A compact version of the palette item for horizontal layouts.
class CompactPaletteItem extends StatelessWidget {
  /// Creates a compact palette item.
  const CompactPaletteItem({
    required this.template,
    super.key,
  });

  /// The template this item represents.
  final NodeTemplate template;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = template.color ?? theme.colorScheme.primary;

    return Tooltip(
      message: template.description ?? template.label,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: template.icon != null
              ? Icon(template.icon, color: color, size: 24)
              : Text(
                  template.label.substring(0, 1).toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
