import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_builders.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_config.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';
import 'package:voo_json_tree/src/presentation/controllers/json_tree_controller.dart';
import 'package:voo_json_tree/src/presentation/widgets/molecules/path_breadcrumb.dart';
import 'package:voo_json_tree/src/presentation/widgets/organisms/json_tree_toolbar.dart';
import 'package:voo_json_tree/src/presentation/widgets/organisms/json_tree_view.dart';

/// A feature-rich JSON tree viewer/editor widget.
///
/// Displays JSON data in an interactive tree structure with support for:
/// - Collapsible/expandable nodes
/// - Syntax highlighting by value type
/// - Search functionality
/// - Copy path/value to clipboard
/// - Keyboard navigation
///
/// ## Basic Usage
///
/// ```dart
/// VooJsonTree(
///   data: {'name': 'John', 'age': 30},
/// )
/// ```
///
/// ## With Controller
///
/// ```dart
/// final controller = JsonTreeController();
/// controller.setData(jsonData);
///
/// VooJsonTree(
///   controller: controller,
///   theme: VooJsonTreeTheme.dark(),
///   config: JsonTreeConfig(
///     expandDepth: 2,
///     enableSearch: true,
///   ),
/// )
/// ```
class VooJsonTree extends StatefulWidget {
  /// Creates a new [VooJsonTree].
  ///
  /// Either [data] or [controller] must be provided.
  /// If [data] is provided, an internal controller will be created.
  const VooJsonTree({
    super.key,
    this.data,
    this.controller,
    this.theme,
    this.config,
    this.builders,
    this.showToolbar = true,
    this.showPathBreadcrumb = false,
    this.rootName = 'root',
    this.onNodeTap,
    this.onNodeDoubleTap,
    this.onValueChanged,
  }) : assert(data != null || controller != null, 'Either data or controller must be provided');

  /// The JSON data to display.
  ///
  /// Can be a Map, List, or JSON-compatible primitive.
  final dynamic data;

  /// External controller for managing tree state.
  ///
  /// If not provided, an internal controller will be created.
  final JsonTreeController? controller;

  /// Theme configuration for styling.
  final VooJsonTreeTheme? theme;

  /// Configuration options.
  final JsonTreeConfig? config;

  /// Custom builders for node rendering.
  ///
  /// Use this to customize how nodes, keys, and values are rendered.
  ///
  /// ```dart
  /// VooJsonTree(
  ///   data: jsonData,
  ///   builders: JsonTreeBuilders(
  ///     valueBuilder: (context, node, defaultWidget) {
  ///       if (node.value is String && node.value.startsWith('http')) {
  ///         return InkWell(
  ///           onTap: () => launchUrl(Uri.parse(node.value)),
  ///           child: Text(node.value, style: TextStyle(color: Colors.blue)),
  ///         );
  ///       }
  ///       return defaultWidget;
  ///     },
  ///   ),
  /// )
  /// ```
  final JsonTreeBuilders? builders;

  /// Whether to show the toolbar with search.
  final bool showToolbar;

  /// Whether to show the path breadcrumb for selected node.
  final bool showPathBreadcrumb;

  /// Name for the root node.
  final String rootName;

  /// Callback when a node is tapped.
  final void Function(JsonNode node)? onNodeTap;

  /// Callback when a node is double-tapped.
  final void Function(JsonNode node)? onNodeDoubleTap;

  /// Callback when a value is changed (editing mode).
  final void Function(String path, dynamic newValue)? onValueChanged;

  /// Creates a VooJsonTree from a JSON string.
  factory VooJsonTree.fromString(
    String jsonString, {
    Key? key,
    VooJsonTreeTheme? theme,
    JsonTreeConfig? config,
    bool showToolbar = true,
    String rootName = 'root',
  }) {
    final controller = JsonTreeController(config: config);
    controller.setDataFromString(jsonString, rootName: rootName);

    return VooJsonTree(key: key, controller: controller, theme: theme, config: config, showToolbar: showToolbar, rootName: rootName);
  }

  /// Creates a read-only VooJsonTree.
  factory VooJsonTree.readOnly({Key? key, required dynamic data, VooJsonTreeTheme? theme, bool showToolbar = false, String rootName = 'root'}) =>
      VooJsonTree(key: key, data: data, theme: theme, config: JsonTreeConfig.readOnly(), showToolbar: showToolbar, rootName: rootName);

  /// Creates a VooJsonTree with search enabled.
  factory VooJsonTree.searchable({Key? key, required dynamic data, VooJsonTreeTheme? theme, JsonTreeConfig? config, String rootName = 'root'}) =>
      VooJsonTree(key: key, data: data, theme: theme, config: (config ?? const JsonTreeConfig()).copyWith(enableSearch: true), rootName: rootName);

  /// Creates a compact VooJsonTree with minimal UI.
  factory VooJsonTree.compact({Key? key, required dynamic data, VooJsonTreeTheme? theme, String rootName = 'root'}) =>
      VooJsonTree(key: key, data: data, theme: theme, config: JsonTreeConfig.compact(), showToolbar: false, rootName: rootName);

  /// Creates a minimal VooJsonTree with only essential features.
  ///
  /// This is the most lightweight version, showing only the collapsible
  /// tree structure with syntax highlighting. All extra features like
  /// search, copy, hover effects, and animations are disabled.
  ///
  /// Ideal for:
  /// - Embedding in tight spaces
  /// - Performance-critical scenarios
  /// - Simple data display without interaction
  ///
  /// ```dart
  /// VooJsonTree.minimal(data: jsonData)
  /// ```
  factory VooJsonTree.minimal({Key? key, required dynamic data, VooJsonTreeTheme? theme, String rootName = 'root', void Function(JsonNode node)? onNodeTap}) =>
      VooJsonTree(key: key, data: data, theme: theme, config: JsonTreeConfig.minimal(), showToolbar: false, rootName: rootName, onNodeTap: onNodeTap);

