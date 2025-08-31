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
    
    return TextField(
      controller: effectiveController,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText ?? 'Enter number...',
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
    );
  }
}