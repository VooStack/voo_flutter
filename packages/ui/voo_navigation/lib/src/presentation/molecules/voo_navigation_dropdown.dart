import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_navigation_badge.dart';

/// Dropdown navigation component for expandable menu items
class VooNavigationDropdown extends StatefulWidget {
  /// Parent navigation item with children
  final VooNavigationItem item;

  /// Currently selected item ID
  final String? selectedId;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Callback when a child item is selected
  final void Function(String itemId) onItemSelected;

  /// Whether the dropdown is initially expanded
  final bool initiallyExpanded;

  /// Custom expansion tile padding
  final EdgeInsetsGeometry? tilePadding;

  /// Custom children padding
  final EdgeInsetsGeometry? childrenPadding;

  /// Whether to show dividers between items
  final bool showDividers;

  const VooNavigationDropdown({
    super.key,
    required this.item,
    required this.config,
    required this.onItemSelected,
    this.selectedId,
    this.initiallyExpanded = false,
    this.tilePadding,
    this.childrenPadding,
    this.showDividers = false,
  });

  @override
  State<VooNavigationDropdown> createState() => _VooNavigationDropdownState();
}

class _VooNavigationDropdownState extends State<VooNavigationDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _expandAnimation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded || widget.item.isExpanded;

    _rotationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: widget.config.animationCurve,
      ),
    );

    _expandAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: widget.config.animationCurve,
      reverseCurve: widget.config.animationCurve.flipped,
    );

    if (_isExpanded) {
      _rotationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!widget.item.hasChildren) {
      return const SizedBox.shrink();
    }

    final hasSelectedChild =
        widget.item.children?.any((child) => child.id == widget.selectedId) ??
        false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(theme, hasSelectedChild),
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Column(children: _buildChildren(theme)),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, bool hasSelectedChild) {
    final colorScheme = theme.colorScheme;
    final isHighlighted =
        hasSelectedChild || widget.item.id == widget.selectedId;

    return InkWell(
      onTap: widget.item.isEnabled ? _handleTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding:
            widget.tilePadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isExpanded
                    ? widget.item.effectiveSelectedIcon
                    : widget.item.icon,
                key: ValueKey('${widget.item.id}_icon_$_isExpanded'),
                color: isHighlighted
                    ? (widget.item.selectedIconColor ??
                          widget.config.selectedItemColor ??
                          colorScheme.primary)
                    : (widget.item.iconColor ??
                          widget.config.unselectedItemColor ??
                          colorScheme.onSurfaceVariant),
              ),
            ),

            const SizedBox(width: 12),

            // Label
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: isHighlighted
                    ? (widget.item.selectedLabelStyle ??
                          theme.textTheme.bodyLarge!.copyWith(
                            color:
                                widget.config.selectedItemColor ??
                                colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ))
                    : (widget.item.labelStyle ??
                          theme.textTheme.bodyLarge!.copyWith(
                            color:
                                widget.config.unselectedItemColor ??
                                colorScheme.onSurfaceVariant,
                          )),
                child: Text(widget.item.label, overflow: TextOverflow.ellipsis),
              ),
            ),

            // Badge if present
            if (widget.item.hasBadge) ...[
              const SizedBox(width: 8),
              VooNavigationBadge(
                item: widget.item,
                config: widget.config,
                size: 16,
                animate: widget.config.enableAnimations,
              ),
            ],

            // Expand icon
            const SizedBox(width: 8),
            RotationTransition(
              turns: _rotationAnimation,
              child: Icon(
                Icons.expand_more,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChildren(ThemeData theme) {
    final children = <Widget>[];
    final items = widget.item.children ?? [];

    for (int i = 0; i < items.length; i++) {
      final child = items[i];
      final isSelected = child.id == widget.selectedId;

      if (widget.showDividers && i > 0) {
        children.add(const Divider(height: 1, thickness: 0.5, indent: 48));
      }

      children.add(_buildChildItem(child, isSelected, theme));
    }

    return children;
  }

  Widget _buildChildItem(
    VooNavigationItem item,
    bool isSelected,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: item.isEnabled ? () => widget.onItemSelected(item.id) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding:
            widget.childrenPadding ??
            const EdgeInsets.only(left: 48, right: 16, top: 8, bottom: 8),
        decoration: isSelected && widget.config.indicatorShape == null
            ? BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color:
                        widget.config.selectedItemColor ?? colorScheme.primary,
                    width: 3,
                  ),
                ),
              )
            : null,
        child: Row(
          children: [
            // Icon
            Icon(
              isSelected ? item.effectiveSelectedIcon : item.icon,
              size: 20,
              color: isSelected
                  ? (item.selectedIconColor ??
                        widget.config.selectedItemColor ??
                        colorScheme.primary)
                  : (item.iconColor ??
                        widget.config.unselectedItemColor ??
                        colorScheme.onSurfaceVariant),
            ),

            const SizedBox(width: 12),

            // Label
            Expanded(
              child: Text(
                item.label,
                style: isSelected
                    ? (item.selectedLabelStyle ??
                          theme.textTheme.bodyMedium!.copyWith(
                            color:
                                widget.config.selectedItemColor ??
                                colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ))
                    : (item.labelStyle ??
                          theme.textTheme.bodyMedium!.copyWith(
                            color:
                                widget.config.unselectedItemColor ??
                                colorScheme.onSurfaceVariant,
                          )),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Badge if present
            if (item.hasBadge) ...[
              const SizedBox(width: 8),
              VooNavigationBadge(
                item: item,
                config: widget.config,
                size: 14,
                animate: widget.config.enableAnimations,
              ),
            ],

            // Trailing widget if present
            if (item.trailingWidget != null) ...[
              const SizedBox(width: 8),
              item.trailingWidget!,
            ],
          ],
        ),
      ),
    );
  }
}
