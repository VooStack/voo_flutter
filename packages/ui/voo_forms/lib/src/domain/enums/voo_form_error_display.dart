import 'package:flutter/material.dart';

/// Enum defining when and how to display form validation errors
enum VooFormErrorDisplay {
  /// Never show errors automatically
  never,

  /// Show errors immediately as user types
  onType,

  /// Show errors when field loses focus
  onBlur,

  /// Show errors only after form submission attempt
  onSubmit,

  /// Show errors after first interaction (type or blur)
  onInteraction,

  /// Show errors after a delay while typing
  onTypeDebounced,

  /// Always show errors if they exist
  always,
}

/// Extension methods for VooFormErrorDisplay
extension VooFormErrorDisplayExtension on VooFormErrorDisplay {
  /// Get the display name for the error mode
  String get displayName {
    switch (this) {
      case VooFormErrorDisplay.never:
        return 'Never';
      case VooFormErrorDisplay.onType:
        return 'While Typing';
      case VooFormErrorDisplay.onBlur:
        return 'On Focus Lost';
      case VooFormErrorDisplay.onSubmit:
        return 'On Submit';
      case VooFormErrorDisplay.onInteraction:
        return 'After Interaction';
      case VooFormErrorDisplay.onTypeDebounced:
        return 'While Typing (Debounced)';
      case VooFormErrorDisplay.always:
        return 'Always';
    }
  }

  /// Get the description for the error mode
  String get description {
    switch (this) {
      case VooFormErrorDisplay.never:
        return 'Errors are never shown automatically';
      case VooFormErrorDisplay.onType:
        return 'Errors appear immediately as you type';
      case VooFormErrorDisplay.onBlur:
        return 'Errors appear when field loses focus';
      case VooFormErrorDisplay.onSubmit:
        return 'Errors appear only after form submission';
      case VooFormErrorDisplay.onInteraction:
        return 'Errors appear after first interaction';
      case VooFormErrorDisplay.onTypeDebounced:
        return 'Errors appear after you stop typing';
      case VooFormErrorDisplay.always:
        return 'Errors are always visible if present';
    }
  }

  /// Check if errors should be shown based on field state
  bool shouldShowError({
    required bool hasError,
    required bool hasBeenTouched,
    required bool hasBeenFocused,
    required bool isCurrentlyFocused,
    required bool hasBeenSubmitted,
    required bool isTyping,
    DateTime? lastTypeTime,
  }) {
    if (!hasError) return false;

    switch (this) {
      case VooFormErrorDisplay.never:
        return false;

      case VooFormErrorDisplay.onType:
        return hasBeenTouched;

      case VooFormErrorDisplay.onBlur:
        return hasBeenFocused && !isCurrentlyFocused;

      case VooFormErrorDisplay.onSubmit:
        return hasBeenSubmitted;

      case VooFormErrorDisplay.onInteraction:
        return hasBeenTouched || (hasBeenFocused && !isCurrentlyFocused);

      case VooFormErrorDisplay.onTypeDebounced:
        if (!hasBeenTouched) return false;
        if (lastTypeTime == null) return true;
        // Show error after 1 second of no typing
        return DateTime.now().difference(lastTypeTime).inMilliseconds > 1000;

      case VooFormErrorDisplay.always:
        return true;
    }
  }

  /// Get the appropriate AutovalidateMode for this error display mode
  AutovalidateMode get autovalidateMode {
    switch (this) {
      case VooFormErrorDisplay.never:
        return AutovalidateMode.disabled;
      case VooFormErrorDisplay.onType:
      case VooFormErrorDisplay.onTypeDebounced:
      case VooFormErrorDisplay.onInteraction:
        return AutovalidateMode.onUserInteraction;
      case VooFormErrorDisplay.onBlur:
      case VooFormErrorDisplay.onSubmit:
        return AutovalidateMode.disabled;
      case VooFormErrorDisplay.always:
        return AutovalidateMode.always;
    }
  }
}

/// Configuration for error display behavior
class VooFormErrorConfig {
  final VooFormErrorDisplay displayMode;
  final Duration debounceDelay;
  final bool showErrorIcon;
  final bool showErrorBorder;
  final bool shakeOnError;
  final bool focusOnFirstError;

  const VooFormErrorConfig({
    this.displayMode = VooFormErrorDisplay.onBlur,
    this.debounceDelay = const Duration(milliseconds: 1000),
    this.showErrorIcon = true,
    this.showErrorBorder = true,
    this.shakeOnError = false,
    this.focusOnFirstError = true,
  });

  /// Create a copy with modified properties
  VooFormErrorConfig copyWith({
    VooFormErrorDisplay? displayMode,
    Duration? debounceDelay,
    bool? showErrorIcon,
    bool? showErrorBorder,
    bool? shakeOnError,
    bool? focusOnFirstError,
  }) => VooFormErrorConfig(
    displayMode: displayMode ?? this.displayMode,
    debounceDelay: debounceDelay ?? this.debounceDelay,
    showErrorIcon: showErrorIcon ?? this.showErrorIcon,
    showErrorBorder: showErrorBorder ?? this.showErrorBorder,
    shakeOnError: shakeOnError ?? this.shakeOnError,
    focusOnFirstError: focusOnFirstError ?? this.focusOnFirstError,
  );

  /// Predefined configurations
  static const VooFormErrorConfig immediate = VooFormErrorConfig(displayMode: VooFormErrorDisplay.onType);

  static const VooFormErrorConfig delayed = VooFormErrorConfig(displayMode: VooFormErrorDisplay.onTypeDebounced);

  static const VooFormErrorConfig gentle = VooFormErrorConfig(showErrorIcon: false);

  static const VooFormErrorConfig strict = VooFormErrorConfig(displayMode: VooFormErrorDisplay.always, shakeOnError: true);

  static const VooFormErrorConfig submitOnly = VooFormErrorConfig(displayMode: VooFormErrorDisplay.onSubmit);
}
