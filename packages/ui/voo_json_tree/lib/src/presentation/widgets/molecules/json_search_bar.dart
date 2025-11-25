import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';

/// A search bar for filtering JSON tree content.
class JsonSearchBar extends StatefulWidget {
  /// Creates a new [JsonSearchBar].
  const JsonSearchBar({
    super.key,
    required this.theme,
    this.onSearch,
    this.onClear,
    this.onNext,
    this.onPrevious,
    this.resultCount = 0,
    this.currentIndex = 0,
    this.hintText = 'Search...',
  });

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// Callback when search query changes.
  final ValueChanged<String>? onSearch;

  /// Callback when search is cleared.
  final VoidCallback? onClear;

  /// Callback to go to next result.
  final VoidCallback? onNext;

  /// Callback to go to previous result.
  final VoidCallback? onPrevious;

  /// Total number of search results.
  final int resultCount;

  /// Current result index (0-based).
  final int currentIndex;

  /// Placeholder text.
  final String hintText;

  @override
  State<JsonSearchBar> createState() => _JsonSearchBarState();
}

class _JsonSearchBarState extends State<JsonSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          widget.onPrevious?.call();
        } else {
          widget.onNext?.call();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        _handleClear();
      }
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _controller.text.isNotEmpty;
    final hasResults = widget.resultCount > 0;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: widget.theme.backgroundColor?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: widget.theme.indentGuideColor,
          ),
        ),
        child: Row(
          children: [
            // Search icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.search,
                size: 18,
                color: widget.theme.expandIconColor,
              ),
            ),

            // Text input
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  fontFamily: widget.theme.fontFamily,
                  fontSize: widget.theme.fontSize,
                  color: widget.theme.keyColor,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontFamily: widget.theme.fontFamily,
                    fontSize: widget.theme.fontSize,
                    color: widget.theme.nullColor,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: widget.onSearch,
              ),
            ),

            // Result count
            if (hasQuery && hasResults)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  '${widget.currentIndex + 1}/${widget.resultCount}',
                  style: TextStyle(
                    fontFamily: widget.theme.fontFamily,
                    fontSize: widget.theme.fontSize * 0.85,
                    color: widget.theme.nullColor,
                  ),
                ),
              ),

            // No results indicator
            if (hasQuery && !hasResults)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'No results',
                  style: TextStyle(
                    fontFamily: widget.theme.fontFamily,
                    fontSize: widget.theme.fontSize * 0.85,
                    color: widget.theme.nullColor,
                  ),
                ),
              ),

            // Navigation buttons
            if (hasQuery && hasResults) ...[
              _IconButton(
                icon: Icons.keyboard_arrow_up,
                onPressed: widget.onPrevious,
                color: widget.theme.expandIconColor,
                tooltip: 'Previous (Shift+Enter)',
              ),
              _IconButton(
                icon: Icons.keyboard_arrow_down,
                onPressed: widget.onNext,
                color: widget.theme.expandIconColor,
                tooltip: 'Next (Enter)',
              ),
            ],

            // Clear button
            if (hasQuery)
              _IconButton(
                icon: Icons.close,
                onPressed: _handleClear,
                color: widget.theme.expandIconColor,
                tooltip: 'Clear (Esc)',
              ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}
