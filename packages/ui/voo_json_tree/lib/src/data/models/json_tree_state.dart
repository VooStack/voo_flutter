import 'package:equatable/equatable.dart';

import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_search_result.dart';

/// Represents the current state of the JSON tree.
class JsonTreeState extends Equatable {
  /// Creates a new [JsonTreeState].
  const JsonTreeState({
    this.rootNode,
    this.expandedPaths = const {},
    this.selectedPath,
    this.hoveredPath,
    this.searchQuery = '',
    this.searchResults = const [],
    this.currentSearchIndex = 0,
    this.isLoading = false,
    this.error,
    this.editingPath,
  });

  /// The root node of the JSON tree.
  final JsonNode? rootNode;

  /// Set of expanded node paths.
  final Set<String> expandedPaths;

  /// The currently selected node path.
  final String? selectedPath;

  /// The currently hovered node path.
  final String? hoveredPath;

  /// Current search query.
  final String searchQuery;

  /// List of search results.
  final List<JsonSearchResult> searchResults;

  /// Current search result index.
  final int currentSearchIndex;

  /// Whether the tree is loading.
  final bool isLoading;

  /// Error message if any.
  final String? error;

  /// Path of the node currently being edited.
  final String? editingPath;

  /// Returns true if a node is expanded.
  bool isExpanded(String path) => expandedPaths.contains(path);

  /// Returns true if a node is selected.
  bool isSelected(String path) => selectedPath == path;

  /// Returns true if a node is being hovered.
  bool isHovered(String path) => hoveredPath == path;

  /// Returns true if a node is being edited.
  bool isEditing(String path) => editingPath == path;

  /// Returns true if search is active.
  bool get isSearchActive => searchQuery.isNotEmpty;

  /// Returns the current search result if any.
  JsonSearchResult? get currentSearchResult {
    if (searchResults.isEmpty) return null;
    if (currentSearchIndex >= searchResults.length) return null;
    return searchResults[currentSearchIndex];
  }

  /// Returns true if a path matches the current search.
  bool isSearchMatch(String path) => searchResults.any((r) => r.path == path);

  /// Creates a copy with the given fields replaced.
  JsonTreeState copyWith({
    JsonNode? rootNode,
    Set<String>? expandedPaths,
    String? selectedPath,
    String? hoveredPath,
    String? searchQuery,
    List<JsonSearchResult>? searchResults,
    int? currentSearchIndex,
    bool? isLoading,
    String? error,
    String? editingPath,
    bool clearSelectedPath = false,
    bool clearHoveredPath = false,
    bool clearError = false,
    bool clearEditingPath = false,
  }) => JsonTreeState(
    rootNode: rootNode ?? this.rootNode,
    expandedPaths: expandedPaths ?? this.expandedPaths,
    selectedPath: clearSelectedPath ? null : (selectedPath ?? this.selectedPath),
    hoveredPath: clearHoveredPath ? null : (hoveredPath ?? this.hoveredPath),
    searchQuery: searchQuery ?? this.searchQuery,
    searchResults: searchResults ?? this.searchResults,
    currentSearchIndex: currentSearchIndex ?? this.currentSearchIndex,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : (error ?? this.error),
    editingPath: clearEditingPath ? null : (editingPath ?? this.editingPath),
  );

  /// Creates an initial empty state.
  factory JsonTreeState.initial() => const JsonTreeState();

  @override
  List<Object?> get props => [
    rootNode,
    expandedPaths,
    selectedPath,
    hoveredPath,
    searchQuery,
    searchResults,
    currentSearchIndex,
    isLoading,
    error,
    editingPath,
  ];
}
