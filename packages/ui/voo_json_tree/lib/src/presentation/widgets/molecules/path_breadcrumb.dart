import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';

/// A breadcrumb navigation widget for displaying JSON paths.
class PathBreadcrumb extends StatelessWidget {
  /// Creates a new [PathBreadcrumb].
  const PathBreadcrumb({
    super.key,
    required this.path,
    required this.theme,
    this.onSegmentTap,
    this.showCopyButton = true,
    this.onCopy,
  });

  /// The full JSON path to display.
  final String path;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// Callback when a path segment is tapped.
  final void Function(String path)? onSegmentTap;

  /// Whether to show a copy button.
  final bool showCopyButton;

  /// Callback when the path is copied.
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final segments = _parseSegments(path);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.backgroundColor?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Path icon
          Icon(
            Icons.route,
            size: 14,
            color: theme.nullColor,
          ),
          const SizedBox(width: 8),

          // Segments
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _buildSegments(segments),
              ),
            ),
          ),

          // Copy button
          if (showCopyButton) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: onCopy,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  Icons.copy,
                  size: 14,
                  color: theme.expandIconColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<_PathSegment> _parseSegments(String path) {
    final segments = <_PathSegment>[];
    final buffer = StringBuffer();
    var currentPath = '';
    var inBracket = false;

    for (var i = 0; i < path.length; i++) {
      final char = path[i];

      if (char == '[') {
        if (buffer.isNotEmpty) {
          currentPath = currentPath.isEmpty
              ? buffer.toString()
              : '$currentPath.${buffer.toString()}';
          segments.add(_PathSegment(
            text: buffer.toString(),
            fullPath: currentPath,
            isIndex: false,
          ));
          buffer.clear();
        }
        inBracket = true;
      } else if (char == ']') {
        if (buffer.isNotEmpty) {
          currentPath = '$currentPath[${buffer.toString()}]';
          segments.add(_PathSegment(
            text: '[${buffer.toString()}]',
            fullPath: currentPath,
            isIndex: true,
          ));
          buffer.clear();
        }
        inBracket = false;
      } else if (char == '.' && !inBracket) {
        if (buffer.isNotEmpty) {
          currentPath = currentPath.isEmpty
              ? buffer.toString()
              : '$currentPath.${buffer.toString()}';
          segments.add(_PathSegment(
            text: buffer.toString(),
            fullPath: currentPath,
            isIndex: false,
          ));
          buffer.clear();
        }
      } else {
        buffer.write(char);
      }
    }

    if (buffer.isNotEmpty) {
      currentPath = currentPath.isEmpty
          ? buffer.toString()
          : '$currentPath.${buffer.toString()}';
      segments.add(_PathSegment(
        text: buffer.toString(),
        fullPath: currentPath,
        isIndex: false,
      ));
    }

    return segments;
  }

  List<Widget> _buildSegments(List<_PathSegment> segments) {
    final widgets = <Widget>[];

    for (var i = 0; i < segments.length; i++) {
      final segment = segments[i];

      // Add separator (except for first segment and array indices)
      if (i > 0 && !segment.isIndex) {
        widgets.add(Text(
          '.',
          style: TextStyle(
            fontFamily: theme.fontFamily,
            fontSize: theme.fontSize * 0.9,
            color: theme.nullColor,
          ),
        ));
      }

      // Add segment
      widgets.add(
        InkWell(
          onTap: onSegmentTap != null
              ? () => onSegmentTap!(segment.fullPath)
              : null,
          borderRadius: BorderRadius.circular(2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              segment.text,
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: theme.fontSize * 0.9,
                color: segment.isIndex ? theme.numberColor : theme.keyColor,
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}

class _PathSegment {
  const _PathSegment({
    required this.text,
    required this.fullPath,
    required this.isIndex,
  });

  final String text;
  final String fullPath;
  final bool isIndex;
}
