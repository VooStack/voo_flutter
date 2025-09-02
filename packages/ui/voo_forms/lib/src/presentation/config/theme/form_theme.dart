import 'package:flutter/material.dart';

/// Provides Material 3 theming utilities for forms
/// Integrates with voo_ui_core design system
class VooFormTheme {
  VooFormTheme._();

  /// Generate form theme based on Material 3 design system
  /// Uses voo_ui_core design tokens for consistency
  static ThemeData generateFormTheme({
    required ColorScheme colorScheme,
    TextTheme? textTheme,
    double? borderRadius,
    EdgeInsetsGeometry? fieldPadding,
    EdgeInsetsGeometry? contentPadding,
  }) {
    // Use modern rounded corners for better visual appeal
    final radius = borderRadius ?? 12.0;
    // Generous padding for better touch targets and visual breathing room
    final content = contentPadding ?? const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 18.0,
    );

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: content,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.error.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: TextStyle(
          color: colorScheme.error,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
        helperStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
        prefixStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.0,
        ),
        suffixStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 16.0,
          ),
          elevation: 2,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 16.0,
          ),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 12.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.5),
          width: 2.0,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline.withValues(alpha: 0.5);
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) => 
          Colors.transparent,),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withValues(alpha: 0.2),
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.15),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
        trackHeight: 6.0,
        thumbShape: const RoundSliderThumbShape(
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 20.0,
        ),
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        deleteIconColor: colorScheme.onSurfaceVariant,
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius / 2),
        ),
      ),
    );
  }

  /// Get input decoration for specific field types
  static InputDecoration getFieldDecoration({
    required BuildContext context,
    String? label,
    String? hint,
    String? helper,
    String? error,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool isPassword = false,
    bool isDense = false,
    bool filled = true,
  }) => InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      errorText: error,
      filled: filled,
      isDense: isDense,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon != null
          ? IconButton(
              icon: Icon(suffixIcon),
              onPressed: onSuffixTap,
            )
          : isPassword
              ? IconButton(
                  icon: const Icon(Icons.visibility_outlined),
                  onPressed: onSuffixTap,
                )
              : null,
    );

  /// Get form section decoration
  static BoxDecoration getSectionDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16.0),
      border: Border.all(
        color: theme.colorScheme.outlineVariant,
      ),
    );
  }

  /// Get form card decoration
  static BoxDecoration getFormCardDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 10.0,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Get field group decoration
  static BoxDecoration getFieldGroupDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.3),
      ),
    );
  }
}