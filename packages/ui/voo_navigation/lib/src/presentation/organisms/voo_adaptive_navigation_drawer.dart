import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_navigation_badge.dart';

/// Adaptive navigation drawer for desktop layouts
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
  State<VooAdaptiveNavigationDrawer> createState() => 
      _VooAdaptiveNavigationDrawerState();
}

class _VooAdaptiveNavigationDrawerState extends State<VooAdaptiveNavigationDrawer>
    with TickerProviderStateMixin {
  final Map<String, AnimationController> _expansionControllers = {};
  final Map<String, Animation<double>> _expansionAnimations = {};
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
          curve: Curves.easeInOut,
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
    final colorScheme = theme.colorScheme;
    
    final effectiveWidth = widget.width ?? 
        widget.config.navigationDrawerWidth ?? 
        280;
    
    final effectiveBackgroundColor = widget.backgroundColor ??
        widget.config.navigationBackgroundColor ??
        colorScheme.surface;
    
    final effectiveElevation = widget.elevation ??
        widget.config.elevation ??
        1;
    
    return AnimatedContainer(
      duration: widget.config.animationDuration,
      curve: widget.config.animationCurve,
      width: effectiveWidth,
      child: Material(
        color: effectiveBackgroundColor,
        elevation: widget.permanent ? 0 : effectiveElevation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom header
            if (widget.config.drawerHeader != null)
              widget.config.drawerHeader!,
            
            // Navigation items
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: _buildNavigationItems(context),
              ),
            ),
            
            // Footer
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
      
      // Check if this is a divider
      if (item.label.isEmpty && item.icon == Icons.remove) {
        widgets.add(const Divider(height: 1));
        continue;
      }
      
      // Check if this is a section header
      if (item.hasChildren && widget.config.groupItemsBySections) {
        widgets.add(_buildSectionHeader(item, theme));
        
        // Add expanded children
        final controller = _expansionControllers[item.id];
        if (controller != null) {
          widgets.add(
            SizeTransition(
              sizeFactor: _expansionAnimations[item.id]!,
              child: Column(
                children: item.children!
                    .map((child) => _buildNavigationItem(child, theme, indent: true))
                    .toList(),
              ),
            ),
          );
        }
      } else {
        widgets.add(_buildNavigationItem(item, theme));
      }
      
      // Add spacing
      if (i < visibleItems.length - 1 && !item.hasChildren) {
        widgets.add(const SizedBox(height: 2));
      }
    }
    
    return widgets;
  }
  
  Widget _buildSectionHeader(VooNavigationItem item, ThemeData theme) {
    final controller = _expansionControllers[item.id];
    final isExpanded = controller?.value == 1.0;
    
    return InkWell(
      onTap: () => _handleItemTap(item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              isExpanded ? item.selectedIcon ?? item.icon : item.icon,
              color: item.iconColor ?? theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label.toUpperCase(),
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: controller ?? const AlwaysStoppedAnimation(0),
              builder: (context, child) => Transform.rotate(
                  angle: (controller?.value ?? 0) * 3.14159 / 2,
                  child: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNavigationItem(
    VooNavigationItem item,
    ThemeData theme, {
    bool indent = false,
  }) {
    final isSelected = item.id == widget.selectedId;
    final colorScheme = theme.colorScheme;
    
    final selectedColor = widget.config.selectedItemColor ?? colorScheme.primary;
    final unselectedColor = widget.config.unselectedItemColor ?? 
        colorScheme.onSurfaceVariant;
    
    return Padding(
      padding: EdgeInsets.only(
        left: indent ? 48 : 16,
        right: 16,
        top: 2,
        bottom: 2,
      ),
      child: InkWell(
        onTap: item.isEnabled ? () => _handleItemTap(item) : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (widget.config.indicatorColor ?? selectedColor.withAlpha((0.12 * 255).round()))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected && widget.config.indicatorShape == null
                ? Border.all(
                    color: selectedColor.withAlpha((0.3 * 255).round()),
                  )
                : null,
          ),
          child: Row(
            children: [
              // Icon with animations
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: item.leadingWidget ?? Icon(
                  isSelected ? item.effectiveSelectedIcon : item.icon,
                  key: ValueKey('${item.id}_icon_$isSelected'),
                  color: isSelected
                      ? (item.selectedIconColor ?? selectedColor)
                      : (item.iconColor ?? unselectedColor),
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Label
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: isSelected
                      ? (item.selectedLabelStyle ??
                         theme.textTheme.bodyLarge!.copyWith(
                           color: selectedColor,
                           fontWeight: FontWeight.w600,
                         ))
                      : (item.labelStyle ??
                         theme.textTheme.bodyLarge!.copyWith(
                           color: unselectedColor,
                         )),
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              
              // Badge or trailing widget
              if (item.hasBadge || item.trailingWidget != null) ...[
                const SizedBox(width: 8),
                item.trailingWidget ?? VooNavigationBadge(
                  item: item,
                  config: widget.config,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}