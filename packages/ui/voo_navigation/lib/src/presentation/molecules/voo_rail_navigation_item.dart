import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_rail_modern_badge.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Navigation item widget for rail layout
class VooRailNavigationItem extends StatefulWidget {
  /// Navigation item data
  final VooNavigationItem item;

  /// Whether this item is selected
  final bool isSelected;

  /// Whether the rail is extended
  final bool extended;

  /// Callback when item is tapped
  final VoidCallback? onTap;

  /// Optional animation controller
  final AnimationController? animationController;

  const VooRailNavigationItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.extended,
    this.onTap,
    this.animationController,
  });

  @override
  State<VooRailNavigationItem> createState() => _VooRailNavigationItemState();
}

class _VooRailNavigationItemState extends State<VooRailNavigationItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = widget.animationController ??
        AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );

    if (widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(VooRailNavigationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    if (widget.animationController == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.extended ? 0 : spacing.xs,
        vertical: spacing.xxs,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.item.isEnabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: InkWell(
          onTap: widget.item.isEnabled ? widget.onTap : null,
          borderRadius: BorderRadius.circular(
            widget.extended ? radius.lg : radius.full,
          ),
          child: AnimatedScale(
            scale: _isHovered ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.extended ? 48 : 56,
              padding: EdgeInsets.symmetric(
                horizontal: widget.extended ? spacing.md : spacing.xs,
                vertical: widget.extended ? spacing.sm : spacing.xs,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  widget.extended ? radius.md + spacing.xxs : radius.full,
                ),
                gradient: widget.isSelected
                    ? LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(
                              alpha: isDark ? 0.2 : 0.12),
                          theme.colorScheme.primary.withValues(
                              alpha: isDark ? 0.15 : 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: !widget.isSelected
                    ? (_isHovered
                        ? theme.colorScheme.onSurface.withValues(
                            alpha: isDark ? 0.08 : 0.04)
                        : Colors.transparent)
                    : null,
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: widget.extended
                  ? _buildExtendedContent(theme, spacing)
                  : _buildCompactContent(theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtendedContent(ThemeData theme, dynamic spacing) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            widget.isSelected
                ? widget.item.effectiveSelectedIcon
                : widget.item.icon,
            key: ValueKey(widget.isSelected),
            color: widget.isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        SizedBox(width: spacing.sm + spacing.xs),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  widget.item.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: widget.isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    fontWeight:
                        widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.item.hasBadge) ...[
                SizedBox(width: spacing.sm),
                VooRailModernBadge(
                  item: widget.item,
                  isSelected: widget.isSelected,
                  extended: widget.extended,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactContent(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.isSelected
                      ? widget.item.effectiveSelectedIcon
                      : widget.item.icon,
                  key: ValueKey(widget.isSelected),
                  color: widget.isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              if (widget.item.hasBadge)
                Positioned(
                  top: -4,
                  right: -8,
                  child: VooRailModernBadge(
                    item: widget.item,
                    isSelected: widget.isSelected,
                    extended: widget.extended,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}