import 'package:flutter/material.dart';

import 'package:voo_terminal/src/domain/entities/terminal_theme.dart';

/// A dropdown widget for displaying command auto-complete suggestions.
///
/// Shows a list of matching commands as the user types.
class CommandSuggestion extends StatelessWidget {
  /// The theme to use for styling.
  final VooTerminalTheme theme;

  /// The list of suggestions to display.
  final List<String> suggestions;

  /// The currently selected index.
  final int selectedIndex;

  /// Callback when a suggestion is selected.
  final ValueChanged<String>? onSelect;

  /// Maximum number of visible suggestions.
  final int maxVisible;

  /// Creates a command suggestion widget.
  const CommandSuggestion({
    super.key,
    required this.theme,
    required this.suggestions,
    this.selectedIndex = 0,
    this.onSelect,
    this.maxVisible = 5,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxVisible * 32.0,
      ),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        border: Border.all(
          color: theme.borderColor,
          width: theme.borderWidth,
        ),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return _SuggestionItem(
            theme: theme,
            text: suggestions[index],
            isSelected: isSelected,
            onTap: () => onSelect?.call(suggestions[index]),
          );
        },
      ),
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  final VooTerminalTheme theme;
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const _SuggestionItem({
    required this.theme,
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        color: isSelected
            ? theme.selectionColor
            : Colors.transparent,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: theme.fontFamily,
            fontSize: theme.fontSize,
            color: isSelected ? theme.inputColor : theme.textColor,
          ),
        ),
      ),
    );
  }
}
