/// Represents the type of a JSON node.
enum JsonNodeType {
  /// A JSON object (key-value pairs enclosed in {})
  object,

  /// A JSON array (ordered list enclosed in [])
  array,

  /// A JSON string value
  string,

  /// A JSON number value (int or double)
  number,

  /// A JSON boolean value (true or false)
  boolean,

  /// A JSON null value
  nullValue,
}

/// Extension methods for [JsonNodeType].
extension JsonNodeTypeExtension on JsonNodeType {
  /// Returns true if this type can contain children (object or array).
  bool get isContainer => this == JsonNodeType.object || this == JsonNodeType.array;

  /// Returns true if this type is a primitive value.
  bool get isPrimitive => !isContainer;

  /// Returns the opening bracket for container types.
  String get openingBracket {
    switch (this) {
      case JsonNodeType.object:
        return '{';
      case JsonNodeType.array:
        return '[';
      default:
        return '';
    }
  }

  /// Returns the closing bracket for container types.
  String get closingBracket {
    switch (this) {
      case JsonNodeType.object:
        return '}';
      case JsonNodeType.array:
        return ']';
      default:
        return '';
    }
  }

  /// Returns a display name for the type.
  String get displayName {
    switch (this) {
      case JsonNodeType.object:
        return 'Object';
      case JsonNodeType.array:
        return 'Array';
      case JsonNodeType.string:
        return 'String';
      case JsonNodeType.number:
        return 'Number';
      case JsonNodeType.boolean:
        return 'Boolean';
      case JsonNodeType.nullValue:
        return 'Null';
    }
  }
}
