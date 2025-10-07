import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a single navigation item with support for badges, dropdowns, and customization
class VooNavigationItem extends Equatable {
  /// Unique identifier for the navigation item
  final String id;

  /// Display label for the navigation item
  final String label;

  /// Icon for the navigation item
  final IconData icon;

  /// Selected/active icon (optional, defaults to icon)
  final IconData? selectedIcon;

  /// Route path associated with this item
  final String? route;

  /// Custom widget to navigate to (alternative to route)
  final Widget? destination;

  /// Badge count to display (e.g., notifications)
  final int? badgeCount;

  /// Badge text to display (alternative to count)
  final String? badgeText;

  /// Badge color (defaults to theme error color for counts > 0)
  final Color? badgeColor;

  /// Whether to show a dot indicator instead of badge text
  final bool showDot;

  /// Child navigation items for dropdown/submenu
  final List<VooNavigationItem>? children;

  /// Whether this item is initially expanded (for items with children)
  final bool isExpanded;

  /// Whether this item is enabled
  final bool isEnabled;

  /// Whether this item is visible
  final bool isVisible;

  /// Custom tooltip text (defaults to label)
  final String? tooltip;

  /// Custom callback when item is selected
  final VoidCallback? onTap;

  /// Custom leading widget (replaces icon)
  final Widget? leadingWidget;

  /// Custom trailing widget (in addition to badges)
  final Widget? trailingWidget;

  /// Custom color for the icon
  final Color? iconColor;

  /// Custom color for the selected icon
  final Color? selectedIconColor;

  /// Custom text style for the label
  final TextStyle? labelStyle;

  /// Custom text style for the selected label
  final TextStyle? selectedLabelStyle;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Sort order for the item (lower values appear first)
  final int sortOrder;

  /// Whether this item should be shown in mobile bottom navigation (max 4 items)
  final bool mobilePriority;

  /// Custom key for the widget
  final Key? key;

  const VooNavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.route,
    this.destination,
    this.badgeCount,
    this.badgeText,
    this.badgeColor,
    this.showDot = false,
    this.children,
    this.isExpanded = false,
    this.isEnabled = true,
    this.isVisible = true,
    this.tooltip,
    this.onTap,
    this.leadingWidget,
    this.trailingWidget,
    this.iconColor,
    this.selectedIconColor,
    this.labelStyle,
    this.selectedLabelStyle,
    this.semanticLabel,
    this.sortOrder = 0,
    this.mobilePriority = false,
    this.key,
  }) : assert(
         route != null ||
             destination != null ||
             onTap != null ||
             children != null,
         'Navigation item must have either a route, destination, onTap callback, or children',
       );

  @override
  List<Object?> get props => [
    id,
    label,
    icon,
    selectedIcon,
    route,
    badgeCount,
    badgeText,
    badgeColor,
    showDot,
    children,
    isExpanded,
    isEnabled,
    isVisible,
    tooltip,
    iconColor,
    selectedIconColor,
    sortOrder,
    mobilePriority,
  ];

  /// Creates a copy of this item with the given fields replaced
  VooNavigationItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    IconData? selectedIcon,
    String? route,
    Widget? destination,
    int? badgeCount,
    String? badgeText,
    Color? badgeColor,
    bool? showDot,
    List<VooNavigationItem>? children,
    bool? isExpanded,
    bool? isEnabled,
    bool? isVisible,
    String? tooltip,
    VoidCallback? onTap,
    Widget? leadingWidget,
    Widget? trailingWidget,
    Color? iconColor,
    Color? selectedIconColor,
    TextStyle? labelStyle,
    TextStyle? selectedLabelStyle,
    String? semanticLabel,
    int? sortOrder,
    bool? mobilePriority,
    Key? key,
  }) => VooNavigationItem(
    id: id ?? this.id,
    label: label ?? this.label,
    icon: icon ?? this.icon,
    selectedIcon: selectedIcon ?? this.selectedIcon,
    route: route ?? this.route,
    destination: destination ?? this.destination,
    badgeCount: badgeCount ?? this.badgeCount,
    badgeText: badgeText ?? this.badgeText,
    badgeColor: badgeColor ?? this.badgeColor,
    showDot: showDot ?? this.showDot,
    children: children ?? this.children,
    isExpanded: isExpanded ?? this.isExpanded,
    isEnabled: isEnabled ?? this.isEnabled,
    isVisible: isVisible ?? this.isVisible,
    tooltip: tooltip ?? this.tooltip,
    onTap: onTap ?? this.onTap,
    leadingWidget: leadingWidget ?? this.leadingWidget,
    trailingWidget: trailingWidget ?? this.trailingWidget,
    iconColor: iconColor ?? this.iconColor,
    selectedIconColor: selectedIconColor ?? this.selectedIconColor,
    labelStyle: labelStyle ?? this.labelStyle,
    selectedLabelStyle: selectedLabelStyle ?? this.selectedLabelStyle,
    semanticLabel: semanticLabel ?? this.semanticLabel,
    sortOrder: sortOrder ?? this.sortOrder,
    mobilePriority: mobilePriority ?? this.mobilePriority,
    key: key ?? this.key,
  );

  /// Whether this item has a badge (count or text)
  bool get hasBadge => badgeCount != null || badgeText != null || showDot;

  /// Whether this item has children (dropdown/submenu)
  bool get hasChildren => children != null && children!.isNotEmpty;

  /// Gets the effective tooltip text
  String get effectiveTooltip => tooltip ?? label;

  /// Gets the effective semantic label
  String get effectiveSemanticLabel {
    if (semanticLabel != null) return semanticLabel!;
    if (hasBadge && badgeCount != null) {
      return '$label, $badgeCount notifications';
    }
    return label;
  }

  /// Gets the effective selected icon
  IconData get effectiveSelectedIcon => selectedIcon ?? icon;

  /// Whether this item is a divider
  bool get isDivider => label.isEmpty && icon == Icons.remove;

  /// Convenience factory for creating a divider item
  factory VooNavigationItem.divider({String? id}) => VooNavigationItem(
    id: id ?? 'divider_${DateTime.now().millisecondsSinceEpoch}',
    label: '',
    icon: Icons.remove,
    onTap: () {},
  );

  /// Convenience factory for creating a section header
  factory VooNavigationItem.section({
    required String label,
    String? id,
    List<VooNavigationItem>? children,
    bool isExpanded = true,
  }) => VooNavigationItem(
    id: id ?? 'section_${label.toLowerCase().replaceAll(' ', '_')}',
    label: label,
    icon: Icons.folder_outlined,
    selectedIcon: Icons.folder,
    children: children,
    isExpanded: isExpanded,
  );
}
