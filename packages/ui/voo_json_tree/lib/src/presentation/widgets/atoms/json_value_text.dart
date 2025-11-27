import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_node_type.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';

/// A styled text widget for displaying JSON values.
class JsonValueText extends StatelessWidget {
  /// Creates a new [JsonValueText].
  const JsonValueText({
    super.key,
    required this.value,
    required this.type,
    required this.theme,
    this.maxLength,
    this.searchHighlight,
    this.highlightStart = 0,
    this.highlightLength = 0,
  });

  /// The value to display.
  final dynamic value;

  /// The type of the value.
  final JsonNodeType type;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// Maximum length before truncating (null for no limit).
  final int? maxLength;

  /// The search query to highlight.
  final String? searchHighlight;

  /// Start index of the highlight.
  final int highlightStart;

  /// Length of the highlight.
  final int highlightLength;

  @override
  Widget build(BuildContext context) {
    final displayText = _formatValue();
    final hasHighlight = searchHighlight != null && highlightLength > 0;

    if (!hasHighlight) {
      return Text(
        displayText,
        style: TextStyle(fontFamily: theme.fontFamily, fontSize: theme.fontSize, color: _getColor()),
      );
    }

    // Calculate highlight positions
    final adjustedStart = type == JsonNodeType.string ? highlightStart + 1 : highlightStart;
    final adjustedEnd = adjustedStart + highlightLength;

    return Text.rich(
      TextSpan(
        children: [
          if (adjustedStart > 0)
            TextSpan(
              text: displayText.substring(0, adjustedStart.clamp(0, displayText.length)),
              style: TextStyle(fontFamily: theme.fontFamily, fontSize: theme.fontSize, color: _getColor()),
            ),
          TextSpan(
            text: displayText.substring(adjustedStart.clamp(0, displayText.length), adjustedEnd.clamp(0, displayText.length)),
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
              style: TextStyle(fontFamily: theme.fontFamily, fontSize: theme.fontSize, color: _getColor()),
            ),
        ],
      ),
    );
  }

  String _formatValue() {
    switch (type) {
      case JsonNodeType.string:
        var str = value.toString();
        if (maxLength != null && str.length > maxLength!) {
          str = '${str.substring(0, maxLength)}...';
        }
        return '"$str"';
      case JsonNodeType.number:
        return value.toString();
      case JsonNodeType.boolean:
        return value.toString();
      case JsonNodeType.nullValue:
        return 'null';
      case JsonNodeType.object:
      case JsonNodeType.array:
        return '';
    }
  }

  Color _getColor() {
    switch (type) {
      case JsonNodeType.string:
        return theme.stringColor;
      case JsonNodeType.number:
        return theme.numberColor;
      case JsonNodeType.boolean:
        return theme.booleanColor;
      case JsonNodeType.nullValue:
        return theme.nullColor;
      case JsonNodeType.object:
      case JsonNodeType.array:
        return theme.bracketColor;
    }
  }
}
