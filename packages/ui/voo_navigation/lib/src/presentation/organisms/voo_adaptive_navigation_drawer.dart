import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
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
        _expansionControllers[item.id] = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );
        _expansionAnimations[item.id] = CurvedAnimation(
          parent: _expansionControllers[item.id]!,
          curve: Curves.easeInOutCubic,
        );

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

    // Sophisticated sidebar design
    final isDark = theme.brightness == Brightness.dark;
    final sidebarColor = isDark
        ? const Color(0xFF1A1D23) // Dark mode: very dark blue-gray
        : const Color(0xFF1F2937); // Light mode: professional dark gray

    return SizedBox(
      width: effectiveWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: sidebarColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(1, 0),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom header or default modern header
              widget.config.drawerHeader ?? _buildDefaultHeader(context),

              // Navigation items
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.vooSpacing.sm + context.vooSpacing.xs,
                    vertical: context.vooSpacing.sm,
                  ),
                  children: _buildNavigationItems(context),
                ),
              ),

              // Footer
              if (widget.config.drawerFooter != null)
                Padding(
                  padding: EdgeInsets.all(context.vooSpacing.sm + context.vooSpacing.xs),
                  child: widget.config.drawerFooter!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultHeader(BuildContext context) {
    final theme = Theme.of(context);

    final spacing = context.vooSpacing;
    return Container(
      padding: EdgeInsets.fromLTRB(
        spacing.lg - spacing.xs,
        spacing.xxl,
        spacing.lg - spacing.xs,
        spacing.lg - spacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(context.vooRadius.md),
                ),
                child: const Icon(
                  Icons.dashboard,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              SizedBox(width: context.vooSpacing.sm + context.vooSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (widget.config.appBarTitle != null && widget.config.appBarTitle is Text)
                          ? ((widget.config.appBarTitle! as Text).data ?? 'Navigation')
                          : 'Navigation',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.config.drawerHeader == null)
                      Text(
                        'Welcome back',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNavigationItems(BuildContext context) {
    final visibleItems = widget.config.visibleItems;
    final widgets = <Widget>[];

    for (int i = 0; i < visibleItems.length; i++) {
      final item = visibleItems[i];

      // Check if this is a divider
      if (item.isDivider) {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.vooSpacing.sm),
            child: Divider(
              color: Colors.white.withValues(alpha: 0.2),
              height: 1,
            ),
          ),
        );
        continue;
      }

      // Check if this is a section with children
      if (item.hasChildren) {
        widgets.add(_buildExpandableSection(item, context));
      } else {
        widgets.add(_buildNavigationItem(item, context));
      }
    }

    return widgets;
  }

  Widget _buildExpandableSection(VooNavigationItem item, BuildContext context) {
    final theme = Theme.of(context);
    final controller = _expansionControllers[item.id];
    final isExpanded = controller?.value == 1.0;

    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hoveredItems[item.id] = true),
          onExit: (_) => setState(() => _hoveredItems[item.id] = false),
          child: InkWell(
            onTap: () => _handleItemTap(item),
            borderRadius: BorderRadius.circular(context.vooRadius.lg),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(bottom: context.vooSpacing.xs),
              padding: EdgeInsets.symmetric(
                horizontal: context.vooSpacing.md,
                vertical: context.vooSpacing.sm + context.vooSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: _hoveredItems[item.id] == true ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
                borderRadius: BorderRadius.circular(context.vooRadius.lg),
              ),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? item.selectedIcon ?? item.icon : item.icon,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: context.vooSpacing.sm + context.vooSpacing.xs),
                  Expanded(
                    child: Text(
                      item.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isExpanded ? 0.25 : 0,
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Animated expansion for children
        if (controller != null)
          SizeTransition(
            sizeFactor: _expansionAnimations[item.id]!,
            child: Column(
              children: item.children!.map((child) => _buildChildNavigationItem(child, context)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildNavigationItem(
    VooNavigationItem item,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isSelected = item.id == widget.selectedId;
    final isHovered = _hoveredItems[item.id] == true;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredItems[item.id] = true),
      onExit: (_) => setState(() => _hoveredItems[item.id] = false),
      child: Padding(
        padding: EdgeInsets.only(bottom: context.vooSpacing.xs),
        child: InkWell(
          onTap: item.isEnabled ? () => _handleItemTap(item) : null,
          borderRadius: BorderRadius.circular(context.vooRadius.lg),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: context.vooSpacing.md,
              vertical: context.vooSpacing.sm + context.vooSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : isHovered
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.transparent,
              border: isSelected
                  ? Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1,
                    )
                  : null,
              borderRadius: BorderRadius.circular(context.vooRadius.lg),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Icon
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? item.effectiveSelectedIcon : item.icon,
                    key: ValueKey(isSelected),
                    color: isSelected ? theme.colorScheme.primary : Colors.white.withValues(alpha: 0.8),
                    size: 20,
                  ),
                ),

                SizedBox(width: context.vooSpacing.sm + context.vooSpacing.xs),

                // Label
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected ? theme.colorScheme.primary : Colors.white.withValues(alpha: 0.85),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Modern badge
                if (item.hasBadge) ...[
                  SizedBox(width: context.vooSpacing.sm),
                  _buildModernBadge(item, isSelected),
                ],

                // Trailing widget
                if (item.trailingWidget != null) ...[
                  SizedBox(width: context.vooSpacing.sm),
                  item.trailingWidget!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildNavigationItem(
    VooNavigationItem item,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isSelected = item.id == widget.selectedId;
    final isHovered = _hoveredItems[item.id] == true;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredItems[item.id] = true),
      onExit: (_) => setState(() => _hoveredItems[item.id] = false),
      child: Padding(
        padding: EdgeInsets.only(
          left: context.vooSpacing.xl,
          bottom: context.vooSpacing.xxs,
        ),
        child: InkWell(
          onTap: item.isEnabled ? () => _handleItemTap(item) : null,
          borderRadius: BorderRadius.circular(context.vooRadius.md),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: context.vooSpacing.sm + context.vooSpacing.xs,
              vertical: context.vooSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.12)
                  : isHovered
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(context.vooRadius.md),
            ),
            child: Row(
              children: [
                // Dot indicator for child items
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isSelected ? widget.config.selectedItemColor ?? theme.colorScheme.primary : Colors.white.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),

                SizedBox(width: context.vooSpacing.sm + context.vooSpacing.xs),

                // Label
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected ? widget.config.selectedItemColor ?? theme.colorScheme.primary : Colors.white.withValues(alpha: 0.9),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Badge
                if (item.hasBadge) ...[
                  SizedBox(width: context.vooSpacing.sm),
                  _buildModernBadge(item, isSelected),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernBadge(VooNavigationItem item, bool isSelected) {
    final theme = Theme.of(context);

    String badgeText;
    if (item.badgeCount != null) {
      badgeText = item.badgeCount! > 99 ? '99+' : item.badgeCount.toString();
    } else if (item.badgeText != null) {
      badgeText = item.badgeText!;
    } else if (item.showDot) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: item.badgeColor ?? Colors.red,
          shape: BoxShape.circle,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.vooSpacing.sm,
        vertical: context.vooSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isSelected ? (item.badgeColor ?? theme.colorScheme.primary) : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badgeText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
