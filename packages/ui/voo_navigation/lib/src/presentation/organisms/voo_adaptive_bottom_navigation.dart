import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_custom_navigation_bar.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_material2_bottom_navigation.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_material3_navigation_bar.dart';

/// Adaptive bottom navigation bar for mobile layouts with Material 3 design
/// Features smooth animations, haptic feedback, and beautiful visual transitions
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
  final VooNavigationBarType type;

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
    this.type = VooNavigationBarType.material3,
    this.backgroundColor,
    this.elevation,
    this.enableFeedback = true,
  });

  @override
  State<VooAdaptiveBottomNavigation> createState() =>
      _VooAdaptiveBottomNavigationState();
}

class _VooAdaptiveBottomNavigationState
    extends State<VooAdaptiveBottomNavigation>
    with TickerProviderStateMixin {
  late List<AnimationController> _itemAnimations;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _rotationAnimations;
  late AnimationController _rippleController;
  int? _previousIndex;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final itemCount = widget.config.mobilePriorityItems.length;
    _itemAnimations = List.generate(
      itemCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _scaleAnimations = _itemAnimations
        .map(
          (controller) => Tween<double>(begin: 1.0, end: 1.15).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
          ),
        )
        .toList();

    _rotationAnimations = _itemAnimations
        .map(
          (controller) => Tween<double>(begin: 0.0, end: 0.05).animate(
            CurvedAnimation(parent: controller, curve: Curves.elasticOut),
          ),
        )
        .toList();

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

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

    if (widget.config.mobilePriorityItems.length !=
        oldWidget.config.mobilePriorityItems.length) {
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
    final items = widget.config.mobilePriorityItems;
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
    _rippleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.config.mobilePriorityItems;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedIndex = _getSelectedIndex() ?? 0;

    switch (widget.type) {
      case VooNavigationBarType.material3:
        return VooMaterial3NavigationBar(
          items: items,
          selectedIndex: selectedIndex,
          config: widget.config,
          scaleAnimations: _scaleAnimations,
          height: widget.height,
          backgroundColor: widget.backgroundColor,
          elevation: widget.elevation,
          showLabels: widget.showLabels,
          showSelectedLabels: widget.showSelectedLabels,
          enableFeedback: widget.enableFeedback,
          onItemSelected: widget.onNavigationItemSelected,
        );
      case VooNavigationBarType.material2:
        return VooMaterial2BottomNavigation(
          items: items,
          selectedIndex: selectedIndex,
          config: widget.config,
          backgroundColor: widget.backgroundColor,
          elevation: widget.elevation,
          showLabels: widget.showLabels,
          showSelectedLabels: widget.showSelectedLabels,
          enableFeedback: widget.enableFeedback,
          onItemSelected: widget.onNavigationItemSelected,
        );
      case VooNavigationBarType.custom:
        return VooCustomNavigationBar(
          items: items,
          selectedIndex: selectedIndex,
          config: widget.config,
          scaleAnimations: _scaleAnimations,
          rotationAnimations: _rotationAnimations,
          height: widget.height,
          showLabels: widget.showLabels,
          showSelectedLabels: widget.showSelectedLabels,
          enableFeedback: widget.enableFeedback,
          onItemSelected: widget.onNavigationItemSelected,
        );
    }
  }
}

/// Type of bottom navigation bar
enum VooNavigationBarType {
  /// Material 3 NavigationBar
  material3,

  /// Material 2 BottomNavigationBar
  material2,

  /// Custom implementation
  custom,
}
