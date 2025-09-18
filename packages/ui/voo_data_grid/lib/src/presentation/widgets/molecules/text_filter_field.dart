import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/utils/debouncer.dart';

/// A molecule component for text filter input
class TextFilterField extends StatefulWidget {
  /// The current value
  final String? value;
  
  /// Callback when value changes
  final void Function(String?) onChanged;
  
  /// Hint text for the field
  final String? hintText;
  
  /// Label for the field
  final String? label;
  
  /// Whether to show clear button
  final bool showClearButton;
  
  /// Text controller (optional, for external control)
  final TextEditingController? controller;
  
  /// Whether to use debouncing for input changes
  final bool useDebouncing;
  
  /// Debounce duration in milliseconds
  final Duration debounceDuration;
  
  const TextFilterField({
    super.key,
    this.value,
    required this.onChanged,
    this.hintText,
    this.label,
    this.showClearButton = true,
    this.controller,
    this.useDebouncing = true,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<TextFilterField> createState() => _TextFilterFieldState();
}

class _TextFilterFieldState extends State<TextFilterField> {
  late TextEditingController _effectiveController;
  late Debouncer _debouncer;
  bool _isControllerInternal = false;
  
  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(duration: widget.debounceDuration);
    if (widget.controller == null) {
      _effectiveController = TextEditingController(text: widget.value ?? '');
      _isControllerInternal = true;
    } else {
      _effectiveController = widget.controller!;
    }
  }
  
  @override
  void dispose() {
    _debouncer.dispose();
    if (_isControllerInternal) {
      _effectiveController.dispose();
    }
    super.dispose();
  }
  
  void _handleChange(String value) {
    final valueToEmit = value.isEmpty ? null : value;
    
    if (widget.useDebouncing) {
      _debouncer.run(() {
        widget.onChanged(valueToEmit);
      });
    } else {
      widget.onChanged(valueToEmit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: _effectiveController,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Enter text...',
          hintStyle: TextStyle(fontSize: 12, color: theme.hintColor),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: InputBorder.none,
          suffixIcon: widget.showClearButton && _effectiveController.text.isNotEmpty
              ? InkWell(
                  onTap: () {
                    _effectiveController.clear();
                    widget.onChanged(null);
                  },
                  child: const Icon(Icons.clear, size: 16),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(maxWidth: 30, maxHeight: 32),
        ),
        style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
        onChanged: _handleChange,
      ),
    );
  }
}