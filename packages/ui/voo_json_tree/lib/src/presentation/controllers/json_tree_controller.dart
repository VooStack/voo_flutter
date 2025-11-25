import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:voo_json_tree/src/data/models/json_tree_state.dart';
import 'package:voo_json_tree/src/data/services/json_parser_service.dart';
import 'package:voo_json_tree/src/data/services/json_search_service.dart';
import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_search_result.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_config.dart';

/// Controller for managing JSON tree state.
///
/// Provides methods for expanding/collapsing nodes, searching,
/// selection, and editing.
class JsonTreeController extends ChangeNotifier {
  /// Creates a new [JsonTreeController].
  JsonTreeController({
    JsonTreeConfig? config,
  }) : _config = config ?? const JsonTreeConfig();

  final JsonTreeConfig _config;
  final JsonParserService _parserService = const JsonParserService();
  final JsonSearchService _searchService = const JsonSearchService();

  JsonTreeState _state = JsonTreeState.initial();
  Timer? _searchDebounceTimer;

  /// The current configuration.
  JsonTreeConfig get config => _config;

  /// The current state.
  JsonTreeState get state => _state;

  /// The root node of the tree.
  JsonNode? get rootNode => _state.rootNode;

  /// Whether the tree has data.
  bool get hasData => _state.rootNode != null;

  /// Whether the tree is loading.
  bool get isLoading => _state.isLoading;

  /// The current error message.
  String? get error => _state.error;

  /// The current search query.
  String get searchQuery => _state.searchQuery;

  /// The current search results.
  List<JsonSearchResult> get searchResults => _state.searchResults;

  /// The currently selected node path.
  String? get selectedPath => _state.selectedPath;

  /// The currently selected node.
  JsonNode? get selectedNode {
    if (_state.selectedPath == null || _state.rootNode == null) return null;
    return _findNodeByPath(_state.rootNode!, _state.selectedPath!);
  }

  // ===== Data Management =====

  /// Sets the JSON data from a dynamic value.
  void setData(dynamic data, {String rootName = 'root'}) {
    try {
      _state = _state.copyWith(isLoading: true, clearError: true);
      notifyListeners();

      final rootNode = _parserService.parse(data, rootName: rootName);
      final expandedPaths = _config.expandDepth < 0
          ? _parserService.getAllExpandablePaths(rootNode)
          : _parserService.getExpandedPathsToDepth(rootNode, _config.expandDepth);

      _state = _state.copyWith(
        rootNode: rootNode,
        expandedPaths: expandedPaths,
        isLoading: false,
        clearSelectedPath: true,
        clearEditingPath: true,
        searchQuery: '',
        searchResults: [],
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: 'Failed to parse JSON: $e',
      );
      notifyListeners();
    }
  }

