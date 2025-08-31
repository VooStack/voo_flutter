import 'package:flutter/material.dart';

/// A molecule component for text filter input
class TextFilterField extends StatelessWidget {
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
  
  const TextFilterField({
    super.key,
    this.value,
    required this.onChanged,
    this.hintText,
    this.label,
    this.showClearButton = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveController = controller ?? 
        TextEditingController(text: value ?? '');
    
    return TextField(
      controller: effectiveController,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText ?? 'Enter text...',
        border: const OutlineInputBorder(),
        suffixIcon: showClearButton && effectiveController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  effectiveController.clear();
                  onChanged(null);
                },
              )
            : null,
      ),
      onChanged: (value) {
        onChanged(value.isEmpty ? null : value);
      },
    );
  }
}