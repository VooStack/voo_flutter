import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_rail_default_header.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_rail_navigation_items.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Adaptive navigation rail for tablet and desktop layouts with Material 3 design
/// Features smooth animations, hover effects, and beautiful visual transitions
class VooAdaptiveNavigationRail extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Whether to show extended rail with labels
  final bool extended;

  /// Custom width for the rail
  final double? width;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom elevation
  final double? elevation;

  const VooAdaptiveNavigationRail({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.extended = false,
    this.width,
    this.backgroundColor,
    this.elevation,
  });

  @override
  State<VooAdaptiveNavigationRail> createState() => _VooAdaptiveNavigationRailState();
}

class _VooAdaptiveNavigationRailState extends State<VooAdaptiveNavigationRail> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  final Map<String, AnimationController> _itemAnimationControllers = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: widget.config.animationDuration, vsync: this);

    _hoverController = AnimationController(duration: const Duration(milliseconds: 113), vsync: this);

    if (widget.extended) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(VooAdaptiveNavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.extended != oldWidget.extended) {
      if (widget.extended) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
    for (final controller in _itemAnimationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveWidth = widget.width ?? (widget.extended ? (widget.config.extendedNavigationRailWidth ?? 256) : (widget.config.navigationRailWidth ?? 88));

    // Use a subtle surface color variation for better visual distinction
    final effectiveBackgroundColor =
        widget.backgroundColor ??
        widget.config.navigationBackgroundColor ??
        (theme.brightness == Brightness.light ? theme.colorScheme.surface.withValues(alpha: 0.95) : theme.colorScheme.surfaceContainerLow);

    return AnimatedContainer(
      duration: widget.config.animationDuration,
      curve: widget.config.animationCurve,
      width: effectiveWidth,
      margin: EdgeInsets.all(widget.config.navigationRailMargin),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.vooRadius.lg),
          boxShadow: [
            BoxShadow(color: theme.shadowColor.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(2, 0)),
            BoxShadow(color: theme.shadowColor.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(4, 0)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.vooRadius.lg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(context.vooRadius.lg), bottomRight: Radius.circular(context.vooRadius.lg)),
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1), width: context.vooSize.borderThin),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    // Custom header or default header
                    if (widget.extended) widget.config.drawerHeader ?? VooRailDefaultHeader(config: widget.config),

                    // Navigation items
                    Expanded(
                      child: ListView(
                        controller: widget.config.drawerScrollController,
                        padding: EdgeInsets.symmetric(
                          vertical: context.vooSpacing.sm,
                          horizontal: widget.extended ? context.vooSpacing.sm + context.vooSpacing.xs : context.vooSpacing.sm,
                        ),
                        physics: const ClampingScrollPhysics(),
                        children: [
                          VooRailNavigationItems(
                            config: widget.config,
                            selectedId: widget.selectedId,
                            extended: widget.extended,
                            onItemSelected: widget.onNavigationItemSelected,
                            itemAnimationControllers: _itemAnimationControllers,
                          ),
                        ],
                      ),
                    ),

                    // Leading widget for FAB or other actions
                    if (widget.config.floatingActionButton != null && widget.config.showFloatingActionButton)
                      Padding(padding: EdgeInsets.all(context.vooSpacing.md), child: widget.config.floatingActionButton),

                    // Custom footer if provided
                    if (widget.config.drawerFooter != null) widget.config.drawerFooter!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
