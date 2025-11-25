import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_node_type.dart';
import 'package:voo_json_tree/src/domain/entities/json_search_result.dart';

/// Service for searching through a JSON tree.
class JsonSearchService {
  /// Creates a new [JsonSearchService].
  const JsonSearchService();

  /// Searches for [query] in the JSON tree rooted at [root].
  ///
  /// Returns a list of [JsonSearchResult]s containing all matches.
  /// Set [caseSensitive] to true for case-sensitive matching.
  List<JsonSearchResult> search(
    JsonNode root,
    String query, {
    bool caseSensitive = false,
    bool searchKeys = true,
    bool searchValues = true,
  }) {
    if (query.isEmpty) return [];

    final results = <JsonSearchResult>[];
    final searchQuery = caseSensitive ? query : query.toLowerCase();

    void traverse(JsonNode node) {
      bool keyMatch = false;
      bool valueMatch = false;
      int keyMatchStart = -1;
      int valueMatchStart = -1;

      // Search in key
      if (searchKeys && node.key.isNotEmpty) {
        final keyText = caseSensitive ? node.key : node.key.toLowerCase();
        keyMatchStart = keyText.indexOf(searchQuery);
        keyMatch = keyMatchStart >= 0;
      }

      // Search in value (only for primitives)
      if (searchValues && node.type.isPrimitive) {
        final valueText = caseSensitive
            ? node.rawDisplayValue
            : node.rawDisplayValue.toLowerCase();
        valueMatchStart = valueText.indexOf(searchQuery);
        valueMatch = valueMatchStart >= 0;
      }

      // Add result if there's a match
      if (keyMatch || valueMatch) {
        JsonSearchMatchType matchType;
        String matchText;
        int matchStart;

        if (keyMatch && valueMatch) {
          matchType = JsonSearchMatchType.both;
          matchText = node.key;
          matchStart = keyMatchStart;
        } else if (keyMatch) {
          matchType = JsonSearchMatchType.key;
          matchText = node.key;
          matchStart = keyMatchStart;
        } else {
          matchType = JsonSearchMatchType.value;
          matchText = node.rawDisplayValue;
          matchStart = valueMatchStart;
        }

        results.add(JsonSearchResult(
          node: node,
          matchType: matchType,
          matchText: matchText,
          matchStartIndex: matchStart,
          matchLength: query.length,
        ));
      }

      // Recurse into children
      for (final child in node.children) {
        traverse(child);
      }
    }

    traverse(root);
    return results;
  }

  /// Returns all paths that need to be expanded to show search results.
  Set<String> getPathsToExpand(List<JsonSearchResult> results) {
    final paths = <String>{};

    for (final result in results) {
      final segments = result.path.split(RegExp(r'[.\[]'));
      var currentPath = '';

      for (var i = 0; i < segments.length - 1; i++) {
        final segment = segments[i];
        if (segment.isEmpty) continue;

        if (segment.endsWith(']')) {
          currentPath += '[$segment';
        } else if (currentPath.isEmpty) {
          currentPath = segment;
        } else {
          currentPath += '.$segment';
        }

        paths.add(currentPath);
      }
    }

    return paths;
  }

  /// Gets paths to all ancestor nodes for a given path.
  Set<String> getAncestorPaths(String path) {
    final paths = <String>{};
    var current = path;

    while (true) {
      final lastDot = current.lastIndexOf('.');
      final lastBracket = current.lastIndexOf('[');
      final splitIndex = lastDot > lastBracket ? lastDot : lastBracket;

      if (splitIndex <= 0) break;

      current = current.substring(0, splitIndex);
      paths.add(current);
    }

    return paths;
  }
}