  /// Creates a VooJsonTree with transparent background and no container styling.
  ///
  /// This factory creates a "raw" tree that inherits styling from its
  /// parent container. Useful when you want to embed the tree in a
  /// custom-styled container.
  ///
  /// ```dart
  /// Container(
  ///   decoration: myCustomDecoration,
  ///   padding: EdgeInsets.all(16),
  ///   child: VooJsonTree.raw(data: jsonData),
  /// )
  /// ```
  factory VooJsonTree.raw({
    Key? key,
    required dynamic data,
    JsonTreeConfig? config,
    String rootName = 'root',
    void Function(JsonNode node)? onNodeTap,
    void Function(JsonNode node)? onNodeDoubleTap,
  }) => VooJsonTree(
    key: key,
    data: data,
    theme: VooJsonTreeTheme.transparent(),
    config: config ?? const JsonTreeConfig(),
    showToolbar: false,
    rootName: rootName,
    onNodeTap: onNodeTap,
    onNodeDoubleTap: onNodeDoubleTap,
  );

  /// Creates a developer-friendly VooJsonTree for debugging.
  ///
  /// This preset expands all nodes by default and shows all metadata
  /// (array indices, node counts, root node). Ideal for inspecting
  /// API responses or debugging data structures.
  ///
  /// ```dart
  /// VooJsonTree.developer(data: apiResponse)
  /// ```
  factory VooJsonTree.developer({
    Key? key,
    required dynamic data,
    VooJsonTreeTheme? theme,
    String rootName = 'root',
    void Function(JsonNode node)? onNodeTap,
  }) => VooJsonTree(key: key, data: data, theme: theme, config: JsonTreeConfig.developer(), showPathBreadcrumb: true, rootName: rootName, onNodeTap: onNodeTap);

  /// Creates an editable VooJsonTree.
  ///
  /// This preset enables in-place editing of values with all supporting
  /// features like context menu and keyboard navigation.
  ///
  /// ```dart
  /// VooJsonTree.editable(
  ///   data: editableData,
  ///   onValueChanged: (path, value) => updateData(path, value),
  /// )
  /// ```
  factory VooJsonTree.editable({
    Key? key,
    required dynamic data,
    VooJsonTreeTheme? theme,
    String rootName = 'root',
    void Function(String path, dynamic newValue)? onValueChanged,
    void Function(JsonNode node)? onNodeTap,
  }) => VooJsonTree(
    key: key,
    data: data,
    theme: theme,
    config: JsonTreeConfig.editable(),
    showPathBreadcrumb: true,
    rootName: rootName,
    onValueChanged: onValueChanged,
    onNodeTap: onNodeTap,
  );

  @override
  State<VooJsonTree> createState() => _VooJsonTreeState();
}

class _VooJsonTreeState extends State<VooJsonTree> {
  late JsonTreeController _controller;
  late VooJsonTreeTheme _theme;
  late JsonTreeConfig _config;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _theme = widget.theme ?? VooJsonTreeTheme.dark();
    _config = widget.config ?? const JsonTreeConfig();
  }

  void _initializeController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = JsonTreeController(config: widget.config);
      _ownsController = true;

      if (widget.data != null) {
        _controller.setData(widget.data, rootName: widget.rootName);
      }
    }
  }

  @override
  void didUpdateWidget(VooJsonTree oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update theme
    if (widget.theme != oldWidget.theme) {
      _theme = widget.theme ?? VooJsonTreeTheme.dark();
    }

    // Update config
    if (widget.config != oldWidget.config) {
      _config = widget.config ?? const JsonTreeConfig();
    }

    // Handle controller changes
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      _initializeController();
    }

    // Handle data changes
    if (widget.data != oldWidget.data && _ownsController) {
      if (widget.data != null) {
        _controller.setData(widget.data, rootName: widget.rootName);
      } else {
        _controller.clear();
      }
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: _theme.backgroundColor, borderRadius: BorderRadius.circular(_theme.borderRadius)),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Toolbar
        if (widget.showToolbar && _config.enableSearch)
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => JsonTreeToolbar(
              theme: _theme,
              onSearch: _controller.search,
              onSearchClear: _controller.clearSearch,
              onNextResult: _controller.nextSearchResult,
              onPreviousResult: _controller.previousSearchResult,
              onExpandAll: _controller.expandAll,
              onCollapseAll: _controller.collapseAll,
              searchResultCount: _controller.searchResults.length,
              currentSearchIndex: _controller.state.currentSearchIndex,
            ),
          ),

        // Path breadcrumb
        if (widget.showPathBreadcrumb)
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              final selectedPath = _controller.selectedPath;
              if (selectedPath == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PathBreadcrumb(
                  path: selectedPath,
                  theme: _theme,
                  onSegmentTap: (path) {
                    _controller.selectNode(path);
                    _controller.revealNode(path);
                  },
                ),
              );
            },
          ),

        // Tree view
        Expanded(
          child: Padding(
            padding: _theme.padding,
            child: JsonTreeView(
              controller: _controller,
              theme: _theme,
              config: _config,
              builders: widget.builders,
              onNodeTap: widget.onNodeTap,
              onNodeDoubleTap: widget.onNodeDoubleTap,
              onValueChanged: widget.onValueChanged,
            ),
          ),
        ),

        // Error display
        ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final error = _controller.error;
            if (error == null) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.red.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error,
                      style: TextStyle(fontFamily: _theme.fontFamily, fontSize: _theme.fontSize * 0.9, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}
