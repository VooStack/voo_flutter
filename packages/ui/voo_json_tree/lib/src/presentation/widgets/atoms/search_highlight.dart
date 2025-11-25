import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';

/// A widget that highlights matching text in a search.
class SearchHighlight extends StatelessWidget {
  /// Creates a new [SearchHighlight].
  const SearchHighlight({
    super.key,
    required this.text,
    required this.query,
    required this.theme,
    this.textColor,
    this.caseSensitive = false,
  });

  /// The full text to display.
  final String text;

  /// The search query to highlight.
  final String query;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// The color for non-highlighted text.
  final Color? textColor;

  /// Whether the search is case sensitive.
  final bool caseSensitive;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: theme.fontSize,
          color: textColor,
        ),
      );
    }

    final searchText = caseSensitive ? text : text.toLowerCase();
    final searchQuery = caseSensitive ? query : query.toLowerCase();

    final spans = <TextSpan>[];
    var currentIndex = 0;

    while (currentIndex < text.length) {
      final matchIndex = searchText.indexOf(searchQuery, currentIndex);

      if (matchIndex < 0) {
        // No more matches, add the rest of the text
        spans.add(TextSpan(
          text: text.substring(currentIndex),
          style: TextStyle(
            fontFamily: theme.fontFamily,
            fontSize: theme.fontSize,
            color: textColor,
          ),
        ));
        break;
      }

      // Add text before match
      if (matchIndex > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, matchIndex),
          style: TextStyle(
            fontFamily: theme.fontFamily,
            fontSize: theme.fontSize,
            color: textColor,
          ),
        ));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(matchIndex, matchIndex + query.length),
        style: TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: theme.fontSize,
          fontWeight: FontWeight.bold,
          color: theme.searchMatchTextColor,
          backgroundColor: theme.searchMatchColor,
        ),
      ));

      currentIndex = matchIndex + query.length;
    }

    return Text.rich(TextSpan(children: spans));
  }
}
