import 'package:voo_json_tree/src/domain/entities/json_tree_tokens.dart';

/// Configuration options for the JSON tree viewer.
///
/// ## Predefined Configurations
///
/// Use factory constructors for common use cases:
/// - [JsonTreeConfig.readOnly] - No editing or context menu
/// - [JsonTreeConfig.compact] - Minimal UI elements
/// - [JsonTreeConfig.full] - All features enabled
/// - [JsonTreeConfig.minimal] - Bare minimum (just tree, no extras)
/// - [JsonTreeConfig.developer] - Debug-friendly with expanded view
/// - [JsonTreeConfig.editable] - Editing-focused with helpful UI
///
/// ## Custom Configuration
///
/// ```dart
/// JsonTreeConfig(
///   expandDepth: 2,
///   enableSearch: true,
///   enableCopy: true,
///   showNodeCount: false,
/// )
/// ```
class JsonTreeConfig {
  /// Creates a new [JsonTreeConfig].
  const JsonTreeConfig({
    this.expandDepth = 1,
    this.showArrayIndices = true,
    this.showNodeCount = true,
    this.showRootNode = true,
    this.rootNodeName = 'root',
    this.enableSearch = true,
    this.enableCopy = true,
    this.enableEditing = false,
    this.enableSelection = true,
    this.enableHover = true,
    this.enableContextMenu = true,
    this.enableKeyboardNavigation = true,
    this.animateExpansion = true,
    this.expansionAnimationDuration = const Duration(milliseconds: 200),
    this.maxDisplayStringLength = 100,
    this.searchDebounceMs = 300,
  });

  /// Default depth to auto-expand on initial load.
  ///
  /// Set to 0 to collapse all, or -1 to expand all.
  final int expandDepth;

  /// Whether to show array indices (e.g., [0], [1]).
  final bool showArrayIndices;

  /// Whether to show node counts for objects and arrays.
  final bool showNodeCount;

  /// Whether to show the root node.
  final bool showRootNode;

  /// Name to display for the root node.
  final String rootNodeName;

  /// Whether to enable search functionality.
  final bool enableSearch;

  /// Whether to enable copy-to-clipboard functionality.
  final bool enableCopy;

  /// Whether to enable in-place value editing.
  final bool enableEditing;

  /// Whether to enable node selection.
  final bool enableSelection;

  /// Whether to show hover effects.
  final bool enableHover;

  /// Whether to enable right-click context menu.
  final bool enableContextMenu;

  /// Whether to enable keyboard navigation.
  final bool enableKeyboardNavigation;

  /// Whether to animate expand/collapse.
  final bool animateExpansion;

  /// Duration of expansion animation.
  final Duration expansionAnimationDuration;

  /// Maximum string length to display before truncating.
  final int maxDisplayStringLength;

  /// Debounce delay for search input in milliseconds.
  final int searchDebounceMs;

  /// Creates a read-only configuration preset.
  factory JsonTreeConfig.readOnly() => const JsonTreeConfig(enableContextMenu: false);

  /// Creates a compact configuration preset.
  factory JsonTreeConfig.compact() => const JsonTreeConfig(showNodeCount: false, showRootNode: false, animateExpansion: false);

  /// Creates a fully-featured configuration preset.
  factory JsonTreeConfig.full() => const JsonTreeConfig(expandDepth: 2, enableEditing: true);

  /// Creates a minimal configuration with only essential features.
  ///
  /// This preset disables:
  /// - Search functionality
  /// - Copy buttons
  /// - Context menu
  /// - Selection highlighting
  /// - Hover effects
  /// - Keyboard navigation
  /// - Animations
  ///
  /// Only the basic collapsible tree with syntax highlighting is shown.
  ///
  /// ```dart
  /// VooJsonTree(
  ///   data: jsonData,
  ///   config: JsonTreeConfig.minimal(),
  ///   showToolbar: false,
  /// )
  /// ```
  factory JsonTreeConfig.minimal() => const JsonTreeConfig(
    showNodeCount: false,
    enableSearch: false,
    enableCopy: false,
    enableSelection: false,
    enableHover: false,
    enableContextMenu: false,
    enableKeyboardNavigation: false,
    animateExpansion: false,
  );

  /// Creates a developer-friendly configuration for debugging.
  ///
  /// This preset:
  /// - Expands all nodes by default (-1)
  /// - Shows array indices and node counts
  /// - Enables all navigation and copy features
  /// - Shows root node for complete structure visibility
  ///
  /// Ideal for inspecting JSON data during development.
  ///
  /// ```dart
  /// VooJsonTree(
  ///   data: apiResponse,
  ///   config: JsonTreeConfig.developer(),
  /// )
  /// ```
  factory JsonTreeConfig.developer() => JsonTreeConfig(
    expandDepth: -1, // Expand all
    expansionAnimationDuration: JsonTreeTokens.expansionDuration,
    maxDisplayStringLength: 200, // Show more content
  );

  /// Creates an editing-focused configuration.
  ///
  /// This preset enables:
  /// - In-place value editing
  /// - Full context menu
  /// - All navigation features
  /// - Reasonable expand depth for editing
  ///
  /// ```dart
  /// VooJsonTree(
  ///   data: editableData,
  ///   config: JsonTreeConfig.editable(),
  ///   onValueChanged: (path, value) => updateData(path, value),
  /// )
  /// ```
  factory JsonTreeConfig.editable() => JsonTreeConfig(expandDepth: 2, enableEditing: true, expansionAnimationDuration: JsonTreeTokens.expansionDuration);

  /// Creates a copy with the given fields replaced.
  JsonTreeConfig copyWith({
    int? expandDepth,
    bool? showArrayIndices,
    bool? showNodeCount,
    bool? showRootNode,
    String? rootNodeName,
    bool? enableSearch,
    bool? enableCopy,
    bool? enableEditing,
    bool? enableSelection,
    bool? enableHover,
    bool? enableContextMenu,
    bool? enableKeyboardNavigation,
    bool? animateExpansion,
    Duration? expansionAnimationDuration,
    int? maxDisplayStringLength,
    int? searchDebounceMs,
  }) => JsonTreeConfig(
    expandDepth: expandDepth ?? this.expandDepth,
    showArrayIndices: showArrayIndices ?? this.showArrayIndices,
    showNodeCount: showNodeCount ?? this.showNodeCount,
    showRootNode: showRootNode ?? this.showRootNode,
    rootNodeName: rootNodeName ?? this.rootNodeName,
    enableSearch: enableSearch ?? this.enableSearch,
    enableCopy: enableCopy ?? this.enableCopy,
    enableEditing: enableEditing ?? this.enableEditing,
    enableSelection: enableSelection ?? this.enableSelection,
    enableHover: enableHover ?? this.enableHover,
    enableContextMenu: enableContextMenu ?? this.enableContextMenu,
    enableKeyboardNavigation: enableKeyboardNavigation ?? this.enableKeyboardNavigation,
    animateExpansion: animateExpansion ?? this.animateExpansion,
    expansionAnimationDuration: expansionAnimationDuration ?? this.expansionAnimationDuration,
    maxDisplayStringLength: maxDisplayStringLength ?? this.maxDisplayStringLength,
    searchDebounceMs: searchDebounceMs ?? this.searchDebounceMs,
  );
}
