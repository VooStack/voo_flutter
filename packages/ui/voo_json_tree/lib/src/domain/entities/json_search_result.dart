import 'package:equatable/equatable.dart';

import 'package:voo_json_tree/src/domain/entities/json_node.dart';

/// Type of match in a search result.
enum JsonSearchMatchType {
  /// Match found in the key/property name.
  key,

  /// Match found in the value.
  value,

  /// Match found in both key and value.
  both,
}

/// Represents a search result in the JSON tree.
class JsonSearchResult extends Equatable {
  /// Creates a new [JsonSearchResult].
  const JsonSearchResult({
    required this.node,
    required this.matchType,
    required this.matchText,
    required this.matchStartIndex,
    required this.matchLength,
  });

  /// The node that contains the match.
  final JsonNode node;

  /// Whether the match was found in key, value, or both.
  final JsonSearchMatchType matchType;

  /// The text that matched the search query.
  final String matchText;

  /// The start index of the match in the matched text.
  final int matchStartIndex;

  /// The length of the match.
  final int matchLength;

  /// Returns the full path to this result.
  String get path => node.path;

  @override
  List<Object?> get props => [
        node.path,
        matchType,
        matchText,
        matchStartIndex,
        matchLength,
      ];
}
