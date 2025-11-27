import 'dart:convert';

import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_node_type.dart';

/// Service for parsing JSON data into a tree structure.
class JsonParserService {
  /// Creates a new [JsonParserService].
  const JsonParserService();

  /// Parses a JSON string into a tree of [JsonNode]s.
  ///
  /// Throws [FormatException] if the string is not valid JSON.
  JsonNode parseString(String jsonString, {String rootName = 'root'}) {
    final dynamic data = json.decode(jsonString);
    return parse(data, rootName: rootName);
  }

  /// Parses a dynamic value (Map, List, or primitive) into a tree of [JsonNode]s.
  JsonNode parse(dynamic data, {String rootName = 'root'}) => _parseValue(data, rootName, rootName, 0, null);

  /// Recursively parses a value into a [JsonNode].
  JsonNode _parseValue(dynamic value, String key, String path, int depth, int? index) {
    if (value == null) {
      return JsonNode(key: key, value: null, type: JsonNodeType.nullValue, path: path, depth: depth, index: index);
    }

    if (value is Map<String, dynamic>) {
      return _parseObject(value, key, path, depth, index);
    }

    if (value is Map) {
      // Convert to Map<String, dynamic>
      final converted = value.map((k, v) => MapEntry(k.toString(), v));
      return _parseObject(converted, key, path, depth, index);
    }

    if (value is List) {
      return _parseArray(value, key, path, depth, index);
    }

    if (value is String) {
      return JsonNode(key: key, value: value, type: JsonNodeType.string, path: path, depth: depth, index: index);
    }

    if (value is num) {
      return JsonNode(key: key, value: value, type: JsonNodeType.number, path: path, depth: depth, index: index);
    }

    if (value is bool) {
      return JsonNode(key: key, value: value, type: JsonNodeType.boolean, path: path, depth: depth, index: index);
    }

    // Fallback: treat as string
    return JsonNode(key: key, value: value.toString(), type: JsonNodeType.string, path: path, depth: depth, index: index);
  }

  /// Parses a Map into an object [JsonNode] with children.
  JsonNode _parseObject(Map<String, dynamic> map, String key, String path, int depth, int? index) {
    final children = <JsonNode>[];

    for (final entry in map.entries) {
      final childPath = '$path.${entry.key}';
      final childNode = _parseValue(entry.value, entry.key, childPath, depth + 1, null);
      children.add(childNode);
    }

    return JsonNode(key: key, value: map, type: JsonNodeType.object, path: path, children: children, depth: depth, index: index);
  }

  /// Parses a List into an array [JsonNode] with children.
  JsonNode _parseArray(List<dynamic> list, String key, String path, int depth, int? index) {
    final children = <JsonNode>[];

    for (var i = 0; i < list.length; i++) {
      final childPath = '$path[$i]';
      final childNode = _parseValue(list[i], '[$i]', childPath, depth + 1, i);
      children.add(childNode);
    }

    return JsonNode(key: key, value: list, type: JsonNodeType.array, path: path, children: children, depth: depth, index: index);
  }

  /// Flattens a tree into a list of all nodes (for virtualized rendering).
  List<JsonNode> flatten(JsonNode root, {required Set<String> expandedPaths, bool includeRoot = true}) {
    final result = <JsonNode>[];

    void traverse(JsonNode node, bool shouldInclude) {
      if (shouldInclude) {
        result.add(node);
      }

      if (node.isExpandable && expandedPaths.contains(node.path)) {
        for (final child in node.children) {
          traverse(child, true);
        }
      }
    }

    traverse(root, includeRoot);
    return result;
  }

  /// Gets all paths that should be expanded to a certain depth.
  Set<String> getExpandedPathsToDepth(JsonNode root, int depth) {
    final result = <String>{};

    void traverse(JsonNode node) {
      if (node.depth < depth && node.isExpandable) {
        result.add(node.path);
        for (final child in node.children) {
          traverse(child);
        }
      }
    }

    traverse(root);
    return result;
  }

  /// Gets all expandable paths in the tree.
  Set<String> getAllExpandablePaths(JsonNode root) {
    final result = <String>{};

    void traverse(JsonNode node) {
      if (node.isExpandable) {
        result.add(node.path);
        for (final child in node.children) {
          traverse(child);
        }
      }
    }

    traverse(root);
    return result;
  }
}
