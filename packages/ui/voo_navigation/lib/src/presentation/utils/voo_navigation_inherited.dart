import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';

/// InheritedWidget to pass navigation configuration down the widget tree
class VooNavigationInherited extends InheritedWidget {
  /// The navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;

  const VooNavigationInherited({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    required super.child,
  });

  static VooNavigationInherited? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VooNavigationInherited>();
  }

  static VooNavigationInherited of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No VooNavigationInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(VooNavigationInherited oldWidget) {
    return config != oldWidget.config ||
        selectedId != oldWidget.selectedId ||
        onNavigationItemSelected != oldWidget.onNavigationItemSelected;
  }
}