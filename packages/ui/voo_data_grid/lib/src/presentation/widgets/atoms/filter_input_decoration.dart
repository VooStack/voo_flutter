import 'package:flutter/material.dart';

/// Provides consistent input decoration for all filter input fields
class FilterInputDecoration {
  /// Creates a standard input decoration for filter fields
  static InputDecoration standard({
    required BuildContext context,
    String? hintText,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    
    return InputDecoration(
      fillColor: theme.colorScheme.surfaceContainer,
      constraints: const BoxConstraints(maxHeight: 32),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: theme.primaryColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 12, color: theme.hintColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIcon != null 
          ? const BoxConstraints(maxWidth: 30, maxHeight: 32)
          : null,
    );
  }
}