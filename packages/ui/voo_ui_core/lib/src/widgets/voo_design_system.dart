import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/design_system/design_system.dart';
import 'package:voo_ui_core/src/design_system/material_design_tokens.dart';
import 'package:voo_ui_core/src/design_system/voo_design_tokens.dart';

/// Configuration for the design system
class VooDesignSystemData {
  final DesignSystemType type;
  final bool isDarkMode;
  final ColorScheme? materialColorScheme;
  final ThemeData? customTheme;

  const VooDesignSystemData({this.type = DesignSystemType.voo, this.isDarkMode = false, this.materialColorScheme, this.customTheme});

  /// Default Voo Design System (light mode)
  static const VooDesignSystemData defaultSystem = VooDesignSystemData();

  /// Default Material Design System (light mode)
  static const VooDesignSystemData materialSystem = VooDesignSystemData(type: DesignSystemType.material);

  /// Dark Voo Design System
  static const VooDesignSystemData darkVooSystem = VooDesignSystemData(isDarkMode: true);

  /// Dark Material Design System
  static const VooDesignSystemData darkMaterialSystem = VooDesignSystemData(type: DesignSystemType.material, isDarkMode: true);

  VooDesignSystemData copyWith({DesignSystemType? type, bool? isDarkMode, ColorScheme? materialColorScheme, ThemeData? customTheme}) => VooDesignSystemData(
    type: type ?? this.type,
    isDarkMode: isDarkMode ?? this.isDarkMode,
    materialColorScheme: materialColorScheme ?? this.materialColorScheme,
    customTheme: customTheme ?? this.customTheme,
  );
}

/// Main widget for providing design system to the app
class VooDesignSystem extends StatefulWidget {
  final Widget child;
  final VooDesignSystemData data;
  final bool adaptToSystemBrightness;

  const VooDesignSystem({super.key, required this.child, required this.data, this.adaptToSystemBrightness = true});

  static VooDesignSystemState? maybeOf(BuildContext context) => context.findAncestorStateOfType<VooDesignSystemState>();

  static VooDesignSystemState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'No VooDesignSystem found in context');
    return state!;
  }

  @override
  State<VooDesignSystem> createState() => VooDesignSystemState();
}

class VooDesignSystemState extends State<VooDesignSystem> {
  late VooDesignSystemData _data;
  late DesignSystem _designSystem;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _updateDesignSystem();
  }

  @override
  void didUpdateWidget(VooDesignSystem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _data = widget.data;
      _updateDesignSystem();
    }
  }

  void _updateDesignSystem() {
    switch (_data.type) {
      case DesignSystemType.voo:
        _designSystem = VooDesignTokens(isDarkMode: _data.isDarkMode);
        break;
      case DesignSystemType.material:
        _designSystem = MaterialDesignTokens(isDarkMode: _data.isDarkMode, colorScheme: _data.materialColorScheme);
        break;
    }
  }

  /// Switch to a different design system
  void switchSystem(DesignSystemType type) {
    setState(() {
      _data = _data.copyWith(type: type);
      _updateDesignSystem();
    });
  }

  /// Toggle dark mode
  void toggleDarkMode() {
    setState(() {
      _data = _data.copyWith(isDarkMode: !_data.isDarkMode);
      _updateDesignSystem();
    });
  }

  /// Update the entire configuration
  void updateData(VooDesignSystemData data) {
    setState(() {
      _data = data;
      _updateDesignSystem();
    });
  }

  DesignSystem get designSystem => _designSystem;
  VooDesignSystemData get data => _data;

  @override
  Widget build(BuildContext context) {
    // Check system brightness if adaptation is enabled
    if (widget.adaptToSystemBrightness) {
      final brightness = MediaQuery.of(context).platformBrightness;
      final shouldBeDark = brightness == Brightness.dark;
      if (shouldBeDark != _data.isDarkMode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _data = _data.copyWith(isDarkMode: shouldBeDark);
              _updateDesignSystem();
            });
          }
        });
      }
    }

    return DesignSystemProvider(
      designSystem: _designSystem,
      systemType: _data.type,
      child: Builder(
        builder: (context) {
          // Apply theme if we have a custom theme
          if (_data.customTheme != null) {
            return Theme(data: _data.customTheme!, child: widget.child);
          }

          // Otherwise use the design system's theme
          return Theme(
            data: _designSystem.toThemeData(isDark: _data.isDarkMode),
            child: widget.child,
          );
        },
      ),
    );
  }
}

// Responsive functionality is now provided by voo_responsive package
// Use VooResponsiveBuilder and related classes from voo_responsive
