import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

/// A syntax-highlighted JSON viewer widget
class JsonViewer extends StatefulWidget {
  final dynamic jsonData;
  final bool initiallyExpanded;
  final bool showCopyButton;
  final int maxLines;

  const JsonViewer({
    super.key,
    required this.jsonData,
    this.initiallyExpanded = true,
    this.showCopyButton = true,
    this.maxLines = 500,
  });

  @override
  State<JsonViewer> createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    final text = const JsonEncoder.withIndent('  ').convert(widget.jsonData);
    await Clipboard.setData(ClipboardData(text: text));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showCopyButton)
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: Icon(
                    _copied ? Icons.check : Icons.copy,
                    size: 16,
                  ),
                  label: Text(_copied ? 'Copied!' : 'Copy JSON'),
                  onPressed: _copyToClipboard,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: SelectableText.rich(
                _buildJsonTextSpan(widget.jsonData, theme),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextSpan _buildJsonTextSpan(dynamic data, ThemeData theme) {
    final children = <InlineSpan>[];
    _addJsonSpans(data, children, theme, 0);
    return TextSpan(children: children);
  }

  void _addJsonSpans(
    dynamic data,
    List<InlineSpan> spans,
    ThemeData theme,
    int indent,
  ) {
    final colors = _getJsonColors(theme);
    final indentStr = '  ' * indent;

    if (data == null) {
      spans.add(TextSpan(
        text: 'null',
        style: TextStyle(color: colors.nullColor),
      ));
    } else if (data is bool) {
      spans.add(TextSpan(
        text: data.toString(),
        style: TextStyle(color: colors.boolColor),
      ));
    } else if (data is num) {
      spans.add(TextSpan(
        text: data.toString(),
        style: TextStyle(color: colors.numberColor),
      ));
    } else if (data is String) {
      spans.add(TextSpan(
        text: '"${_escapeString(data)}"',
        style: TextStyle(color: colors.stringColor),
      ));
    } else if (data is List) {
      if (data.isEmpty) {
        spans.add(TextSpan(
          text: '[]',
          style: TextStyle(color: colors.bracketColor),
        ));
      } else {
        spans.add(TextSpan(
          text: '[\n',
          style: TextStyle(color: colors.bracketColor),
        ));
        for (var i = 0; i < data.length; i++) {
          spans.add(TextSpan(text: '$indentStr  '));
          _addJsonSpans(data[i], spans, theme, indent + 1);
          if (i < data.length - 1) {
            spans.add(TextSpan(
              text: ',',
              style: TextStyle(color: colors.punctuationColor),
            ));
          }
          spans.add(const TextSpan(text: '\n'));
        }
        spans.add(TextSpan(text: indentStr));
        spans.add(TextSpan(
          text: ']',
          style: TextStyle(color: colors.bracketColor),
        ));
      }
    } else if (data is Map) {
      if (data.isEmpty) {
        spans.add(TextSpan(
          text: '{}',
          style: TextStyle(color: colors.bracketColor),
        ));
      } else {
        spans.add(TextSpan(
          text: '{\n',
          style: TextStyle(color: colors.bracketColor),
        ));
        final entries = data.entries.toList();
        for (var i = 0; i < entries.length; i++) {
          final entry = entries[i];
          spans.add(TextSpan(text: '$indentStr  '));
          spans.add(TextSpan(
            text: '"${entry.key}"',
            style: TextStyle(color: colors.keyColor),
          ));
          spans.add(TextSpan(
            text: ': ',
            style: TextStyle(color: colors.punctuationColor),
          ));
          _addJsonSpans(entry.value, spans, theme, indent + 1);
          if (i < entries.length - 1) {
            spans.add(TextSpan(
              text: ',',
              style: TextStyle(color: colors.punctuationColor),
            ));
          }
          spans.add(const TextSpan(text: '\n'));
        }
        spans.add(TextSpan(text: indentStr));
        spans.add(TextSpan(
          text: '}',
          style: TextStyle(color: colors.bracketColor),
        ));
      }
    } else {
      // Fallback: convert to string
      spans.add(TextSpan(
        text: data.toString(),
        style: TextStyle(color: colors.stringColor),
      ));
    }
  }

  String _escapeString(String s) {
    return s
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  _JsonColors _getJsonColors(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return _JsonColors(
      keyColor: isDark ? const Color(0xFF9CDCFE) : const Color(0xFF0451A5),
      stringColor: isDark ? const Color(0xFFCE9178) : const Color(0xFFA31515),
      numberColor: isDark ? const Color(0xFFB5CEA8) : const Color(0xFF098658),
      boolColor: isDark ? const Color(0xFF569CD6) : const Color(0xFF0000FF),
      nullColor: isDark ? const Color(0xFF569CD6) : const Color(0xFF0000FF),
      bracketColor: isDark ? const Color(0xFFFFD700) : const Color(0xFF000000),
      punctuationColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    );
  }
}

class _JsonColors {
  final Color keyColor;
  final Color stringColor;
  final Color numberColor;
  final Color boolColor;
  final Color nullColor;
  final Color bracketColor;
  final Color punctuationColor;

  const _JsonColors({
    required this.keyColor,
    required this.stringColor,
    required this.numberColor,
    required this.boolColor,
    required this.nullColor,
    required this.bracketColor,
    required this.punctuationColor,
  });
}

/// A collapsible JSON node for tree view
class JsonTreeViewer extends StatelessWidget {
  final dynamic jsonData;
  final String? rootKey;
  final bool initiallyExpanded;

  const JsonTreeViewer({
    super.key,
    required this.jsonData,
    this.rootKey,
    this.initiallyExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _JsonNode(
        data: jsonData,
        nodeKey: rootKey,
        initiallyExpanded: initiallyExpanded,
      ),
    );
  }
}

class _JsonNode extends StatefulWidget {
  final dynamic data;
  final String? nodeKey;
  final bool initiallyExpanded;

  const _JsonNode({
    required this.data,
    this.nodeKey,
    this.initiallyExpanded = true,
  });

  @override
  State<_JsonNode> createState() => _JsonNodeState();
}

class _JsonNodeState extends State<_JsonNode>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (_isExpanded) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = widget.data;
    final colors = _getJsonColors(theme);

    if (data is Map || data is List) {
      final isMap = data is Map;
      final count = isMap ? data.length : (data as List).length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      Icons.arrow_right,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (widget.nodeKey != null) ...[
                    Text(
                      '"${widget.nodeKey}"',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: colors.keyColor,
                      ),
                    ),
                    Text(
                      ': ',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: colors.punctuationColor,
                      ),
                    ),
                  ],
                  Text(
                    isMap ? '{' : '[',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: colors.bracketColor,
                    ),
                  ),
                  if (!_isExpanded) ...[
                    Text(
                      '...$count items...',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      isMap ? '}' : ']',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: colors.bracketColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: isMap
                    ? [
                        for (final entry in data.entries)
                          _JsonNode(
                            data: entry.value,
                            nodeKey: entry.key.toString(),
                            initiallyExpanded: false,
                          ),
                      ]
                    : [
                        for (var i = 0; i < (data as List).length; i++)
                          _JsonNode(
                            data: data[i],
                            nodeKey: '[$i]',
                            initiallyExpanded: false,
                          ),
                      ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                isMap ? '}' : ']',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: colors.bracketColor,
                ),
              ),
            ),
          ],
        ],
      );
    }

    // Primitive value
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 16), // Align with expandable items
          if (widget.nodeKey != null) ...[
            Text(
              '"${widget.nodeKey}"',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: colors.keyColor,
              ),
            ),
            Text(
              ': ',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: colors.punctuationColor,
              ),
            ),
          ],
          _buildValueWidget(data, colors),
        ],
      ),
    );
  }

  Widget _buildValueWidget(dynamic value, _JsonColors colors) {
    if (value == null) {
      return Text(
        'null',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: colors.nullColor,
        ),
      );
    } else if (value is bool) {
      return Text(
        value.toString(),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: colors.boolColor,
        ),
      );
    } else if (value is num) {
      return Text(
        value.toString(),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: colors.numberColor,
        ),
      );
    } else if (value is String) {
      return Text(
        '"$value"',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: colors.stringColor,
        ),
      );
    } else {
      return Text(
        value.toString(),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: colors.stringColor,
        ),
      );
    }
  }

  _JsonColors _getJsonColors(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return _JsonColors(
      keyColor: isDark ? const Color(0xFF9CDCFE) : const Color(0xFF0451A5),
      stringColor: isDark ? const Color(0xFFCE9178) : const Color(0xFFA31515),
      numberColor: isDark ? const Color(0xFFB5CEA8) : const Color(0xFF098658),
      boolColor: isDark ? const Color(0xFF569CD6) : const Color(0xFF0000FF),
      nullColor: isDark ? const Color(0xFF569CD6) : const Color(0xFF0000FF),
      bracketColor: isDark ? const Color(0xFFFFD700) : const Color(0xFF000000),
      punctuationColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    );
  }
}
