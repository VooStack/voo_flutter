/// Utility class for working with JSON paths.
///
/// JSON paths follow the format: "root.property.nestedProperty[0].item"
class JsonPath {
  /// Creates a new [JsonPath] from a path string.
  JsonPath(this.path);

  /// Creates an empty root path.
  factory JsonPath.root([String rootName = 'root']) {
    return JsonPath(rootName);
  }

  /// The full path string.
  final String path;

  /// Returns the individual segments of the path.
  List<String> get segments {
    if (path.isEmpty) return [];

    final result = <String>[];
    final buffer = StringBuffer();
    var inBracket = false;

    for (var i = 0; i < path.length; i++) {
      final char = path[i];

      if (char == '[') {
        if (buffer.isNotEmpty) {
          result.add(buffer.toString());
          buffer.clear();
        }
        inBracket = true;
      } else if (char == ']') {
        if (buffer.isNotEmpty) {
          result.add('[${buffer.toString()}]');
          buffer.clear();
        }
        inBracket = false;
      } else if (char == '.' && !inBracket) {
        if (buffer.isNotEmpty) {
          result.add(buffer.toString());
          buffer.clear();
        }
      } else {
        buffer.write(char);
      }
    }

    if (buffer.isNotEmpty) {
      result.add(buffer.toString());
    }

    return result;
  }

  /// Returns the depth of this path (number of segments - 1 for root).
  int get depth => segments.length - 1;

  /// Returns the parent path.
  JsonPath? get parent {
    final segs = segments;
    if (segs.length <= 1) return null;

    final parentSegs = segs.sublist(0, segs.length - 1);
    return JsonPath(_segmentsToPath(parentSegs));
  }

  /// Returns the last segment (key or index).
  String? get lastSegment {
    final segs = segments;
    return segs.isEmpty ? null : segs.last;
  }

  /// Returns true if this path is an ancestor of [other].
  bool isAncestorOf(JsonPath other) {
    return other.path.startsWith('$path.') || other.path.startsWith('$path[');
  }

  /// Returns true if this path is a descendant of [other].
  bool isDescendantOf(JsonPath other) {
    return other.isAncestorOf(this);
  }

  /// Creates a child path with the given key.
  JsonPath child(String key) {
    return JsonPath('$path.$key');
  }

  /// Creates a child path with the given array index.
  JsonPath index(int index) {
    return JsonPath('$path[$index]');
  }

  /// Converts segments back to a path string.
  String _segmentsToPath(List<String> segs) {
    final buffer = StringBuffer();

    for (var i = 0; i < segs.length; i++) {
      final seg = segs[i];
      if (seg.startsWith('[')) {
        buffer.write(seg);
      } else {
        if (i > 0 && !segs[i - 1].startsWith('[')) {
          buffer.write('.');
        } else if (i > 0) {
          buffer.write('.');
        }
        buffer.write(seg);
      }
    }

    return buffer.toString();
  }

  @override
  String toString() => path;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is JsonPath && path == other.path;

  @override
  int get hashCode => path.hashCode;
}
