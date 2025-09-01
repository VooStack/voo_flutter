import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';

/// Adaptive navigation rail for tablet and desktop layouts
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

class _VooAdaptiveNavigationRailState extends State<VooAdaptiveNavigationRail> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );
    
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
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final effectiveWidth = widget.width ?? 
        (widget.extended 
            ? (widget.config.extendedNavigationRailWidth ?? 256)
            : (widget.config.navigationRailWidth ?? 72));
    
    final effectiveBackgroundColor = widget.backgroundColor ??
        widget.config.navigationBackgroundColor ??
        theme.navigationRailTheme.backgroundColor ??
        colorScheme.surface;
    
    final effectiveElevation = widget.elevation ??
        widget.config.elevation ??
        theme.navigationRailTheme.elevation ??
        0;
    
    return AnimatedContainer(
      duration: widget.config.animationDuration,
      curve: widget.config.animationCurve,
      width: effectiveWidth,
      child: Material(
        color: effectiveBackgroundColor,
        elevation: effectiveElevation,
        child: Column(
          children: [
            // Custom header if provided
            if (widget.config.drawerHeader != null)
              widget.config.drawerHeader!,
            
            // Navigation items
            Expanded(
              child: ListView(
                controller: widget.config.drawerScrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: _buildNavigationItems(context),
              ),
            ),
            
            // Leading widget for FAB or other actions
            if (widget.config.floatingActionButton != null && 
                widget.config.showFloatingActionButton)
              Padding(
                padding: const EdgeInsets.all(16),
                child: widget.config.floatingActionButton,
              ),
            
            // Custom footer if provided
            if (widget.config.drawerFooter != null)
              widget.config.drawerFooter!,
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildNavigationItems(BuildContext context) {
    final theme = Theme.of(context);
    final visibleItems = widget.config.visibleItems;
    final widgets = <Widget>[];
    
    for (int i = 0; i < visibleItems.length; i++) {
      final item = visibleItems[i];
      
      // Handle section headers
      if (item.hasChildren && widget.config.groupItemsBySections) {
        widgets.add(_buildSectionHeader(item, theme));
        if (item.isExpanded && item.children != null) {
          for (final child in item.children!) {
            widgets.add(_buildNavigationItem(child, theme, indent: true));
          }
        }
      } else {
        widgets.add(_buildNavigationItem(item, theme));
      }
      
      // Add spacing between items
      if (i < visibleItems.length - 1) {
        widgets.add(const SizedBox(height: 4));
      }
    }
    
    return widgets;
  }
  
  Widget _buildSectionHeader(VooNavigationItem item, ThemeData theme) => ExpansionTile(
      title: AnimatedDefaultTextStyle(
        duration: widget.config.animationDuration,
        style: widget.extended
            ? (item.labelStyle ?? theme.textTheme.titleSmall!)
            : const TextStyle(fontSize: 0),
        child: Text(item.label),
      ),
      leading: Icon(
        item.isExpanded ? item.selectedIcon ?? item.icon : item.icon,
        color: item.iconColor ?? theme.colorScheme.onSurfaceVariant,
      ),
      initiallyExpanded: item.isExpanded,
      children: item.children?.map((child) => 
        _buildNavigationItem(child, theme, indent: true),).toList() ?? [],
    );
  
  Widget _buildNavigationItem(
    VooNavigationItem item, 
    ThemeData theme, {
    bool indent = false,
  }) {
    final isSelected = item.id == widget.selectedId;
    final colorScheme = theme.colorScheme;
    
    final selectedColor = widget.config.selectedItemColor ?? 
        theme.navigationRailTheme.selectedIconTheme?.color ??
        colorScheme.primary;
    
    final unselectedColor = widget.config.unselectedItemColor ??
        theme.navigationRailTheme.unselectedIconTheme?.color ??
        colorScheme.onSurfaceVariant;
    
    return Padding(
      padding: EdgeInsets.only(left: indent ? 24 : 0),
      child: InkWell(
        onTap: item.isEnabled 
            ? () => widget.onNavigationItemSelected(item.id)
            : null,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: isSelected && widget.config.indicatorShape != null
              ? ShapeDecoration(
                  color: widget.config.indicatorColor ?? 
                      selectedColor.withAlpha((0.12 * 255).round()),
                  shape: widget.config.indicatorShape!,
                )
              : null,
          child: Row(
            mainAxisAlignment: widget.extended 
                ? MainAxisAlignment.start 
                : MainAxisAlignment.center,
            children: [
              // Icon with animations
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: item.leadingWidget ?? Icon(
                  isSelected 
                      ? item.effectiveSelectedIcon 
                      : item.icon,
                  key: ValueKey('${item.id}_icon_$isSelected'),
                  color: isSelected 
                      ? (item.selectedIconColor ?? selectedColor)
                      : (item.iconColor ?? unselectedColor),
                ),
              ),
              
              // Label (only when extended)
              if (widget.extended) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: widget.config.animationDuration,
                    style: isSelected
                        ? (item.selectedLabelStyle ?? 
                           theme.textTheme.labelLarge!.copyWith(
                             color: selectedColor,
                             fontWeight: FontWeight.w500,
                           ))
                        : (item.labelStyle ?? 
                           theme.textTheme.labelLarge!.copyWith(
                             color: unselectedColor,
                           )),
                    child: Text(
                      item.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              
              // Badge or trailing widget
              if (item.hasBadge || item.trailingWidget != null) ...[
                if (widget.extended) const SizedBox(width: 8),
                item.trailingWidget ?? _buildBadge(item, theme),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBadge(VooNavigationItem item, ThemeData theme) {
    if (item.showDot) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: item.badgeColor ?? theme.colorScheme.error,
          shape: BoxShape.circle,
        ),
      );
    }
    
    final badgeText = item.badgeText ?? 
        (item.badgeCount != null ? item.badgeCount.toString() : '');
    
    if (badgeText.isEmpty) return const SizedBox.shrink();
    
    return AnimatedContainer(
      duration: widget.config.badgeAnimationDuration,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: item.badgeColor ?? theme.colorScheme.error,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      child: Center(
        child: Text(
          badgeText,
          style: theme.textTheme.labelSmall!.copyWith(
            color: theme.colorScheme.onError,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}