import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Animated collapse/expand toggle button for navigation rail
class VooCollapseToggle extends StatefulWidget {
  /// Whether the rail is currently expanded
  final bool isExpanded;

  /// Callback when toggle is pressed
  final VoidCallback onToggle;

  /// Custom icon for expanded state
  final IconData? expandedIcon;

  /// Custom icon for collapsed state
  final IconData? collapsedIcon;

  /// Tooltip for expanded state
  final String? expandedTooltip;

  /// Tooltip for collapsed state
  final String? collapsedTooltip;

  const VooCollapseToggle({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    this.expandedIcon,
    this.collapsedIcon,
    this.expandedTooltip,
    this.collapsedTooltip,
  });

  @override
  State<VooCollapseToggle> createState() => _VooCollapseToggleState();
}

class _VooCollapseToggleState extends State<VooCollapseToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(VooCollapseToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    final tooltip = widget.isExpanded
        ? (widget.expandedTooltip ?? 'Collapse sidebar')
        : (widget.collapsedTooltip ?? 'Expand sidebar');

    return Padding(
      padding: EdgeInsets.all(spacing.sm),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Tooltip(
          message: tooltip,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onToggle,
              borderRadius: BorderRadius.circular(radius.md),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(radius.md),
                  border: Border.all(
                    color: _isHovered
                        ? theme.colorScheme.primary.withValues(alpha: 0.2)
                        : theme.colorScheme.outline.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159,
                      child: Icon(
                        widget.isExpanded
                            ? (widget.expandedIcon ??
                                Icons.keyboard_double_arrow_left_rounded)
                            : (widget.collapsedIcon ??
                                Icons.keyboard_double_arrow_right_rounded),
                        color: _isHovered
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
