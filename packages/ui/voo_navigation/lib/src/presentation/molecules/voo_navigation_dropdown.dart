import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_dropdown_children.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_dropdown_header.dart';

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
    if (!widget.item.hasChildren) {
      return const SizedBox.shrink();
    }

    final hasSelectedChild =
        widget.item.children?.any((child) => child.id == widget.selectedId) ??
        false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VooDropdownHeader(
          item: widget.item,
          config: widget.config,
          hasSelectedChild: hasSelectedChild,
          selectedId: widget.selectedId,
          isExpanded: _isExpanded,
          rotationAnimation: _rotationAnimation,
          onTap: _handleTap,
          tilePadding: widget.tilePadding,
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: VooDropdownChildren(
            parentItem: widget.item,
            config: widget.config,
            selectedId: widget.selectedId,
            onItemSelected: widget.onItemSelected,
            showDividers: widget.showDividers,
            childrenPadding: widget.childrenPadding,
          ),
        ),
      ],
    );
  }
}
