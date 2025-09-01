import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_navigation_badge.dart';

/// Adaptive bottom navigation bar for mobile layouts
class VooAdaptiveBottomNavigation extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;
  
  /// Currently selected item ID
  final String selectedId;
  
  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;
  
  /// Custom height for the navigation bar
  final double? height;
  
  /// Whether to show labels
  final bool showLabels;
  
  /// Whether to show selected labels only
  final bool showSelectedLabels;
  
  /// Type of bottom navigation bar
  final NavigationBarType type;
  
  /// Custom background color
  final Color? backgroundColor;
  
  /// Custom elevation
  final double? elevation;
  
  /// Whether to enable splash/ripple effect
  final bool enableFeedback;
  
  const VooAdaptiveBottomNavigation({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.height,
    this.showLabels = true,
    this.showSelectedLabels = true,
    this.type = NavigationBarType.material3,
    this.backgroundColor,
    this.elevation,
    this.enableFeedback = true,
  });

  @override
  State<VooAdaptiveBottomNavigation> createState() => _VooAdaptiveBottomNavigationState();
}

class _VooAdaptiveBottomNavigationState extends State<VooAdaptiveBottomNavigation> 
    with TickerProviderStateMixin {
  late List<AnimationController> _itemAnimations;
  late List<Animation<double>> _scaleAnimations;
  int? _previousIndex;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }
  
  void _initializeAnimations() {
    final itemCount = widget.config.visibleItems.length;
    _itemAnimations = List.generate(
      itemCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    
    _scaleAnimations = _itemAnimations.map((controller) => 
      Tween<double>(
        begin: 1.0,
        end: 1.1,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),),
    ).toList();
    
    // Animate the initially selected item
    final selectedIndex = _getSelectedIndex();
    if (selectedIndex != null && selectedIndex < _itemAnimations.length) {
      _itemAnimations[selectedIndex].forward();
      _previousIndex = selectedIndex;
    }
  }
  
  @override
  void didUpdateWidget(VooAdaptiveBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.config.visibleItems.length != oldWidget.config.visibleItems.length) {
      _disposeAnimations();
      _initializeAnimations();
    }
    
    if (widget.selectedId != oldWidget.selectedId) {
      _animateSelection();
    }
  }
  
  void _animateSelection() {
    if (!widget.config.enableAnimations) return;
    
    final newIndex = _getSelectedIndex();
    if (newIndex != null && newIndex < _itemAnimations.length) {
      // Reverse previous animation
      if (_previousIndex != null && _previousIndex! < _itemAnimations.length) {
        _itemAnimations[_previousIndex!].reverse();
      }
      // Forward new animation
      _itemAnimations[newIndex].forward();
      _previousIndex = newIndex;
    }
  }
  
  int? _getSelectedIndex() {
    final items = widget.config.visibleItems;
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == widget.selectedId) {
        return i;
      }
    }
    return null;
  }
  
  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }
  
  void _disposeAnimations() {
    for (final controller in _itemAnimations) {
      controller.dispose();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = widget.config.visibleItems;
    
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    
    switch (widget.type) {
      case NavigationBarType.material3:
        return _buildMaterial3NavigationBar(context, theme, items);
      case NavigationBarType.material2:
        return _buildMaterial2BottomNavigation(context, theme, items);
      case NavigationBarType.custom:
        return _buildCustomNavigationBar(context, theme, items);
    }
  }
  
  Widget _buildMaterial3NavigationBar(
    BuildContext context,
    ThemeData theme,
    List<VooNavigationItem> items,
  ) {
    final selectedIndex = _getSelectedIndex() ?? 0;
    
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        if (widget.enableFeedback) {
          HapticFeedback.lightImpact();
        }
        final item = items[index];
        if (item.isEnabled) {
          widget.onNavigationItemSelected(item.id);
        }
      },
      height: widget.height,
      backgroundColor: widget.backgroundColor ?? 
          widget.config.navigationBackgroundColor,
      elevation: widget.elevation ?? widget.config.elevation,
      labelBehavior: widget.showLabels
          ? (widget.showSelectedLabels 
              ? NavigationDestinationLabelBehavior.onlyShowSelected
              : NavigationDestinationLabelBehavior.alwaysShow)
          : NavigationDestinationLabelBehavior.alwaysHide,
      indicatorColor: widget.config.indicatorColor,
      indicatorShape: widget.config.indicatorShape,
      destinations: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == selectedIndex;
        
        return NavigationDestination(
          icon: _buildIconWithBadge(item, isSelected, index),
          selectedIcon: _buildIconWithBadge(item, isSelected, index, useSelected: true),
          label: item.label,
          tooltip: item.effectiveTooltip,
          enabled: item.isEnabled,
        );
      }).toList(),
    );
  }
  
  Widget _buildMaterial2BottomNavigation(
    BuildContext context,
    ThemeData theme,
    List<VooNavigationItem> items,
  ) {
    final selectedIndex = _getSelectedIndex() ?? 0;
    
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (widget.enableFeedback) {
          HapticFeedback.lightImpact();
        }
        final item = items[index];
        if (item.isEnabled) {
          widget.onNavigationItemSelected(item.id);
        }
      },
      backgroundColor: widget.backgroundColor ?? 
          widget.config.navigationBackgroundColor,
      elevation: widget.elevation ?? widget.config.elevation ?? 8,
      selectedItemColor: widget.config.selectedItemColor,
      unselectedItemColor: widget.config.unselectedItemColor,
      showSelectedLabels: widget.showSelectedLabels,
      showUnselectedLabels: widget.showLabels,
      type: items.length > 3 
          ? BottomNavigationBarType.fixed 
          : BottomNavigationBarType.shifting,
      items: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == selectedIndex;
        
        return BottomNavigationBarItem(
          icon: _buildIconWithBadge(item, isSelected, index),
          activeIcon: _buildIconWithBadge(item, isSelected, index, useSelected: true),
          label: item.label,
          tooltip: item.effectiveTooltip,
          backgroundColor: item.iconColor?.withAlpha((0.1 * 255).round()),
        );
      }).toList(),
    );
  }
  
  Widget _buildCustomNavigationBar(
    BuildContext context,
    ThemeData theme,
    List<VooNavigationItem> items,
  ) {
    final selectedIndex = _getSelectedIndex() ?? 0;
    final colorScheme = theme.colorScheme;
    
    return Container(
      height: widget.height ?? 80,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? 
            widget.config.navigationBackgroundColor ??
            colorScheme.surface,
        boxShadow: widget.elevation != null ? [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: widget.elevation!,
            offset: Offset(0, -widget.elevation! / 2),
          ),
        ] : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == selectedIndex;
          
          return Expanded(
            child: _buildCustomNavigationItem(
              item: item,
              isSelected: isSelected,
              index: index,
              theme: theme,
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildCustomNavigationItem({
    required VooNavigationItem item,
    required bool isSelected,
    required int index,
    required ThemeData theme,
  }) {
    final colorScheme = theme.colorScheme;
    final selectedColor = widget.config.selectedItemColor ?? colorScheme.primary;
    final unselectedColor = widget.config.unselectedItemColor ?? 
        colorScheme.onSurfaceVariant;
    
    return InkWell(
      onTap: item.isEnabled ? () {
        if (widget.enableFeedback) {
          HapticFeedback.lightImpact();
        }
        widget.onNavigationItemSelected(item.id);
      } : null,
      child: AnimatedContainer(
        duration: widget.config.animationDuration,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            AnimatedBuilder(
              animation: _scaleAnimations[index],
              builder: (context, child) => Transform.scale(
                  scale: _scaleAnimations[index].value,
                  child: _buildIconWithBadge(
                    item, 
                    isSelected, 
                    index,
                    useSelected: isSelected,
                  ),
                ),
            ),
            
            // Animated label
            if (widget.showLabels && (!widget.showSelectedLabels || isSelected))
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: theme.textTheme.labelSmall!.copyWith(
                  color: isSelected ? selectedColor : unselectedColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIconWithBadge(
    VooNavigationItem item,
    bool isSelected,
    int index, {
    bool useSelected = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedColor = widget.config.selectedItemColor ?? colorScheme.primary;
    final unselectedColor = widget.config.unselectedItemColor ?? 
        colorScheme.onSurfaceVariant;
    
    final Widget icon = item.leadingWidget ?? Icon(
      useSelected ? item.effectiveSelectedIcon : item.icon,
      color: isSelected 
          ? (item.selectedIconColor ?? selectedColor)
          : (item.iconColor ?? unselectedColor),
    );
    
    if (item.hasBadge) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(
            top: -4,
            right: -4,
            child: VooNavigationBadge(
              item: item,
              config: widget.config,
            ),
          ),
        ],
      );
    }
    
    return icon;
  }
}

/// Type of bottom navigation bar
enum NavigationBarType {
  /// Material 3 NavigationBar
  material3,
  
  /// Material 2 BottomNavigationBar
  material2,
  
  /// Custom implementation
  custom,
}