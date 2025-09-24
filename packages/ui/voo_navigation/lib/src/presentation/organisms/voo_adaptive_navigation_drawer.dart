import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/drawer_default_header.dart';
import 'package:voo_navigation/src/presentation/molecules/drawer_navigation_items.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Modern adaptive navigation drawer for desktop layouts
class VooAdaptiveNavigationDrawer extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Custom width for the drawer
  final double? width;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom elevation
  final double? elevation;

  /// Whether drawer is permanent (always visible)
  final bool permanent;

  const VooAdaptiveNavigationDrawer({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.width,
    this.backgroundColor,
    this.elevation,
    this.permanent = true,
  });

  @override
  State<VooAdaptiveNavigationDrawer> createState() => _VooAdaptiveNavigationDrawerState();
}

class _VooAdaptiveNavigationDrawerState extends State<VooAdaptiveNavigationDrawer> with TickerProviderStateMixin {
  final Map<String, AnimationController> _expansionControllers = {};
  final Map<String, Animation<double>> _expansionAnimations = {};
  final Map<String, bool> _hoveredItems = {};
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.config.drawerScrollController ?? ScrollController();
    _initializeExpansionAnimations();
  }

  void _initializeExpansionAnimations() {
    for (final item in widget.config.items) {
      if (item.hasChildren) {
        _expansionControllers[item.id] = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
        _expansionAnimations[item.id] = CurvedAnimation(parent: _expansionControllers[item.id]!, curve: Curves.easeInOutCubic);

        if (item.isExpanded) {
          _expansionControllers[item.id]!.value = 1.0;
        }
      }
    }
  }

  @override
  void dispose() {
    if (widget.config.drawerScrollController == null) {
      _scrollController.dispose();
    }
    for (final controller in _expansionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleItemTap(VooNavigationItem item) {
    if (widget.config.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // Handle expansion for items with children
    if (item.hasChildren) {
      final controller = _expansionControllers[item.id];
      if (controller != null) {
        if (controller.value == 0) {
          controller.forward();
        } else {
          controller.reverse();
        }
      }
      return;
    }

    // Handle navigation
    if (item.isEnabled) {
      widget.onNavigationItemSelected(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveWidth = widget.width ?? widget.config.navigationDrawerWidth ?? 300;

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
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.vooRadius.lg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(context.vooRadius.lg),
                  bottomRight: Radius.circular(context.vooRadius.lg),
                ),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom header or default modern header
                widget.config.drawerHeader ?? VooDrawerDefaultHeader(config: widget.config),

                // Navigation items
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: context.vooSpacing.sm + context.vooSpacing.xs, vertical: context.vooSpacing.sm),
                    children: [
                      VooDrawerNavigationItems(
                        config: widget.config,
                        selectedId: widget.selectedId,
                        onItemTap: _handleItemTap,
                        hoveredItems: _hoveredItems,
                        expansionControllers: _expansionControllers,
                        expansionAnimations: _expansionAnimations,
                        onHoverChanged: (itemId, isHovered) {
                          setState(() => _hoveredItems[itemId] = isHovered);
                        },
                      ),
                    ],
                  ),
                ),

                // Footer
                if (widget.config.drawerFooter != null) Padding(padding: EdgeInsets.all(context.vooSpacing.sm + context.vooSpacing.xs), child: widget.config.drawerFooter!),
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
