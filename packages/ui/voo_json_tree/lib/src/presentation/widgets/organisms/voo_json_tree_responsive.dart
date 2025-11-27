import 'package:flutter/material.dart';
import 'package:voo_responsive/voo_responsive.dart';

import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_config.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_tokens.dart';
import 'package:voo_json_tree/src/presentation/controllers/json_tree_controller.dart';
import 'package:voo_json_tree/src/presentation/widgets/voo_json_tree.dart';

/// A responsive wrapper for [VooJsonTree] that adapts to screen size.
///
/// Automatically adjusts font size, spacing, and UI elements based on
/// the current screen size using the voo_responsive package.
///
/// ## Screen Size Adaptations
///
/// - **Mobile** (<600px): Smaller fonts, compact spacing, simplified toolbar
/// - **Tablet** (600-1200px): Standard layout with full features
/// - **Desktop** (>1200px): Larger fonts, more spacing, full keyboard navigation
///
/// ## Usage
///
/// ```dart
/// VooJsonTreeResponsive(
///   data: jsonData,
///   theme: VooJsonTreeTheme.system(context),
/// )
/// ```
///
/// ## With Custom Breakpoint Behavior
///
/// ```dart
/// VooJsonTreeResponsive(
///   data: jsonData,
///   mobileConfig: JsonTreeConfig.minimal(),
///   tabletConfig: JsonTreeConfig.compact(),
///   desktopConfig: JsonTreeConfig.full(),
/// )
/// ```
class VooJsonTreeResponsive extends StatelessWidget {
  /// Creates a responsive JSON tree widget.
  const VooJsonTreeResponsive({
    super.key,
    this.data,
    this.controller,
    this.theme,
    this.mobileConfig,
    this.tabletConfig,
    this.desktopConfig,
    this.showToolbar = true,
    this.showPathBreadcrumb = false,
    this.rootName = 'root',
    this.onNodeTap,
    this.onNodeDoubleTap,
    this.onValueChanged,
  }) : assert(data != null || controller != null, 'Either data or controller must be provided');

  /// The JSON data to display.
  final dynamic data;

  /// External controller for managing tree state.
  final JsonTreeController? controller;

  /// Theme configuration. If not provided, uses [VooJsonTreeTheme.fromTokens].
  final VooJsonTreeTheme? theme;

  /// Configuration for mobile screens (<600px).
  /// Defaults to a compact config with touch-friendly settings.
  final JsonTreeConfig? mobileConfig;

  /// Configuration for tablet screens (600-1200px).
  /// Defaults to standard configuration.
  final JsonTreeConfig? tabletConfig;

  /// Configuration for desktop screens (>1200px).
  /// Defaults to full-featured configuration.
  final JsonTreeConfig? desktopConfig;

  /// Whether to show the toolbar.
  final bool showToolbar;

  /// Whether to show the path breadcrumb.
  final bool showPathBreadcrumb;

  /// Name for the root node.
  final String rootName;

  /// Callback when a node is tapped.
  final void Function(JsonNode node)? onNodeTap;

  /// Callback when a node is double-tapped.
  final void Function(JsonNode node)? onNodeDoubleTap;

  /// Callback when a value is changed.
  final void Function(String path, dynamic newValue)? onValueChanged;

  @override
  Widget build(BuildContext context) => VooResponsiveBuilder(
    builder: (context, screenInfo) {
      final config = _getConfigForScreenSize(screenInfo.screenSize);
      final adaptedTheme = _getThemeForScreenSize(context, screenInfo);

      return VooJsonTree(
        data: data,
        controller: controller,
        theme: adaptedTheme,
        config: config,
        showToolbar: showToolbar && _shouldShowToolbar(screenInfo.screenSize),
        showPathBreadcrumb: showPathBreadcrumb,
        rootName: rootName,
        onNodeTap: onNodeTap,
        onNodeDoubleTap: onNodeDoubleTap,
        onValueChanged: onValueChanged,
      );
    },
  );

  /// Gets the appropriate config for the current screen size.
  JsonTreeConfig _getConfigForScreenSize(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.extraSmall:
      case ScreenSize.small:
        return mobileConfig ?? _defaultMobileConfig;
      case ScreenSize.medium:
        return tabletConfig ?? _defaultTabletConfig;
      case ScreenSize.large:
      case ScreenSize.extraLarge:
        return desktopConfig ?? _defaultDesktopConfig;
    }
  }

  /// Gets the appropriate theme for the current screen size.
  VooJsonTreeTheme _getThemeForScreenSize(BuildContext context, ScreenInfo screenInfo) {
    final baseTheme = theme ?? VooJsonTreeTheme.fromTokens();
    final screenWidth = screenInfo.width;

    // Adapt font size and spacing based on screen width
    return baseTheme.copyWith(
      fontSize: JsonTreeTokens.getResponsiveFontSize(screenWidth),
      indentWidth: JsonTreeTokens.getResponsiveIndentWidth(screenWidth),
      padding: JsonTreeTokens.getResponsiveContainerPadding(screenWidth),
    );
  }

  /// Determines if toolbar should be shown on this screen size.
  bool _shouldShowToolbar(ScreenSize screenSize) {
    // On very small screens, hide toolbar unless explicitly requested
    if (screenSize == ScreenSize.extraSmall) {
      return showToolbar;
    }
    return showToolbar;
  }

  /// Default mobile configuration with touch-friendly settings.
  static JsonTreeConfig get _defaultMobileConfig => const JsonTreeConfig(
    showNodeCount: false, // Save space
    showRootNode: false, // Save space
    enableHover: false, // No hover on touch
    enableContextMenu: false, // Use tap actions instead
    enableKeyboardNavigation: false, // No keyboard on mobile
    maxDisplayStringLength: 50, // Shorter for small screens
  );

  /// Default tablet configuration.
  static JsonTreeConfig get _defaultTabletConfig => const JsonTreeConfig();

  /// Default desktop configuration with full features.
  static JsonTreeConfig get _defaultDesktopConfig => const JsonTreeConfig(
    expandDepth: 2,
    maxDisplayStringLength: 150, // More space for content
  );
}
