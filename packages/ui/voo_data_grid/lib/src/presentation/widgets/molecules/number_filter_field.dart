import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A molecule component for number filter input
class NumberFilterField extends StatelessWidget {
  /// The current value
  final num? value;
  
  /// Callback when value changes
  final void Function(num?) onChanged;
  
  /// Hint text for the field
  final String? hintText;
  
  /// Label for the field
  final String? label;
  
  /// Whether to show clear button
  final bool showClearButton;
  
  /// Whether to allow decimals
  final bool allowDecimals;
  
  /// Text controller (optional, for external control)
  final TextEditingController? controller;
  
  const NumberFilterField({
    super.key,
    this.value,
    required this.onChanged,
    this.hintText,
    this.label,
    this.showClearButton = true,
    this.allowDecimals = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveController = controller ?? 
        TextEditingController(text: value?.toString() ?? '');
    final theme = Theme.of(context);
    
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: effectiveController,
        decoration: InputDecoration(
          hintText: hintText ?? 'Enter number...',
          hintStyle: TextStyle(fontSize: 12, color: theme.hintColor),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: InputBorder.none,
          suffixIcon: showClearButton && effectiveController.text.isNotEmpty
              ? InkWell(
                  onTap: () {
                    effectiveController.clear();
                    onChanged(null);
                  },
                  child: const Icon(Icons.clear, size: 16),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(maxWidth: 30, maxHeight: 32),
        ),
        style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
        keyboardType: TextInputType.numberWithOptions(
          decimal: allowDecimals,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            allowDecimals 
                ? RegExp(r'^\d*\.?\d*')
                : RegExp(r'^\d*'),
          ),
        ],
        onChanged: (value) {
          if (value.isEmpty) {
            onChanged(null);
          } else {
            final parsed = allowDecimals 
                ? double.tryParse(value)
                : int.tryParse(value);
            onChanged(parsed);
          }
        },
      ),
    );
  }
}