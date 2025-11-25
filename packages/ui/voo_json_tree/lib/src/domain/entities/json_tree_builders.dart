import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_node.dart';

/// Signature for building custom node widgets.
///
/// The [context] provides the build context.
/// The [node] is the JSON node being rendered.
/// The [defaultWidget] is the default widget that would be rendered.
///
/// Return [defaultWidget] to use the default rendering, or return a custom
/// widget to completely override the node's appearance.
///
/// ```dart
/// nodeBuilder: (context, node, defaultWidget) {
///   if (node.key == 'special') {
///     return Container(
///       color: Colors.amber,
///       child: defaultWidget,
///     );
///   }
///   return defaultWidget;
/// }
/// ```
typedef JsonNodeBuilder = Widget Function(
  BuildContext context,
  JsonNode node,
  Widget defaultWidget,
);

/// Signature for building custom key text widgets.
///
/// The [context] provides the build context.
/// The [node] is the JSON node whose key is being rendered.
/// The [defaultWidget] is the default key text widget.
///
/// ```dart
/// keyBuilder: (context, node, defaultWidget) {
///   if (node.key?.startsWith('_') == true) {
///     return Text(
///       node.key!,
///       style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
///     );
///   }
///   return defaultWidget;
/// }
/// ```
typedef JsonKeyBuilder = Widget Function(
  BuildContext context,
  JsonNode node,
  Widget defaultWidget,
);

/// Signature for building custom value widgets.
///
/// The [context] provides the build context.
/// The [node] is the JSON node whose value is being rendered.
/// The [defaultWidget] is the default value widget.
///
/// ```dart
/// valueBuilder: (context, node, defaultWidget) {
///   if (node.value is String && (node.value as String).startsWith('http')) {
///     return GestureDetector(
///       onTap: () => launchUrl(Uri.parse(node.value)),
///       child: Text(
///         node.value,
///         style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
///       ),
///     );
///   }
///   return defaultWidget;
/// }
/// ```
typedef JsonValueBuilder = Widget Function(
  BuildContext context,
  JsonNode node,
  Widget defaultWidget,
);

/// Signature for building custom expand/collapse icons.
///
/// The [context] provides the build context.
/// The [isExpanded] indicates the current expansion state.
/// The [defaultWidget] is the default expand icon widget.
///
/// ```dart
/// expandIconBuilder: (context, isExpanded, defaultWidget) {
///   return Icon(
///     isExpanded ? Icons.remove_circle : Icons.add_circle,
///     size: 16,
///   );
/// }
/// ```
typedef JsonExpandIconBuilder = Widget Function(
  BuildContext context,
  bool isExpanded,
  Widget defaultWidget,
);

/// Signature for formatting copied content.
///
/// The [node] is the JSON node being copied.
/// The [copyType] indicates what type of copy was requested.
///
/// Return the formatted string to copy to clipboard.
///
/// ```dart
/// copyFormatter: (node, copyType) {
///   if (copyType == CopyType.path) {
///     return 'data${node.path}'; // Add prefix to path
///   }
///   return null; // Use default formatting
/// }
/// ```
typedef JsonCopyFormatter = String? Function(
  JsonNode node,
  CopyType copyType,
);

/// Types of content that can be copied.
enum CopyType {
  /// Copy the JSON path (e.g., "root.users[0].name")
  path,

  /// Copy the node's key
  key,

  /// Copy the node's value
  value,

  /// Copy the node as JSON
  json,
}

/// Collection of builder callbacks for customizing tree rendering.
///
/// Use this class to pass multiple builders at once to VooJsonTree.
///
/// ```dart
/// VooJsonTree(
///   data: jsonData,
///   builders: JsonTreeBuilders(
///     nodeBuilder: myNodeBuilder,
///     valueBuilder: myValueBuilder,
///   ),
/// )
/// ```
class JsonTreeBuilders {
  /// Creates a new [JsonTreeBuilders] instance.
  const JsonTreeBuilders({
    this.nodeBuilder,
    this.keyBuilder,
    this.valueBuilder,
    this.expandIconBuilder,
    this.copyFormatter,
  });

  /// Custom builder for entire node rows.
  final JsonNodeBuilder? nodeBuilder;

  /// Custom builder for key text.
  final JsonKeyBuilder? keyBuilder;

  /// Custom builder for value widgets.
  final JsonValueBuilder? valueBuilder;

  /// Custom builder for expand/collapse icons.
  final JsonExpandIconBuilder? expandIconBuilder;

  /// Custom formatter for copied content.
  final JsonCopyFormatter? copyFormatter;

  /// Returns true if any builder is defined.
  bool get hasBuilders =>
      nodeBuilder != null ||
      keyBuilder != null ||
      valueBuilder != null ||
      expandIconBuilder != null ||
      copyFormatter != null;

  /// Creates a copy with the given fields replaced.
  JsonTreeBuilders copyWith({
    JsonNodeBuilder? nodeBuilder,
    JsonKeyBuilder? keyBuilder,
    JsonValueBuilder? valueBuilder,
    JsonExpandIconBuilder? expandIconBuilder,
    JsonCopyFormatter? copyFormatter,
  }) {
    return JsonTreeBuilders(
      nodeBuilder: nodeBuilder ?? this.nodeBuilder,
      keyBuilder: keyBuilder ?? this.keyBuilder,
      valueBuilder: valueBuilder ?? this.valueBuilder,
      expandIconBuilder: expandIconBuilder ?? this.expandIconBuilder,
      copyFormatter: copyFormatter ?? this.copyFormatter,
    );
  }
}
