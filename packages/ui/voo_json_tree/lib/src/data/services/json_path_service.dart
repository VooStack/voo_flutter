/// Service for JSON path manipulation and clipboard operations.
class JsonPathService {
  /// Creates a new [JsonPathService].
  const JsonPathService();

  /// Formats a path for display (removes the root prefix if desired).
  String formatPath(String path, {bool includeRoot = false}) {
    if (includeRoot) return path;

    // Remove "root." prefix
    if (path.startsWith('root.')) {
      return path.substring(5);
    }
    if (path.startsWith('root[')) {
      return path.substring(4);
    }
    if (path == 'root') {
      return '';
    }

    return path;
  }

  /// Converts a path to JSONPath format (e.g., "$.users[0].name").
  String toJsonPath(String path) {
    var result = formatPath(path);
    if (result.isEmpty) return r'$';

    // Replace initial segment
    if (!result.startsWith('[')) {
      result = '.$result';
    }

    return '\$$result';
  }

  /// Converts a path to bracket notation (e.g., "['users'][0]['name']").
  String toBracketNotation(String path) {
    final formatted = formatPath(path);
    if (formatted.isEmpty) return '';

    final buffer = StringBuffer();
    final propertyBuffer = StringBuffer();

    for (var i = 0; i < formatted.length; i++) {
      final char = formatted[i];

      if (char == '.') {
        if (propertyBuffer.isNotEmpty) {
          buffer.write("['${propertyBuffer.toString()}']");
          propertyBuffer.clear();
        }
      } else if (char == '[') {
        if (propertyBuffer.isNotEmpty) {
          buffer.write("['${propertyBuffer.toString()}']");
          propertyBuffer.clear();
        }
        buffer.write('[');
      } else if (char == ']') {
        buffer.write(']');
      } else {
        propertyBuffer.write(char);
      }
    }

    if (propertyBuffer.isNotEmpty) {
      buffer.write("['${propertyBuffer.toString()}']");
    }

    return buffer.toString();
  }

  /// Formats a value for copying to clipboard.
  String formatValueForCopy(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return value;
    if (value is Map || value is List) {
      return _prettyPrintJson(value);
    }
    return value.toString();
  }

  /// Pretty prints JSON data.
  String _prettyPrintJson(dynamic data, {int indent = 0}) {
    const indentStr = '  ';
    final currentIndent = indentStr * indent;
    final nextIndent = indentStr * (indent + 1);

    if (data is Map) {
      if (data.isEmpty) return '{}';

      final entries = data.entries.map((e) {
        final key = '"${e.key}"';
        final value = _prettyPrintJson(e.value, indent: indent + 1);
        return '$nextIndent$key: $value';
      }).join(',\n');

      return '{\n$entries\n$currentIndent}';
    }

    if (data is List) {
      if (data.isEmpty) return '[]';

      final items = data.map((e) {
        final value = _prettyPrintJson(e, indent: indent + 1);
        return '$nextIndent$value';
      }).join(',\n');

      return '[\n$items\n$currentIndent]';
    }

    if (data is String) {
      // Escape special characters
      final escaped = data
          .replaceAll('\\', '\\\\')
          .replaceAll('"', '\\"')
          .replaceAll('\n', '\\n')
          .replaceAll('\r', '\\r')
          .replaceAll('\t', '\\t');
      return '"$escaped"';
    }

    if (data == null) return 'null';

    return data.toString();
  }

  /// Gets the parent path of a given path.
  String? getParentPath(String path) {
    final lastDot = path.lastIndexOf('.');
    final lastBracket = path.lastIndexOf('[');

    if (lastDot < 0 && lastBracket < 0) return null;

    final splitIndex = lastDot > lastBracket ? lastDot : lastBracket;
    return path.substring(0, splitIndex);
  }

  /// Gets the key/index from the last segment of a path.
  String getLastSegment(String path) {
    final lastDot = path.lastIndexOf('.');
    final lastBracket = path.lastIndexOf('[');

    if (lastDot < 0 && lastBracket < 0) return path;

    if (lastDot > lastBracket) {
      return path.substring(lastDot + 1);
    } else {
      return path.substring(lastBracket);
    }
  }
}
