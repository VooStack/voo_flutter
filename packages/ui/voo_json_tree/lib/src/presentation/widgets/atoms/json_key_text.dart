import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';

/// A styled text widget for displaying JSON keys.
class JsonKeyText extends StatelessWidget {
  /// Creates a new [JsonKeyText].
  const JsonKeyText({
    super.key,
    required this.text,
    required this.theme,
    this.showQuotes = true,
    this.searchHighlight,
    this.highlightStart = 0,
    this.highlightLength = 0,
  });

  /// The key text to display.
  final String text;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// Whether to show quotes around the key.
  final bool showQuotes;

  /// The search query to highlight.
  final String? searchHighlight;

  /// Start index of the highlight.
  final int highlightStart;

  /// Length of the highlight.
  final int highlightLength;

  @override
  Widget build(BuildContext context) {
    final hasHighlight = searchHighlight != null && highlightLength > 0;

    if (!hasHighlight) {
      return Text(
        showQuotes ? '"$text"' : text,
        style: TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: theme.fontSize,
          fontWeight: theme.keyFontWeight,
          color: theme.keyColor,
        ),
      );
    }

    // Build highlighted text
    final displayText = showQuotes ? '"$text"' : text;
    final adjustedStart = showQuotes ? highlightStart + 1 : highlightStart;
    final adjustedEnd = adjustedStart + highlightLength;

    return Text.rich(
      TextSpan(
        children: [
          if (adjustedStart > 0)
            TextSpan(
              text: displayText.substring(0, adjustedStart),
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: theme.fontSize,
                fontWeight: theme.keyFontWeight,
                color: theme.keyColor,
              ),
            ),
          TextSpan(
            text: displayText.substring(
              adjustedStart,
              adjustedEnd.clamp(0, displayText.length),
            ),
            style: TextStyle(
              fontFamily: theme.fontFamily,
              fontSize: theme.fontSize,
              fontWeight: FontWeight.bold,
              color: theme.searchMatchTextColor,
              backgroundColor: theme.searchMatchColor,
            ),
          ),
          if (adjustedEnd < displayText.length)
            TextSpan(
              text: displayText.substring(adjustedEnd),
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: theme.fontSize,
                fontWeight: theme.keyFontWeight,
                color: theme.keyColor,
              ),
            ),
        ],
      ),
    );
  }
}