  /// Sets the JSON data from a string.
  void setDataFromString(String jsonString, {String rootName = 'root'}) {
    try {
      final data = json.decode(jsonString);
      setData(data, rootName: rootName);
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: 'Invalid JSON string: $e',
      );
      notifyListeners();
    }
  }

  /// Clears all data.
  void clear() {
    _state = JsonTreeState.initial();
    notifyListeners();
  }

  // ===== Expansion Management =====

  /// Expands a node at the given path.
  void expandNode(String path) {
    if (!_state.expandedPaths.contains(path)) {
      final newPaths = Set<String>.from(_state.expandedPaths)..add(path);
      _state = _state.copyWith(expandedPaths: newPaths);
      notifyListeners();
    }
  }

  /// Collapses a node at the given path.
  void collapseNode(String path) {
    if (_state.expandedPaths.contains(path)) {
      final newPaths = Set<String>.from(_state.expandedPaths)..remove(path);
      _state = _state.copyWith(expandedPaths: newPaths);
      notifyListeners();
    }
  }

  /// Toggles the expansion state of a node.
  void toggleNode(String path) {
    if (_state.expandedPaths.contains(path)) {
      collapseNode(path);
    } else {
      expandNode(path);
    }
  }

  /// Returns true if a node is expanded.
  bool isExpanded(String path) => _state.isExpanded(path);

  /// Expands all nodes.
  void expandAll() {
    if (_state.rootNode == null) return;

    final allPaths = _parserService.getAllExpandablePaths(_state.rootNode!);
    _state = _state.copyWith(expandedPaths: allPaths);
    notifyListeners();
  }

  /// Collapses all nodes.
  void collapseAll() {
    _state = _state.copyWith(expandedPaths: {});
    notifyListeners();
  }

  /// Expands nodes to a certain depth.
  void expandToDepth(int depth) {
    if (_state.rootNode == null) return;

    final paths = _parserService.getExpandedPathsToDepth(_state.rootNode!, depth);
    _state = _state.copyWith(expandedPaths: paths);
    notifyListeners();
  }

  /// Expands all ancestors of a node to make it visible.
  void revealNode(String path) {
    final ancestors = _searchService.getAncestorPaths(path);
    final newPaths = Set<String>.from(_state.expandedPaths)..addAll(ancestors);
    _state = _state.copyWith(expandedPaths: newPaths);
    notifyListeners();
  }

  // ===== Selection Management =====

  /// Selects a node at the given path.
  void selectNode(String path) {
    _state = _state.copyWith(selectedPath: path);
    notifyListeners();
  }

  /// Clears the current selection.
  void clearSelection() {
    _state = _state.copyWith(clearSelectedPath: true);
    notifyListeners();
  }

  /// Returns true if a node is selected.
  bool isSelected(String path) => _state.isSelected(path);

  // ===== Hover Management =====

  /// Sets the hovered node path.
  void setHoveredPath(String? path) {
    if (_state.hoveredPath != path) {
      _state = path == null
          ? _state.copyWith(clearHoveredPath: true)
          : _state.copyWith(hoveredPath: path);
      notifyListeners();
    }
  }

  /// Returns true if a node is being hovered.
  bool isHovered(String path) => _state.isHovered(path);

  // ===== Search Management =====

  /// Performs a search with the given query.
  void search(String query) {
    _searchDebounceTimer?.cancel();

    if (query.isEmpty) {
      clearSearch();
      return;
    }

    _searchDebounceTimer = Timer(
      Duration(milliseconds: _config.searchDebounceMs),
      () => _performSearch(query),
    );
  }

  /// Performs the actual search.
  void _performSearch(String query) {
    if (_state.rootNode == null) return;

    final results = _searchService.search(_state.rootNode!, query);

    // Expand paths to show results
    if (results.isNotEmpty) {
      final pathsToExpand = _searchService.getPathsToExpand(results);
      final newPaths = Set<String>.from(_state.expandedPaths)..addAll(pathsToExpand);

      _state = _state.copyWith(
        searchQuery: query,
        searchResults: results,
        currentSearchIndex: 0,
        expandedPaths: newPaths,
      );
    } else {
      _state = _state.copyWith(
        searchQuery: query,
        searchResults: [],
        currentSearchIndex: 0,
      );
    }

    notifyListeners();
  }

  /// Clears the search.
  void clearSearch() {
    _searchDebounceTimer?.cancel();
    _state = _state.copyWith(
      searchQuery: '',
      searchResults: [],
      currentSearchIndex: 0,
    );
    notifyListeners();
  }

  /// Navigates to the next search result.
  void nextSearchResult() {
    if (_state.searchResults.isEmpty) return;

    final nextIndex = (_state.currentSearchIndex + 1) % _state.searchResults.length;
    _state = _state.copyWith(currentSearchIndex: nextIndex);

    // Reveal and select the result
    final result = _state.searchResults[nextIndex];
    revealNode(result.path);
    selectNode(result.path);

    notifyListeners();
  }

  /// Navigates to the previous search result.
  void previousSearchResult() {
    if (_state.searchResults.isEmpty) return;

    final prevIndex = _state.currentSearchIndex == 0
        ? _state.searchResults.length - 1
        : _state.currentSearchIndex - 1;
    _state = _state.copyWith(currentSearchIndex: prevIndex);

    // Reveal and select the result
    final result = _state.searchResults[prevIndex];
    revealNode(result.path);
    selectNode(result.path);

    notifyListeners();
  }

  /// Returns true if the given path matches the current search.
  bool isSearchMatch(String path) => _state.isSearchMatch(path);

  // ===== Editing Management =====

  /// Starts editing a node at the given path.
  void startEditing(String path) {
    if (!_config.enableEditing) return;
    _state = _state.copyWith(editingPath: path);
    notifyListeners();
  }

  /// Cancels the current edit.
  void cancelEditing() {
    _state = _state.copyWith(clearEditingPath: true);
    notifyListeners();
  }

  /// Returns true if a node is being edited.
  bool isEditing(String path) => _state.isEditing(path);

  // ===== Export =====

  /// Returns the current JSON as a string.
  String toJsonString({bool pretty = true}) {
    if (_state.rootNode == null) return '';

    final encoder = pretty
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();

    return encoder.convert(_state.rootNode!.value);
  }

  /// Returns the current JSON data.
  dynamic toJson() => _state.rootNode?.value;

  // ===== Flattening for Rendering =====

  /// Returns a flattened list of visible nodes for rendering.
  List<JsonNode> getVisibleNodes({bool includeRoot = true}) {
    if (_state.rootNode == null) return [];

    return _parserService.flatten(
      _state.rootNode!,
      expandedPaths: _state.expandedPaths,
      includeRoot: includeRoot,
    );
  }

  // ===== Helper Methods =====

  /// Finds a node by its path.
  JsonNode? _findNodeByPath(JsonNode root, String path) {
    if (root.path == path) return root;

    for (final child in root.children) {
      final found = _findNodeByPath(child, path);
      if (found != null) return found;
    }

    return null;
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}
