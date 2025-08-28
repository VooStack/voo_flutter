import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Global settings for VooMotion animations
class VooMotionSettings {
  /// Default animation configuration
  final VooAnimationConfig defaultConfig;
  
  /// Whether to respect accessibility settings
  final bool respectAccessibilitySettings;
  
  /// Global animation speed multiplier
  final double speedMultiplier;
  
  /// Whether animations are enabled globally
  final bool enabled;
  
  const VooMotionSettings({
    this.defaultConfig = const VooAnimationConfig(),
    this.respectAccessibilitySettings = true,
    this.speedMultiplier = 1.0,
    this.enabled = true,
  });
  
  /// Apply speed multiplier to a duration
  Duration applySpeedMultiplier(Duration duration) {
    if (!enabled) return Duration.zero;
    return Duration(
      milliseconds: (duration.inMilliseconds * speedMultiplier).round(),
    );
  }
  
  /// Create a copy with modified values
  VooMotionSettings copyWith({
    VooAnimationConfig? defaultConfig,
    bool? respectAccessibilitySettings,
    double? speedMultiplier,
    bool? enabled,
  }) {
    return VooMotionSettings(
      defaultConfig: defaultConfig ?? this.defaultConfig,
      respectAccessibilitySettings: respectAccessibilitySettings ?? this.respectAccessibilitySettings,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
      enabled: enabled ?? this.enabled,
    );
  }
}

/// Provider widget for VooMotionSettings
class VooMotionSettingsProvider extends InheritedWidget {
  final VooMotionSettings settings;
  
  const VooMotionSettingsProvider({
    super.key,
    required this.settings,
    required super.child,
  });
  
  static VooMotionSettingsProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VooMotionSettingsProvider>();
  }
  
  static VooMotionSettingsProvider of(BuildContext context) {
    final provider = maybeOf(context);
    assert(provider != null, 'VooMotionSettingsProvider not found in context');
    return provider!;
  }
  
  @override
  bool updateShouldNotify(VooMotionSettingsProvider oldWidget) {
    return settings != oldWidget.settings;
  }
}

/// Extension for easy access to motion settings
extension VooMotionSettingsContext on BuildContext {
  VooMotionSettings? get motionSettings {
    return VooMotionSettingsProvider.maybeOf(this)?.settings;
  }
  
  bool get animationsEnabled {
    final settings = motionSettings;
    if (settings == null) return true;
    
    if (!settings.enabled) return false;
    
    if (settings.respectAccessibilitySettings) {
      final mediaQuery = MediaQuery.maybeOf(this);
      if (mediaQuery?.disableAnimations ?? false) {
        return false;
      }
    }
    
    return true;
  }
}